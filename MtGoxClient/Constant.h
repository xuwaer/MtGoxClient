//
//  Constant.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>

// 币种
enum CurrencyType {
    CurrencyTypeUSD,
    CurrencyTypeJPY,
    CurrencyTypeEUR,
    CurrencyTypeCNY
};

enum Platform {
    PlatformMtGox,
    PlatformBtcChina,
    PlatformBtcE
};

// MtGox需要请求的数据
#define kMtGoxAPI_USD @"api/2/BTCUSD/money/ticker"
#define kMtGoxAPI_EUR @"api/2/BTCEUR/money/ticker"
#define kMtGoxAPI_JPY @"api/2/BTCJPY/money/ticker"
#define kMtGoxAPI_CNY @"api/2/BTCCNY/money/ticker"