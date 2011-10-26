//
//  ResponseLoader.m
//  
//
//  Created by Jorge Gonzalez on 9/26/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//

#import "ResponseLoader.h"

@implementation ResponseLoader

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // this is how you change the default ASIHTTPRequest encoding (NSISOLatin1StringEncoding)
    //[request setResponseEncoding:NSUTF8StringEncoding];
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    NSLog(@"%@", responseData);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error description]);
}

@end
