//
//  UINavigationBar+CustomNav.m
//  MtGoxClient
//
//  Created by Xukj on 5/6/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "UINavigationBar+CustomNav.h"

@implementation UINavigationBar (CustomNav)

-(void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_nav.png"];
    [backgroundImage drawInRect:CGRectMake(0, 0, 320, 44)];
}

@end
