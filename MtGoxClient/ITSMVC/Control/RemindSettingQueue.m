//
//  RemindSettingQueue.m
//  MtGoxClient
//
//  Created by Xukj on 4/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSettingQueue.h"
#import "MtGoxTickerResponse.h"
#import "Remind.h"

@implementation RemindSettingQueue

-(void)sendRequest:(BaseRequest *)request target:(id)target selector:(SEL)selector remind:(Remind *)inRemind
{
    _remind = inRemind;
    [self sendRequest:request target:target selector:selector];
}

-(Remind *)remind
{
    return _remind;
}

-(BOOL)checkResponse:(int)actionTag
{
    if (actionTag == kActionTag_Request_USD && self.remind.currency == CurrencyTypeUSD)
        return YES;
    
    if (actionTag == kActionTag_Request_EUR && self.remind.currency == CurrencyTypeEUR)
        return YES;
    
    if (actionTag == kActionTag_Request_JPY && self.remind.currency == CurrencyTypeJPY)
        return YES;
    
    if (actionTag == kActionTag_Request_CNY && self.remind.currency == CurrencyTypeCNY)
        return YES;
    
    return NO;
}

@end
