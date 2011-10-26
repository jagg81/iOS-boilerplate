//
//  RequestLoader.h
//  
//
//  Created by Jorge Gonzalez on 9/26/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseLoader.h"

@interface RequestLoader : NSObject {
    ASIHTTPRequest *_request;
    ResponseLoader *_responseDelegate;
}

@property (nonatomic, readonly) ASIHTTPRequest *request;

- (id)init;
- (id)initWithResponseLoader:(ResponseLoader*)responseLoader;

+ (RequestLoader*)requestLoader;
+ (void)asynchRequestWithURL:(NSString*)stringURL delegate:(id)delegate;
+ (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate;
+ (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate username:(NSString*)username password:(NSString*)password;

- (ASIHTTPRequest*)requestWithURL:(NSString*)stringURL delegate:(id)delegate;
- (void)asynchRequestWithURL:(NSString*)stringURL delegate:(id)delegate;
- (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate;
- (void)asynchRequestWithURL:(NSString*)stringURL successCallback:(SEL)successCallback errorCallback:(SEL)errorCallback delegate:(id)delegate username:(NSString*)username password:(NSString*)password;

- (ASIHTTPRequest*)requestWithURL:(NSString*)stringURL delegate:(id)delegate;
- (ASIFormDataRequest*)requestFormDataWithURL:(NSString*)stringURL delegate:(id)delegate;
@end
