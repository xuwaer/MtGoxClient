//
//  BaseResponseModel.h
//  FactoryMode
//
//  Created by Xukj on 3/22/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSResponseDelegate.h"

/**
 *	@brief	抽象工厂，生成不同类型的解码工具。由项目所使用的响应类型、连接方式而定
 */
@interface ITSResponseFactory : NSObject

/**
 *	@brief	生成解码工厂
 *
 *	@return	解码工厂
 */
+(ITSResponseFactory *)factory;

/**
 *	@brief	所有解码工厂，必须实现该方法
 *
 *	@param 	source 	服务器响应的数据
 *	@param 	tag 	标识。自定义
 *
 *	@return	解码结果对象
 */
-(id<ITSResponseDelegate>)decode:(NSData *)source tag:(id)tag;

@end
