//
//  SettingViewController.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindSettingController.h"

@interface SettingViewController : UITableViewController<RemindSettingDelegate>
{
    @private
    NSMutableArray *mtGoxReminds;
    NSMutableArray *btcChinaReminds;
    NSMutableArray *btcEReminds;
}

@end
