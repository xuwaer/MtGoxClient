//
//  MtGoxTickerResponse.m
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "MtGoxTickerResponse.h"

#define kResult @"result"
#define kData @"data"

@implementation MtGoxTickerResponse

@synthesize result = _result;
@synthesize data = _data;

-(id)initWithJSONData:(NSData *)data tag:(NSUInteger)tag
{
    _tag = tag;
    
    return [super initWithJSONData:data];
}

-(void)decode
{
    if (_jSONData == nil)   return;
  
    id json = [_jSONData objectFromJSONData];
    
    if (json == nil)                                    return;
    if (![json isKindOfClass:[NSDictionary class]])     return;
    
    NSDictionary *dic = (NSDictionary *)json;
    
    _result = [dic valueForKey:kResult];
    NSDictionary *tickerList = [dic valueForKey:kData];
    if (tickerList == nil) return;
    
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    
    NSArray *keys = [tickerList allKeys];
    
    for (NSString *key in keys) {
        
        MtGoxTickerDetailResponse *response =
                    [[MtGoxTickerDetailResponse alloc]
                     initWithDictionary:[tickerList objectForKey:key]
                     key:key];
        
        [response decode];
        [datas addObject:response];
    }
    
    _data = datas;
}

-(NSUInteger)tag
{
    return _tag;
}

@end

@implementation MtGoxTickerDetailResponse

@synthesize key = _key;
@synthesize value = _value;

-(id)initWithDictionary:(NSDictionary *)dic key:(NSString *)key
{
    _key = key;
    return [super initWithDictionary:dic];
}

-(void)decode
{
    if (_subDic == nil)     return;
    
    if (![_subDic isKindOfClass:[NSDictionary class]]) {
        _value = _subDic;
        return;
    }
    
    MtGoxTickerValueResponse *valueResponse = [[MtGoxTickerValueResponse alloc] initWithDictionary:_subDic];
    [valueResponse decode];
    _value = valueResponse;
}

-(NSUInteger)tag
{
    return -1;
}

@end


#define kValue @"value"
#define kValue_int @"value_int"
#define kDisplay @"display"
#define kDisplay_short @"display_short"
#define kCurrency @"currency"

@implementation MtGoxTickerValueResponse

@synthesize value = _value;
@synthesize value_int = _value_int;
@synthesize display = _display;
@synthesize display_short = _display_short;
@synthesize currency = _currency;

-(void)decode
{
    if (_subDic == nil)     return;
    
    _value = [_subDic objectForKey:kValue];
    _value_int = [_subDic objectForKey:kValue_int];
    _display = [_subDic objectForKey:kDisplay];
    _display_short = [_subDic objectForKey:kDisplay_short];
    _currency = [_subDic objectForKey:kCurrency];
}

-(NSUInteger)tag
{
    return -1;
}

@end