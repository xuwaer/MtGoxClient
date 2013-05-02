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

-(void)request:(ASIHTTPRequest *)request didReceiveObject:(id)object
{
    
    DDLogCVerbose(@"%@(%@)tag:%d", NSStringFromClass([self class]), THIS_METHOD, [(id<ITSResponseDelegate>)object tag]);
    
    NSUInteger resultTag = [self getContextTag:request];
    
    [self performContext:resultTag object:object];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    DDLogCVerbose(@"%@(%@)", NSStringFromClass([self class]), THIS_METHOD);
    
    NSUInteger resultTag = [self getContextTag:request];
    TargetContext *context = [self getContext:resultTag];
    [self removeContext:resultTag];
    
    
    if (context && context.target && context.selector) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [context.target performSelector:context.selector withObject:[NSNull null]];
#pragma clang diagnostic pop
        });
    }
}

@end
