//
//  AppManager.m
//  
//
//  Created by Jorge Gonzalez on 9/26/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//

#import "AppManager.h"
#import "GANTracker.h"

// Singlenton manager object
static AppManager *shareAppManager = nil;
static NSString *baseUrl = nil;

@implementation AppManager
@synthesize baseURL = _baseURL;
@synthesize apiVersion = _apiVersion;


#pragma mark - AppManager Class instance private methods

- (id)initWithBaseURL:(NSString*)url version:(NSString*)version
{
    self = [super init];
    if (self) {
        _baseURL = [url copy];
        _apiVersion = [version copy];
    }
    return self;
}

- (void)dealloc
{
    PTR_RELEASE_SAFELY(_baseURL);
    PTR_RELEASE_SAFELY(_apiVersion);
    PTR_RELEASE_SAFELY(_username);
    PTR_RELEASE_SAFELY(_password);
    [super dealloc];
}

-  (void)initializeAddons
{
    // init Google Analytics
    [[self class] startTracker];
    // init iRate
    
    // init Reachability
}

#pragma mark - AppManager Class level methods

+ (id)manager
{
    NSString *stringBaseAPIUrl;
    NSString *stringAPIVersion;
    
#ifdef __APP_CONFIG_SETTING__
    stringBaseAPIUrl = [[self class] serviceURL:__APP_CONFIG_SETTING__];
#endif
    
#ifdef __APP_API_VERSION__
    stringAPIVersion = NSLocalizedString(__APP_API_VERSION__, @"API version, if we are using one");
#endif
    
    AppManager *manager = [[[AppManager alloc] initWithBaseURL:stringBaseAPIUrl version:stringAPIVersion] autorelease];
    return manager;
}

+ (void)setShareAppManager:(AppManager*)manager
{
    if (shareAppManager) {
        PTR_RELEASE_SAFELY(shareAppManager);
    }
    shareAppManager = [manager retain];
}

+ (AppManager*)shareAppManager
{
    if (!shareAppManager) {
        AppManager *manager = [AppManager manager];
        [AppManager setShareAppManager:manager];
        PTR_RELEASE_SAFELY(baseUrl);
        baseUrl = manager.baseURL;
        [shareAppManager initializeAddons];
    }
    return shareAppManager;
}

#pragma mark - AppManager Class Helpers methods

+ (NSString*)serviceURL:(NSInteger)configSetting
{
    switch (configSetting) {
        case __APP_ENV_DEVELOPMENT__:
            return __APP_SERVICE_URL_DEVELOPMENT__;
            break;
        case __APP_ENV_QA__:
            return __APP_SERVICE_URL_QA__;
            break;
        case __APP_ENV_PRODUCTION__:
            return __APP_SERVICE_URL_PRODUCTION__;
            break;
        default:
            return nil;
            break;
    }
}

+ (BOOL)isLoggedIn {
    BOOL loggedIn = NO;
    NSString *cookieFileName = NSLocalizedString(@"", @"set the name of the cookie file");
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"%@", cookies);
    NSURL *url = [NSURL URLWithString:baseUrl];
    for (NSHTTPCookie* cookie in cookies) {
        if ([[cookie name] isEqualToString:cookieFileName] && [[cookie domain] isEqualToString:[url host]]) {
            loggedIn = YES;
        }
    }
    return loggedIn;
}

+ (void)logout {
    [ASIHTTPRequest clearSession];
}

+ (void)registerForPushNotifications
{
    if ( [AppManager isLoggedIn] )
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge)];
    }
}

+ (void)displayAlertViewWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[[UIAlertView alloc]
                           initWithTitle:title
                           message:message
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease];
    [alert show];
}


+ (BOOL) isiPad {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
    if ([[UIDevice currentDevice] respondsToSelector: @selector(userInterfaceIdiom)])
        return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
#endif
    return NO;
}

#pragma mark - AppManager Class Google Analytics wrapper methods

