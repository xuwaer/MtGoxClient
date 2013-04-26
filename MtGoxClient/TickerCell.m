//
//  TickerCell.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "TickerCell.h"
#import "MtGoxTickerResponse.h"

@implementation TickerCell

@synthesize lastDisplayLabel;
@synthesize hightDisplayShortLabel;
@synthesize lowDisplayShortLabel;
@synthesize nowLabel;

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

-(void)display:(MtGoxTickerResponse *)response
{
    if (response == nil)    return;
    if (response.data == nil)   return;
    
    MtGoxTickerDetailResponse *highDetail = [response.data objectForKey:@"high"];
    MtGoxTickerValueResponse *hightValue = highDetail.value;
    self.hightDisplayShortLabel.text = hightValue.display_short;
    
    MtGoxTickerDetailResponse *lowDetail = [response.data objectForKey:@"low"];
    MtGoxTickerValueResponse *lowValue = lowDetail.value;
    self.lowDisplayShortLabel.text = lowValue.display_short;

    MtGoxTickerDetailResponse *lastDetail = [response.data objectForKey:@"last"];
    MtGoxTickerValueResponse *lastValue = lastDetail.value;
    self.lastDisplayLabel.text = lastValue.display;
    
    MtGoxTickerDetailResponse *nowDetail = [response.data objectForKey:@"now"];
//    NSNumber *nowTime = (NSNumber *)nowDetail.value;
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)nowDetail.value longLongValue] / 1000000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.nowLabel.text = [dateFormat stringFromDate:nowTime];
}

@end
