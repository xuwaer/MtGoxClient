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
@interface SettingCellControllerViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, RemindSettingDelegate>
{
    @private
    NSMutableArray *dataSource;
}

@property (nonatomic, strong)IBOutlet UITableView *alertTableView;
@property (nonatomic, strong)IBOutlet UIView *headerView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)SettingAlertControllerViewController *alterDelegate;

@end
