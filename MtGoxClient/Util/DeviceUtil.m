//
//  DeviceUtil.m
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "DeviceUtil.h"

@implementation DeviceUtil

+(enum ScreenType)getDeviceScrenType
{
    CGRect window = [[UIScreen mainScreen] bounds];
    
    if (window.size.width == 320 && window.size.height == 480)
        return ScreenType_3_5_Inch;
    else if (window.size.width == 320 && window.size.height == 568)
        return ScreenType_4_Inch;
    else
        return ScreenType_3_5_Inch;
}

+(void)view:(UIView *)view image35inch:(NSString *)image35inchName image4inch:(NSString *)image4inchName
{
    UIImage *image = nil;
    
    switch ([self getDeviceScrenType]) {
        case ScreenType_3_5_Inch:
            image = [UIImage imageNamed:image35inchName];
            break;
        case ScreenType_4_Inch:
            image = [UIImage imageNamed:image4inchName];
            break;
        default:
            image = [UIImage imageNamed:image35inchName];
            break;
    }
        
    [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
}

@end
