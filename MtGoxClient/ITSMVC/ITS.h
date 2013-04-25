//
//  ITS.h
//  MVCStruct
//
//  Created by Xukj on 3/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "TransManager.h"
#import "ITSConfig.h"
#import "ITSRequest.h"
#import "ITSResponse.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

