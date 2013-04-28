//
//  RemindCell.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindCell.h"
#import "Remind.h"

@implementation RemindCell

@synthesize remind;

@synthesize currencyLabel;
@synthesize compareLabel;
@synthesize thresholdLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupRemindShow:(Remind *)inRemind
{
    self.remind = inRemind;
    
    // 设置显示用兑换币种
    NSString *currencyStr = @"兑";
    switch (inRemind.currency) {
        case CurrencyTypeUSD:
            currencyStr = [currencyStr stringByAppendingFormat:@"美元"];
            break;
        case CurrencyTypeEUR:
            currencyStr = [currencyStr stringByAppendingFormat:@"欧元"];
            break;
        case CurrencyTypeJPY:
            currencyStr = [currencyStr stringByAppendingFormat:@"日元"];
            break;
        case CurrencyTypeCNY:
            currencyStr = [currencyStr stringByAppendingFormat:@"人民币"];
            break;
        default:
            currencyStr = [currencyStr stringByAppendingFormat:@"美元"];
            break;
    }
    
    // 设置提醒标准
    NSString *compareStr = inRemind.isLarge ? @"大于" : @"小于";
    
    // 设置提醒阀值
    NSString *thresholdStr = [NSString stringWithFormat:@"%.4f", inRemind.threshold];
    
    self.currencyLabel.text = currencyStr;
    self.compareLabel.text = compareStr;
    self.thresholdLabel.text = thresholdStr;
    
    if (inRemind.isLarge) {
        [self.currencyLabel setTextColor:[UIColor redColor]];
        [self.compareLabel setTextColor:[UIColor redColor]];
        [self.thresholdLabel setTextColor:[UIColor redColor]];
    }
    else {
        [self.currencyLabel setTextColor:[UIColor greenColor]];
        [self.compareLabel setTextColor:[UIColor greenColor]];
        [self.thresholdLabel setTextColor:[UIColor greenColor]];
    }
}

@end
