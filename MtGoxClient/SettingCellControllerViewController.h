//
//  SettingCellControllerViewController.h
//  MtGoxClient
//
//  Created by Xukj on 5/2/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindSettingController.h"

@class SettingAlertControllerViewController;

/**
 *	@brief	设置界面group
 */
@interface SettingCellControllerViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate, RemindSettingDelegate>
{
    @private
    NSMutableArray *dataSource;     //显示用数据源
}

@property (nonatomic, strong)IBOutlet UITableView *alertTableView;      //提醒列表
@property (nonatomic, strong)IBOutlet UIView *headerView;               //提醒group头
@property (nonatomic, strong)IBOutlet UILabel *headerTitleLabel;

@property (nonatomic, strong)NSMutableArray *dataArray;                 //原始数据源

@property (nonatomic, strong)SettingAlertControllerViewController *alterDelegate;

@end
