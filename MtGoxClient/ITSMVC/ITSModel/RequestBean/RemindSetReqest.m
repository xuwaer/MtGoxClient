//
//  RemindSetReqest.m
//  MtGoxClient
//
//  Created by Xukj on 5/2/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSetReqest.h"

@implementation RemindSetReqest

@synthesize token;
@synthesize plat;
@synthesize cur;
@synthesize check;
@synthesize islarge;

-(NSUInteger)tag
{
    return kActionTag_Request_Set_Remind;
}

@end
