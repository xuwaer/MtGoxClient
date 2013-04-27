//
//  RemindCell.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Remind;

@interface RemindCell : UITableViewCell

@property (nonatomic, strong)Remind *remind;

@property (nonatomic, strong)IBOutlet UILabel *currencyLabel;
@property (nonatomic, strong)IBOutlet UILabel *compareLabel;
@property (nonatomic, strong)IBOutlet UILabel *thresholdLabel;

-(void)setupRemindShow:(Remind *)inRemind;

@end
