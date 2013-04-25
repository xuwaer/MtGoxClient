//
//  ResponseDelegate.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import <Foundation/Foundation.h>

/**
 *	@brief	解码器能够识别的对象，所有的response实体类必须实现该委托
 */
@protocol ITSResponseDelegate <NSObject>

/**
 *	@brief	解码功能，具体实现方式在各个对象中体现
 */
-(void) decode;

/**
 *	@brief	标识，区分不同的对象。
 *
 *	@return	对象号码
 */
-(NSUInteger)tag;

@end
