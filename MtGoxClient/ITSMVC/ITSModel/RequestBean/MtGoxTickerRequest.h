//
//  MtGoxMoneyTicker.h
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "BaseRequest.h"

// 币种
enum CurrencyType {
    USD,
    JPY,
    EUR,
    CNY
};


/**
 *	@brief	请求交易行情bean
 *          这里需要注意，
 *          1.请求后返回值为gzip，需要解压
 *          2.请求必须为GET
 *          3.使用最新的API2请求方式，之前的方式抛弃掉
 */
@interface MtGoxTickerRequest : BaseRequest
{
    enum CurrencyType currencyType;
}

-(id)initWithCurrency:(enum CurrencyType)inCurrencyType;

@end
