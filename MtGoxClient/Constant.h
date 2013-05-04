//
//  Constant.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string.h>
#include <stdio.h>

//配置文件地址
#define SettingFile @"Setting.plist"

// 币种
enum CurrencyType {
    CurrencyTypeUSD = 0,
    CurrencyTypeJPY = 1,
    CurrencyTypeEUR = 2,
    CurrencyTypeCNY = 3
};

// 平台
enum Platform {
    PlatformMtGox = 0,
    PlatformBtcChina = 1,
    PlatformBtcE = 2
};

// 提醒请求类型
enum RemindType {
    RemindType_SetAlert = 0,
    RemindType_DelAlert = 1,
    RemindType_GetAlert = 2
};

static const int ThresholdCount = 2;            //提醒个数
static const int REPEAT_DELAY = 30;             //自动刷新间隔

#define DEFAULT_TOKEN @"abc00fea0ff7717e36c0b4837b4e840678ad046fd67d895ad4235a901cc54c33"
//#define REMIND_HOSTNAME @"http://10.10.32.44"

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
 *	@brief	通过币种代码，转换为国际代码
 *
 *	@param 	currencyType 	币种代码
 *
 *	@return	国际代码
 */
static inline const char * currencyTypeConvertToCurrencyCode(enum CurrencyType currencyType)
{
    const char * currencyName = "";
    
    switch (currencyType) {
        case CurrencyTypeUSD:
            currencyName = "USD";
            break;
        case CurrencyTypeEUR:
            currencyName = "EUR";
            break;
        case CurrencyTypeJPY:
            currencyName = "JPY";
            break;
        case CurrencyTypeCNY:
            currencyName = "CNY";
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

/**
 *	@brief	根据平台，获取对应的平台代号
 *
 *	@param 	platform 	平台代码
 *
 *	@return	平台代号
 */
static inline const char * getPlatformCodeWithPlatform(enum Platform platform)
{
    const char * platformCode = "";
    switch (platform) {
        case PlatformMtGox:
            platformCode = "mtgox";
            break;
        case PlatformBtcChina:
            platformCode = "";
            break;
        case PlatformBtcE:
            platformCode = "";
            break;
        default:
            break;
    }
    
    return platformCode;
}

/**
 *	@brief	根据平台，获取对应的服务器地址
 *
 *	@param 	platform 	平台代码
 *
 *	@return	服务器地址
 */
static inline const char * getHostnameWithPlatform(enum Platform platform)
{
    const char * hostname = "";
    switch (platform) {
        case PlatformMtGox:
            hostname = "https://data.mtgox.com";
            break;
        case PlatformBtcChina:
            hostname = "";
            break;
        case PlatformBtcE:
            hostname = "";
            break;
        default:
            break;
    }
    
    return hostname;
}

/**
 *	@brief	根据币种，获取对应的请求url
 *
 *	@param 	currencyType 	币种
 *
 *	@return	请求url
 */
static inline const char * getRequestUrl(enum Platform platform, enum CurrencyType currencyType)
{
    const char *hostname = getHostnameWithPlatform(platform);
    char *requestUrl = calloc(80, sizeof(char));
    strcpy(requestUrl, hostname);
    
    switch (currencyType) {
        case CurrencyTypeUSD:
            strcat(requestUrl, "/api/2/BTCUSD/money/ticker");
            break;
        case CurrencyTypeEUR:
            strcat(requestUrl, "/api/2/BTCEUR/money/ticker");
            break;
        case CurrencyTypeJPY:
            strcat(requestUrl, "/api/2/BTCJPY/money/ticker");
            break;
        case CurrencyTypeCNY:
            strcat(requestUrl, "/api/2/BTCCNY/money/ticker");
            break;
        default:
            strcat(requestUrl, "/api/2/BTCUSD/money/ticker");
            break;
    }
    
    return requestUrl;
}

/**
 *	@brief	根据类型，获取对应的请求url
 *
 *	@param 	remindType 	提醒请求类型
 *
 *	@return	请求url
 */
static inline const char * getRemindServerRequestUrl(enum RemindType remindType)
{
    const char *hostname = "http://10.10.32.44";
    
    char *requestUrl = calloc(80, sizeof(char));
    strcpy(requestUrl, hostname);
    
    switch (remindType) {
        case RemindType_SetAlert:
            strcat(requestUrl, "/btc_set_alert.php");
            break;
        case RemindType_DelAlert:
            strcat(requestUrl, "");
            break;
        case RemindType_GetAlert:
            strcat(requestUrl, "");
            break;
        default:
            strcat(requestUrl, "");
            break;
    }
    
    return requestUrl;
}