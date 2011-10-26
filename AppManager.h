//
//  AppManager.h
//  
//
//  Created by Jorge Gonzalez on 9/26/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@protocol AppAuthenticationDelegate;

@interface AppManager : NSObject {
    NSString *_baseURL;
    NSString *_apiVersion;
    NSString *_cookieFileName;
    
    NSString *_username;
    NSString *_password;
    
    id<AppAuthenticationDelegate> _authDelegate;
}

@property (nonatomic, readonly) NSString* baseURL;
@property (nonatomic, readonly) NSString* apiVersion;

// Init Manager
+ (AppManager*)shareAppManager;
+ (void)setShareAppManager:(AppManager*)manager;
+ (id)manager;

+ (NSString*)serviceURL:(NSInteger)configSetting;
// Helper to detect if a user is logged in (using NSHTTPCookieStorage)
+ (BOOL)isLoggedIn;
// Helper for registering for push notifications (using Urban )
+ (void)registerForPushNotifications;

// Google Analytics wrapper methods
+ (void)startTracker;
+ (void)stopTracker;
+ (void)trackEvent:(NSString*)category action:(NSString*)action;
+ (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSInteger)value;
+ (void)trackPageview:(NSString*)page;

// detect iOS device (useful for Universal iOS builds)
+ (BOOL) isiPad;

// one-liner helper for asynch GET
+ (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate;

// class utils
+ (void)displayAlertViewWithTitle:(NSString*)title message:(NSString*)message;

// user Basic Auth helper
- (void)authenticateWithUsername:(NSString*)username password:(NSString*)password delegate:(id<AppAuthenticationDelegate>)delegate;

@end