+ (void)startTracker
{
    ///////////////
    // Google Analytics
    [[GANTracker sharedTracker] startTrackerWithAccountID:__GANKEY__
                                           dispatchPeriod:30 // 30 second dispatch
                                                 delegate:nil];
}

+ (void)stopTracker
{
    [[GANTracker sharedTracker] stopTracker];
}

+ (void)trackEvent:(NSString*)category action:(NSString*)action
{
#if __APP_CONFIG_SETTING__ == __APP_ENV_PRODUCTION__
    [AppManager trackEvent:category action:action label:nil value:-1];
#endif
}

+ (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSInteger)value
{
#if __APP_CONFIG_SETTING__ == __APP_ENV_PRODUCTION__
    NSError* error;
    if ( ![[GANTracker sharedTracker] trackEvent:category
                                          action:action
                                           label:label
                                           value:value
                                       withError:&error] )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
#endif
}

+ (void)trackPageview:(NSString*)page
{
#if __APP_CONFIG_SETTING__ == __APP_ENV_PRODUCTION__
    NSError* error;
    if (![[GANTracker sharedTracker] trackPageview:page
                                         withError:&error])
    {
        NSLog(@"%@", [error localizedDescription]);
    }
#endif
}

#pragma mark - AppManager Class instance Helpers

- (void)resetSessionObjects
{
    PTR_RELEASE_SAFELY(_username);
    PTR_RELEASE_SAFELY(_password);
}

- (void)logoutWithDelegate:(id)delegate {
    [AppManager logout];
    [self resetSessionObjects];
    if (delegate && [delegate respondsToSelector:@selector(userDidLogout:)]) {
        [delegate performSelector:@selector(userDidLogout:) withObject:nil];
    }
}

// because ASIHTTPRequest is stupid and does not automatically add the cookie to its internal cookie storage 
- (void)setCookieSession
{
    NSString *cookieFileName = NSLocalizedString(@"", @"set the name of the cookie file");
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSURL *url = [NSURL URLWithString:baseUrl];
    for (NSHTTPCookie* cookie in cookies) {
        if ([[cookie name] isEqualToString:cookieFileName] && [[cookie domain] isEqualToString:[url host]]) {
            [ASIHTTPRequest addSessionCookie:cookie];
        }
    }
}

#pragma mark - Manager Class Request Helpers

+ (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate
{
    [RequestLoader asynchRequestWithURL:stringURL successCallback:successCallback errorCallback:errorCallback delegate:delegate];
}

#pragma mark - Utils for Universal iOS projects

- (NSString*) fileNameWithBaseName:(NSString*)fileName withExtention:(NSString*)extentionName
{
    if (!fileName) { return fileName; }
    NSMutableString *newFileName = [NSMutableString stringWithString:fileName];
    if ([[self class] isiPad]) {
        [newFileName appendString:@"-iPad"];
    }
    if (extentionName) {
        [newFileName appendString:@"."];
        [newFileName appendString:extentionName];
    }
    return newFileName;    
}

#pragma mark - API Discovery

// Basic Auth Helper
- (void)authenticateWithUsername:(NSString*)username password:(NSString*)password delegate:(id<AppAuthenticationDelegate>)delegate
{
    NSString *uri = NSLocalizedString(@"", @"he goes the uri for basic auth");
    PTR_RELEASE_SAFELY(_username);
    PTR_RELEASE_SAFELY(_password);
    _username = [[NSString stringWithString:username] retain];
    _password = [[NSString stringWithString:password] retain];
    _authDelegate = delegate;
    [RequestLoader asynchRequestWithURL:uri successCallback:@selector(requestFinished:)errorCallback:@selector(requestFailed:) delegate:self username:_username password:_password];
}


#pragma mark - General ASIHTTPRequest Callbacks examples

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // this is how you change the default ASIHTTPRequest encoding (NSISOLatin1StringEncoding)
    //[request setResponseEncoding:NSUTF8StringEncoding];

    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    //NSDictionary *dataModel = [responseString objectFromJSONString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error description]);
}

@end
