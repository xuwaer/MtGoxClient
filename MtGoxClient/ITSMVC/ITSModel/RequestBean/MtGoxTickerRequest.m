//
//  MtGoxMoneyTicker.m
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "MtGoxTickerRequest.h"

@implementation MtGoxTickerRequest

-(id)init
{
    return [self initWithCurrency:CurrencyTypeUSD];
}

-(id)initWithCurrency:(enum CurrencyType)inCurrencyType
{
    currencyType = inCurrencyType;
    
    switch (currencyType) {
        case CurrencyTypeUSD:
            self = [super initWithCommand:kMtGoxAPI_USD type:HttpRequestTypeGet];
            break;
        case CurrencyTypeEUR:
            self = [super initWithCommand:kMtGoxAPI_EUR type:HttpRequestTypeGet];
            break;
        case CurrencyTypeJPY:
            self = [super initWithCommand:kMtGoxAPI_JPY type:HttpRequestTypeGet];
            break;
        case CurrencyTypeCNY:
            self = [super initWithCommand:kMtGoxAPI_CNY type:HttpRequestTypeGet];
            break;
        default:
            self = [super initWithCommand:kMtGoxAPI_USD type:HttpRequestTypeGet];
            break;
    }
    
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
