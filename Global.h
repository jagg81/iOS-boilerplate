//
//  Global.h
//  
//
//  Created by Jorge Gonzalez on 9/26/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppPreprocessorMacros.h"
#import "RequestLoader.h"
#import "JSONKit.h"

#define __APP_ENV_DEVELOPMENT__      1 << 0 //1
#define __APP_ENV_QA__               1 << 1 //2
#define __APP_ENV_PRODUCTION__       1 << 2 //4

#define __APP_SERVICE_URL_DEVELOPMENT__     @"http://localhost:8080"
#define __APP_SERVICE_URL_QA__              @"https://qa.test.com"
#define __APP_SERVICE_URL_PRODUCTION__      @"https://www.test.com"

#define __APP_API_VERSION__                 @"version-1"    // in case you do REST API versioning this way...

// Your Google Analytics key here
#define __GANKEY__ @""

/*****************************************************************************
 *                            *** IMPORTANT ***
 *          UNCOMMENT ONLY THE SETTING FOR WHICH YOU WANT TO BUILD
 *                          SHOULD BE ONLY ONE DEFINE!!!
 *
 *****************************************************************************/
//#define __APP_CONFIG_SETTING__          __APP_ENV_DEVELOPMENT__
#define __APP_CONFIG_SETTING__          __APP_ENV_QA__
//#define __APP_CONFIG_SETTING__          __APP_ENV_PRODUCTION__
