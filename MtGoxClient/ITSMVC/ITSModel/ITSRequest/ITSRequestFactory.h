//
//  RequestFactory.h
//  tfsp_rc
//
//  Created by Xukj on 3/22/13.
//
//

#import <Foundation/Foundation.h>
#import "ITSRequestDelegate.h"

/**
 *	@brief	抽象工厂，生成不同类型的编码工具。由项目所使用的请求类型、连接方式而定
 */
@interface ITSRequestFactory : NSObject

/**
 *	@brief	生成编码工厂
 *
 *	@return	编码工厂
 */
+(ITSRequestFactory *)factory;

/**
 *	@brief	编码。所有工厂必须实现该方法。
 *
 *	@return	编码结果
 */
-(id)encode:(id<ITSRequestDelegate>) source;

@end
