//
//  AddRemindCell.h
//  MtGoxClient
//
//  Created by Xukj on 4/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface RemindAddCell : UITableViewCell

@property (nonatomic, assign)enum CurrencyType *currency;
@property (nonatomic, assign)enum Platform *platform;

@end
