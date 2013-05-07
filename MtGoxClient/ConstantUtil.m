//
//  ConstantUtil.m
//  MtGoxClient
//
//  Created by Xukj on 5/7/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "ConstantUtil.h"
#import "Reachability.h"

@implementation ConstantUtil

+ (BOOL)isWifiConnection
{
    // This class is from apple library.
    // For detail, see in apple develop wesite.
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    if ([r currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSString *)getCurrentNet
{
    // This class is from apple library.
    // For detail, see in apple develop wesite.
    
    NSString* result = nil;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:// 没有网络连接
            result=nil;
            break;
        case ReachableViaWWAN:// 使用3G网络
            result=@"3g";
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            result=@"wifi";
            break;
    }
    return result;
}

+(NSString *)getRequestUrlWithPlatform:(enum Platform)platform withCurrency:(enum CurrencyType)currencyType
{
    NSString *requestStr;
    // 目前测试仅mtgox需要作此中转操作
    if (platform == PlatformMtGox) {
        // 如果使用wifi，则直接连接mtgox服务器
        if ([self isWifiConnection]) {
            const char * requestChar = getRequestUrl(PlatformMtGox, currencyType);
            requestStr = [NSString stringWithCString:requestChar encoding:NSUTF8StringEncoding];
            requestChar = NULL;
        }
        // 如果使用3g则使用本地服务器中转
        else {
            const char * requestChar = getLocalRequestUrl(currencyType);
            requestStr = [NSString stringWithCString:requestChar encoding:NSUTF8StringEncoding];
            requestChar = NULL;
        }
    }
    
    return requestStr;
}

@end
