//
//  AppAuthenticationDelegate.h
//  
//
//  Created by Jorge Gonzalez on 9/27/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@protocol AppAuthenticationDelegate <NSObject>

// The following stuff is from the RestKit discussion board example
/**
 * A protocol defining life-cycles events for a user logging in and out
 * of the application
 */
@optional

/**
 * Sent to the delegate when sign up has completed successfully. Immediately
 * followed by an invocation of userDidLogin:
 */
//- (void)userDidSignUp:(UserModel*)user;

/**
 * Sent to the delegate when sign up failed for a specific reason
 */
//- (void)user:(UserModel*)user didFailSignUpWithError:(NSError*)error;

/**
 * Sent to the delegate when the User has successfully authenticated
 */
//- (void)userDidLogin:(UserModel*)user;

/**
 * Sent to the delegate when the User failed login for a specific reason
 */
//- (void)user:(UserModel*)user didFailLoginWithError:(NSError*)error;

/**
 * Sent to the delegate when the User logged out of the system
 */
//- (void)userDidLogout:(UserModel*)user;

@end
