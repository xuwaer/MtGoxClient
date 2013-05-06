//
//  DeviceUtil.h
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ScreenType {
    ScreenType_3_5_Inch = 0,
    ScreenType_4_Inch = 1
};

#define IOS_VER_5 [UIS]

@interface DeviceUtil : NSObject

+(enum ScreenType)getDeviceScrenType;

+(void)view:(UIView *)view image35inch:(NSString *)image35inchName image4inch:(NSString *)image4inchName;

@end
