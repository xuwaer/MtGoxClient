//
//  Remind.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

/**
 *	@brief	提醒数据结构
 */
@interface Remind : NSObject
{
    @private
    NSDictionary *_dataSource;
}

@property (nonatomic, assign)int remindId;
@property (nonatomic, assign)float threshold;                   //阀值
@property (nonatomic, assign)enum CurrencyType currency;        //币种
@property (nonatomic, assign)BOOL isLarge;                      //大于？
@property (nonatomic, assign)enum Platform platform;            //平台

@property (nonatomic, assign)NSUInteger tag;        //标识（非必须项）

/**
 *	@brief	从plist中读取到的原始数据为NSDictionary结构，需要对此结构进行解析并封装成可以使用的对象
 *
 *	@param 	dataSource 	原始数据
 *
 *	@return	
 */
-(id)initWithDictionary:(NSDictionary *)dataSource;

/**
 *	@brief	把该对象转换成可以存入plist的数据结构
 *
 *	@return	转换后的数据结构，可直接存入plist
 */
-(NSDictionary *)encode;

@end
