//
//  RemindDelResponse.m
//  MtGoxClient
//
//  Created by Xukj on 5/6/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindDelResponse.h"

#define kResult @"result"

@implementation RemindDelResponse

@synthesize result;

-(void)decode
{
    if (_jSONData == nil)   return;
    
    id json = [_jSONData objectFromJSONData];
    
    if (json == nil)                                    return;
    if (![json isKindOfClass:[NSDictionary class]])     return;
    
    NSDictionary *dic = (NSDictionary *)json;
    
    @try {
        
        NSString *resultStr = [dic objectForKey:kResult];
        if ([resultStr isEqualToString:@"success"])
            self.result = YES;
        else
            self.result = NO;
    }
    @catch (NSException *exception) {
        // 如果返回失败，则使用默认值-1表示
        self.result = NO;
    }
}

-(NSUInteger)tag
{
    return kActionTag_Response_Delete_Remind;
}

@end
