//
//  SettingAlertControllerViewController.h
//  MtGoxClient
//
//  Created by Xukj on 5/2/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCellControllerViewController;

@interface SettingAlertControllerViewController : UIViewController
{
    @private
    NSMutableArray *mtGoxReminds;
    NSMutableArray *btcChinaReminds;
    NSMutableArray *btcEReminds;

    SettingCellControllerViewController *mtGoxCellController;
    SettingCellControllerViewController *btcChinaCellController;
    SettingCellControllerViewController *btcECellController;
}
@end
