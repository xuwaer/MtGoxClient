//
//  MtGoxMoneyTicker.m
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "MtGoxTickerRequest.h"

// MtGox需要请求的数据
#define kUSD @"api/2/BTCUSD/money/ticker"
#define kEUR @"api/2/BTCEUR/money/ticker"
#define kJPY @"api/2/BTCJPY/money/ticker"
#define kCNY @"api/2/BTCCNY/money/ticker"

@implementation MtGoxTickerRequest

-(id)init
{
    return [self initWithCurrency:USD];
}

-(id)initWithCurrency:(enum CurrencyType)inCurrencyType
{
    currencyType = inCurrencyType;
    
    switch (currencyType) {
        case USD:
            self = [super initWithCommand:kUSD type:HttpRequestTypeGet];
            break;
        case EUR:
            self = [super initWithCommand:kEUR type:HttpRequestTypeGet];
            break;
        case JPY:
            self = [super initWithCommand:kJPY type:HttpRequestTypeGet];
            break;
        case CNY:
            self = [super initWithCommand:kCNY type:HttpRequestTypeGet];
            break;
        default:
            self = [super initWithCommand:kUSD type:HttpRequestTypeGet];
            break;
    }
    
    return self;
}

-(NSUInteger)tag
{
    NSUInteger requestTag = kActionTag_Request_USD;
    
    switch (currencyType) {
        case USD:
            requestTag = kActionTag_Request_USD;
            break;
        case EUR:
            requestTag = kActionTag_Request_EUR;
            break;
        case JPY:
            requestTag = kActionTag_Request_JPY;
            break;
        case CNY:
            requestTag = kActionTag_Request_CNY;
            break;
        default:
            requestTag = kActionTag_Request_USD;
            break;
    }
    
    return requestTag;
}

@end
