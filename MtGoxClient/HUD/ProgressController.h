//
//  ProgressUtil.h
//  MtGoxClient
//
//  Created by Xukj on 5/7/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

/**
 *	@brief	提示框控制器
 */
@interface ProgressController : NSObject
{
    @private
    MBProgressHUD *progress;
    MBProgressHUD *toast;
    
    NSDictionary *userinfo;
}

@property (nonatomic, strong)UIView *view;

-(id)initWithView:(UIView *)view;

/**
 *	@brief	显示菊花
 */
-(void)showProgress;

/**
 *	@brief	显示菊花
 */
-(void)showProgress:(NSDictionary *)inUserinfo;

/**
 *	@brief	隐藏菊花
 */
-(NSDictionary *)hideProgress;

/**
 *	@brief	销毁菊花
 */
-(NSDictionary *)destroyProgress;

/**
 *	@brief	显示提示文字，停留2秒
 *
 *	@param 	title 	文字内容
 */
-(void)showToast:(NSString *)title;

@end
