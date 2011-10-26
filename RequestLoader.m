//
//  RequestLoader.m
//  
//
//  Created by Jorge Gonzalez on 9/26/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//

#import "RequestLoader.h"
#import "Global.h"

@implementation RequestLoader
@synthesize request = _request;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithResponseLoader:(ResponseLoader*)responseLoader{
    self = [self init];
    if (self) {
        _responseDelegate = [responseLoader retain];
    }
    return self;
}

- (void)dealloc
{
    PTR_RELEASE_SAFELY(_request);
    PTR_RELEASE_SAFELY(_responseDelegate);
    [super dealloc];
}

- (void)prepRequest:(ASIHTTPRequest*)request{
    [request addRequestHeader:@"Accept" value:@"application/json"];
}

- (ASIHTTPRequest*)requestWithURL:(NSString*)stringURL delegate:(id)delegate
{
    NSURL *url = [NSURL URLWithString:stringURL];
    PTR_RELEASE_SAFELY(_request);
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setDelegate:delegate];
    [self prepRequest:_request];
    [_request retain];
    return _request;
}

- (ASIFormDataRequest*)requestFormDataWithURL:(NSString*)stringURL delegate:(id)delegate
{
    NSURL *url = [NSURL URLWithString:stringURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:delegate];
    [self prepRequest:request];
    return request;
}

- (void)asynchRequestWithURL:(NSString*)stringURL delegate:(id)delegate
{
    if ([self requestWithURL:stringURL delegate:delegate]) {
        [_request startAsynchronous];
    }
}

- (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate
{
    if ([self requestWithURL:stringURL delegate:delegate]) {
        [_request setDidFinishSelector:successCallback];
        [_request setDidFailSelector:errorCallback];
        [_request startAsynchronous];
    }
}

- (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate username:(NSString*)username password:(NSString*)password
{
   if ([self requestWithURL:stringURL delegate:delegate]) {
       [_request setDidFinishSelector:successCallback];
       [_request setDidFailSelector:errorCallback];
       [_request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
       [_request setUsername:username];
       [_request setPassword:password];
       [_request startAsynchronous];
   }
}

+ (RequestLoader*)requestLoader
{
    RequestLoader *request = [[[RequestLoader alloc] init] autorelease];
    return request;
}

+ (void)asynchRequestWithURL:(NSString*)stringURL delegate:(id)delegate
{
    RequestLoader *request = [RequestLoader requestLoader];
    [request asynchRequestWithURL:stringURL delegate:delegate];
}

+ (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate
{
    RequestLoader *request = [RequestLoader requestLoader];
    [request asynchRequestWithURL:stringURL successCallback:successCallback errorCallback:errorCallback delegate:delegate];
}

+ (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate username:(NSString*)username password:(NSString*)password
{
    RequestLoader *request = [RequestLoader requestLoader];
    [request asynchRequestWithURL:stringURL successCallback:successCallback errorCallback:errorCallback delegate:delegate username:username password:password];
}

@end
