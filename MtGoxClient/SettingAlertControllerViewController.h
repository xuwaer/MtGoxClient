//
//  SettingAlertControllerViewController.h
//  MtGoxClient
//
//  Created by Xukj on 5/2/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCellControllerViewController;

/**
 *	@brief	设置界面
 */
@interface SettingAlertControllerViewController : UIViewController
{
    @private
    NSMutableArray *mtGoxReminds;
    NSMutableArray *btcChinaReminds;
    NSMutableArray *btcEReminds;

    SettingCellControllerViewController *mtGoxCellController;           //MtGox平台，提醒列表
    SettingCellControllerViewController *btcChinaCellController;        //btcChina平台，提醒列表
    SettingCellControllerViewController *btcECellController;            //btc-E平台，提醒列表
}
@end
