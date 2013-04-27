//
//  SettingViewController.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController
{
    @private
    NSMutableArray *mtGoxReminds;
    NSMutableArray *btcChinaReminds;
    NSMutableArray *btcEReminds;
}

@end
