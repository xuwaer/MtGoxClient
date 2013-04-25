//
//  Request.h
//  tfsp_rc
//
//  Created by Xukj on 3/22/13.
//
//

#import <Foundation/Foundation.h>
#import "ITSRequestDelegate.h"

/**
 *	@brief	该类提供给外部使用
 */
@interface ITSRequest : NSObject

/**
 *	@brief	编码object，为发送请求作准备。外部代码只需要调用该函数即可。
 *
 *	@param 	source 	需要编码发送的object
 *
 *	@return	编码后的生成结果。这里会有多种类型，具体的返回类型，视不同的工厂方法而定
 */
+(id) encode:(id<ITSRequestDelegate>)source;

@end
