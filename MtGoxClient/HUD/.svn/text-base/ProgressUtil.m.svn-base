//
//  ProgressUtil.m
//  tfsp_rc
//
//  Created by Xukj on 3/7/13.
//
//

#import "ProgressUtil.h"
#import "MBProgressHUD.h"

@implementation ProgressUtil

+(void)showProgress:(NSString *)text super:(UIView *)view
{
    
    if (view == nil) {
        return;
    }
    
    MBProgressHUD *noticeHUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:noticeHUD];
    noticeHUD.labelText = text;
    noticeHUD.mode = MBProgressHUDModeText;
    
    [noticeHUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [noticeHUD removeFromSuperview];
    }];
}

@end
