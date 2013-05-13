//
//  RemindSyncRequest.m
//  MtGoxClient
//
//  Created by Xukj on 5/8/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSyncRequest.h"

@implementation RemindSyncRequest

@synthesize token;

-(NSUInteger)tag
{
    return kActionTag_Request_Sync_Remind;
}

@end
