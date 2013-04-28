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
    CurrencyTypeUSD = 0,
    CurrencyTypeJPY = 1,
    CurrencyTypeEUR = 2,
    CurrencyTypeCNY = 3
};

enum Platform {
    PlatformMtGox = 0,
    PlatformBtcChina = 1,
    PlatformBtcE = 2
};

#define ThresholdCount 2

static inline NSString* platformUrl(enum Platform platform, enum CurrencyType currency)
{
    return @"";
}

// MtGox需要请求的数据
#define kMtGoxAPI_USD @"api/2/BTCUSD/money/ticker"
#define kMtGoxAPI_EUR @"api/2/BTCEUR/money/ticker"
#define kMtGoxAPI_JPY @"api/2/BTCJPY/money/ticker"
#define kMtGoxAPI_CNY @"api/2/BTCCNY/money/ticker"

#define SettingFile_Name @"Setting"
#define SettingFile_Type @"plist"

typedef struct{
    const char *name;
    const char *type;
    int lastPlatform;
    Byte *mtGoxReminds;
    Byte *btcChinaReminds;
    Byte *btcEReminds;
}PlistFile;

static inline PlistFile getSettingFile()
{
    PlistFile file;
    file.name = "Setting";
    file.type = "plist";
    
    return file;
}