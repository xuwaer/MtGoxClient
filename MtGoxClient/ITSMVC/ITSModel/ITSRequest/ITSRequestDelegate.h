//
//  RequestDelegate.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import <Foundation/Foundation.h>

/**
 *	@brief	编码器能够识别的对象，所有的request实体类必须实现该委托
 */
@protocol ITSRequestDelegate <NSObject>

/**
 *	@brief	编码功能，具体实现方式在各个对象中体现
 *
 *	@return	编码后的结果。服务器能够识别的代码。
 */
-(id) encode;

/**
 *	@brief	标识，区分不同的对象。
 *
 *	@return	对象号码
 */
-(NSUInteger)tag;

@end
