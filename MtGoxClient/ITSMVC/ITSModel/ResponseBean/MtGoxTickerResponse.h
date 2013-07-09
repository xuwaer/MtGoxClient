//
//  MtGoxTickerResponse.h
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "BaseResponse.h"
#import "ITSResponse.h"

/**
 *  @brief 解析封装服务器传输过来的数据
 
    数据格式如下：
 {"result":"success","data":{"high":{"value":"166.43438","value_int":"16643438","display":"$166.43","display_short":"$166.43","currency":"USD"},"low":{"value":"140.96635","value_int":"14096635","display":"$140.97","display_short":"$140.97","currency":"USD"},"avg":{"value":"154.22970","value_int":"15422970","display":"$154.23","display_short":"$154.23","currency":"USD"},"vwap":{"value":"153.77648","value_int":"15377648","display":"$153.78","display_short":"$153.78","currency":"USD"},"vol":{"value":"202776.00809005","value_int":"20277600809005","display":"202,776.01\u00a0BTC","display_short":"202,776.01\u00a0BTC","currency":"BTC"},"last_local":{"value":"156.70000","value_int":"15670000","display":"$156.70","display_short":"$156.70","currency":"USD"},"last_orig":{"value":"156.70000","value_int":"15670000","display":"$156.70","display_short":"$156.70","currency":"USD"},"last_all":{"value":"156.70000","value_int":"15670000","display":"$156.70","display_short":"$156.70","currency":"USD"},"last":{"value":"156.70000","value_int":"15670000","display":"$156.70","display_short":"$156.70","currency":"USD"},"buy":{"value":"156.80000","value_int":"15680000","display":"$156.80","display_short":"$156.80","currency":"USD"},"sell":{"value":"156.82103","value_int":"15682103","display":"$156.82","display_short":"$156.82","currency":"USD"},"item":"BTC","now":"1366876063016195"}}
 */
@interface MtGoxTickerResponse : BaseResponse<ITSResponseDelegate>
{
    @private
    NSUInteger _tag;
    NSString *_result;
    NSDictionary *_data;
}

-(id)initWithJSONData:(NSData *)data tag:(NSUInteger)tag;

@property (nonatomic, strong, readonly)NSString *result;        // 请求结果
@property (nonatomic, strong, readonly)NSDictionary *data;           // 数据数组
@property (nonatomic) BOOL isDecodeSuccess;

@end

/**
 *  @brief 字节点解析封装
 *         关键字常量，根据MtGox Api设置
 */

extern NSString const * hightKey;
extern NSString const * lowKey;
extern NSString const * avgKey;
extern NSString const * vwapKey;
extern NSString const * volKey;
extern NSString const * lastLocalKey;
extern NSString const * lastOrigKey;
extern NSString const * lastAllKey;
extern NSString const * lastKey;
extern NSString const * buyKey;
extern NSString const * sellKey;
extern NSString const * itemKey;
extern NSString const * nowKey;

@interface MtGoxTickerDetailResponse : SubResponse<ITSResponseDelegate>
{
    @private
    NSString *_key;
    id _value;
}

@property (nonatomic, strong, readonly)NSString *key;       // 数据key
@property (nonatomic, strong, readonly)id value;            // 数据值，这里会出现多种可能性

-(id)initWithDictionary:(NSDictionary *)dic key:(NSString *)key;

@end

/**
 *  @brief 子子节点解析封装
 */
@interface MtGoxTickerValueResponse : SubResponse<ITSResponseDelegate>
{
    @private
    NSNumber *_value;
    NSNumber *_value_int;
    NSString *_display;
    NSString *_display_short;
    NSString *_currency;
}

@property (nonatomic, strong, readonly)NSNumber *value;             //价格float
@property (nonatomic, strong, readonly)NSNumber *value_int;         //价格int
@property (nonatomic, strong, readonly)NSString *display;           //显示
@property (nonatomic, strong, readonly)NSString *display_short;     //缩略显示
@property (nonatomic, strong, readonly)NSString *currency;          //币种

@end
