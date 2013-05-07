//
//  MtGoxMoneyTicker.m
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "MtGoxTickerRequest.h"
#import "ConstantUtil.h"

@implementation MtGoxTickerRequest

-(id)init
{
    return [self initWithCurrency:CurrencyTypeUSD];
}

-(id)initWithCurrency:(enum CurrencyType)inCurrencyType
{
    currencyType = inCurrencyType;
    
    NSString *requestStr = [ConstantUtil getRequestUrlWithPlatform:PlatformMtGox withCurrency:inCurrencyType];
//    const char * requestChar = getRequestUrl(PlatformMtGox, inCurrencyType);
//    NSString *requestStr = [NSString stringWithCString:requestChar encoding:NSUTF8StringEncoding];
    
    self = [super initWithCommand:requestStr type:HttpRequestTypeGet];
    return self;
}

-(NSUInteger)tag
{
    NSUInteger requestTag = kActionTag_Request_USD;
    
    switch (currencyType) {
        case CurrencyTypeUSD:
            requestTag = kActionTag_Request_USD;
            break;
        case CurrencyTypeEUR:
            requestTag = kActionTag_Request_EUR;
            break;
        case CurrencyTypeJPY:
            requestTag = kActionTag_Request_JPY;
            break;
        case CurrencyTypeCNY:
            requestTag = kActionTag_Request_CNY;
            break;
        default:
            requestTag = kActionTag_Request_USD;
            break;
    }
    
    return requestTag;
}

@end
