//
//  RemindDelRequest.m
//  MtGoxClient
//
//  Created by Xukj on 5/6/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindDelRequest.h"

@implementation RemindDelRequest

@synthesize mid;

-(NSUInteger)tag
{
    return kActionTag_Request_Delete_Remind;
}

@end
