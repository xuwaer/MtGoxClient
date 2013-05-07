//
//  ConstantUtil.h
//  MtGoxClient
//
//  Created by Xukj on 5/7/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface ConstantUtil : NSObject

/**
 *	@brief	验证是否wifi连接
 *
 *	@return	验证结果
 */
+(BOOL)isWifiConnection;

/**
 *	@brief	返回当前网络状态
 *
 *	@return	3g/wifi/其他
 */
+(NSString *)getCurrentNet;

/**
 *	@brief	由于联通3G无法连接mtgox，所以需要转换。
 *          如果使用wifi连接，则直接连接mtgox服务器，如果3G则通过我们的服务器中转
 *
 *	@param 	platform 	平台
 *	@param 	currencyType 	币种
 *
 *	@return	结果
 */
+(NSString *)getRequestUrlWithPlatform:(enum Platform)platform withCurrency:(enum CurrencyType)currencyType;

@end
