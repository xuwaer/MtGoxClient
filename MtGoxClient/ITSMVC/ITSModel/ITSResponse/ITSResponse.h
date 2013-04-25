//
//  Response.h
//  FactoryMode
//
//  Created by Xukj on 3/22/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSResponseDelegate.h"

/**
 *	@brief	该类提供给外部使用
 */
@interface ITSResponse : NSObject

/**
 *	@brief	解码source。从服务器接收到的原始数据，在这里进行解码并封装。外部代码只需要调用该函数即可。
 *
 *	@param 	source 	从服务器获取的原始数据
 *
 *	@return	解码封装后的object
 */
+(id) decode:(id)source;

+(id) decode:(id)source tag:(id)tag;

@end
