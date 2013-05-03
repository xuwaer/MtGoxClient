//
//  DeviceUtil.m
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "DeviceUtil.h"

@implementation DeviceUtil

+(BOOL)isiPhone5Device
{
    CGRect window = [[UIScreen mainScreen] bounds];
    
    if (window.size.width == 320 && window.size.height == 480)
        return NO;
    else if (window.size.width == 320 && window.size.height == 568)
        return YES;
    else
        return NO;
}

+(void)setBackground:(UIView *)view imageiPhone:(NSString *)imageiPhone imageiPhone5:(NSString *)imageiPhone5
{
    UIImage *image = nil;
    if ([self isiPhone5Device]) {
        image = [UIImage imageNamed:imageiPhone5];
    }
    else {
        image = [UIImage imageNamed:imageiPhone];
    }
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
}

@end
