//
//  RemindSetResponse.m
//  MtGoxClient
//
//  Created by Xukj on 5/2/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSetResponse.h"

#define kId @"id"

@implementation RemindSetResponse

@synthesize remindID;

-(void)decode
{
    if (_jSONData == nil)   return;
    
    id json = [_jSONData objectFromJSONData];
    
    if (json == nil)                                    return;
    if (![json isKindOfClass:[NSDictionary class]])     return;
    
    NSDictionary *dic = (NSDictionary *)json;
    
    @try {
        self.remindID = [(NSNumber *)[dic objectForKey:kId] intValue];
    }
    @catch (NSException *exception) {
        // 如果返回失败，则使用默认值-1表示
        self.remindID = -1;
    }
}

-(NSUInteger)tag
{
    return kActionTag_Response_Set_Remind;
}

@end
