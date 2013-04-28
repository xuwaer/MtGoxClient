//
//  AppDelegate.h
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserDefault;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @private
    UserDefault *userDefault;
}

@property (strong, nonatomic) UIWindow *window;

@end
