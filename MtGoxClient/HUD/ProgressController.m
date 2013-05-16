//
//  ProgressUtil.m
//  MtGoxClient
//
//  Created by Xukj on 5/7/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "ProgressController.h"
#import "MBProgressHUD.h"

@implementation ProgressController

@synthesize view;

-(id)initWithView:(UIView *)inView
{
    self = [self init];
    
    if (self) {
        self.view = inView;
    }
    
    return self;
}

/**
 *	@brief	显示菊花
 */
-(void)showProgress
{
    [self showProgress:nil];
}

-(void)showProgress:(NSString *)title
{
    [self showProgress:title userinfo:nil];
}

-(void)showProgress:(NSString *)title userinfo:(NSDictionary *)inUserinfo
{
    if (progress && progress.isHidden == YES) {
        progress.hidden = NO;
    }
    else {
        progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progress];
        progress.mode = MBProgressHUDModeIndeterminate;
        [progress show:YES];
    }
    
    if (title)
        progress.labelText = title;
    
    if (inUserinfo)
        userinfo = [NSDictionary dictionaryWithDictionary:inUserinfo];
}

/**
 *	@brief	隐藏菊花
 */
-(NSDictionary *)hideProgress
{
    if (progress && progress.isHidden == NO)
        progress.hidden = YES;
    
    return userinfo;
}

/**
 *	@brief	销毁菊花
 */
-(NSDictionary *)destroyProgress
{
    if (progress)
        [progress removeFromSuperview];
    
    progress = nil;
    return userinfo;
}

/**
 *	@brief	显示提示文字，停留2秒
 *
 *	@param 	title 	文字内容
 */
-(void)showToast:(NSString *)title
{
    if (toast == nil) {
        toast = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:toast];
        toast.labelText = title;
        toast.mode = MBProgressHUDModeText;
        
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [toast removeFromSuperview];
            toast = nil;
        }];
    }
}

@end
