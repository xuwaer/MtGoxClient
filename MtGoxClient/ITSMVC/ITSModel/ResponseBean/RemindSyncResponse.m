//
//  RemindSyncResponse.m
//  MtGoxClient
//
//  Created by Xukj on 5/8/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSyncResponse.h"
#import "Remind.h"

#define kId @"id"
#define kToken @"token"
#define kPlatform @"platform"
#define kCurrency @"currency"
#define kCheckvalue @"checkvalue"
#define kIslarge @"islarge"
#define kUpdatetime @"updatetime"

@implementation RemindSyncResponse

@synthesize reminds;

-(void)decode
{
    if (_jSONData == nil)   return;
    
    id json = [_jSONData objectFromJSONData];
    
    if (json == nil)                                    return;
    if (![json isKindOfClass:[NSArray class]])     return;
    
    NSArray *array = (NSArray *)json;
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i++) {
        
        NSDictionary *dic = [array objectAtIndex:i];
        Remind *remind= [[Remind alloc] init];
        remind.remindId = [(NSNumber *)[dic objectForKey:kId] intValue];
        remind.platform = getPlatformWithPlatformCode([[dic objectForKey:kPlatform] UTF8String]);
        remind.currency = currencyCodeConvertToCurrencyType([[dic objectForKey:kCurrency] UTF8String]);
        remind.threshold = [(NSNumber *)[dic objectForKey:kCheckvalue] floatValue];
        remind.isLarge = [(NSNumber *)[dic objectForKey:kIslarge] boolValue];
        
        [results addObject:remind];
    }
    
    self.reminds = [NSArray arrayWithArray:results];
}

-(NSUInteger)tag
{
    return kActionTag_Response_Sync_Remind;
}


@end
