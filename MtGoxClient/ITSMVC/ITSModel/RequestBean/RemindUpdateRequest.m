//
//  RemindUpdateRequest.m
//  MtGoxClient
//
//  Created by Xukj on 5/6/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindUpdateRequest.h"

@implementation RemindUpdateRequest

@synthesize mid;
@synthesize token;
@synthesize plat;
@synthesize cur;
@synthesize check;
@synthesize islarge;

-(NSUInteger)tag
{
    return kActionTag_Request_Update_Remind;
}

@end
