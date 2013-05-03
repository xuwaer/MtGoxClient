//
//  UIDevice+Platform.h
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

-(NSString *)platform;
-(NSString *)platformString;
-(BOOL)hasRetinaDisplay;
-(BOOL)hasMultitasking;
-(BOOL)hasCamera;

@end
