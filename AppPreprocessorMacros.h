//
//  AppPreprocessorMacros.h
//  
//
//  Created by Jorge Gonzalez on 9/26/11.
//  Copyright 2011 Jorge Gonzalez. All rights reserved.
//


#define PTR_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
