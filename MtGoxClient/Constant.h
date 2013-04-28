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

/**
 *	@brief	通过币种代码，转换为显示文字
 *
 *	@param 	currencyType 	币种代码
 *
 *	@return	显示文字
 */
static inline const char * currencyTypeConvertToCurrencyName(enum CurrencyType currencyType)
{
    const char * currencyName = "";
    
    switch (currencyType) {
        case CurrencyTypeUSD:
            currencyName = "美元";
            break;
        case CurrencyTypeEUR:
            currencyName = "欧元";
            break;
        case CurrencyTypeJPY:
            currencyName = "日元";
            break;
        case CurrencyTypeCNY:
            currencyName = "人民币";
            break;
        default:
            break;
    }
    
    return currencyName;
}

/**
 *	@brief	通过显示文字转换为币种代码
 *
 *	@param 	currencyName 	显示文字
 *
 *	@return	币种代码
 */
static inline enum CurrencyType currencyNameConvertToCurrencyType(const char * currencyName)
{
    int currencyType = -1;
    
    if (strcmp(currencyName, "美元"))
        currencyType = CurrencyTypeUSD;
    else if (strcmp(currencyName, "日元"))
        currencyType = CurrencyTypeJPY;
    else if (strcmp(currencyName, "欧元"))
        currencyType = CurrencyTypeEUR;
    else if (strcmp(currencyName, "人民币"))
        currencyType = CurrencyTypeCNY;

    return currencyType;
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