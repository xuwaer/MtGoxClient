//
//  PriceCell.m
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "PriceCell.h"
#import "MtGoxTickerResponse.h"
#import "ITSConfig.h"
#import <QuartzCore/QuartzCore.h>

@implementation PriceCell

@synthesize lastDisplayLabel;
@synthesize hightDisplayLabel;
@synthesize lowDisplayLabel;
@synthesize nowLabel;
@synthesize currencyImageView;
@synthesize priceBackgroupView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // 背景颜色
    UIImage *bgImage = [UIImage imageNamed:@"bg_main_section.png"];
    [self setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
    self.layer.opaque = NO;
    UIImage *priceBgImage = [UIImage imageNamed:@"bg_price.png"];
    [self.priceBackgroupView setBackgroundColor:[UIColor colorWithPatternImage:priceBgImage]];
    self.priceBackgroupView.layer.opaque = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/**
 *	@brief	绑定数据，并在UI上展示
 *
 *	@param 	response 	需要展示的数据
 */
-(void)display:(MtGoxTickerResponse *)response
{
    if (response == nil)    return;
    if (response.data == nil)   return;
    
    MtGoxTickerDetailResponse *highDetail = [response.data objectForKey:@"high"];
    MtGoxTickerValueResponse *hightValue = highDetail.value;
    self.hightDisplayLabel.text = [hightValue.value stringValue];
    
    MtGoxTickerDetailResponse *lowDetail = [response.data objectForKey:@"low"];
    MtGoxTickerValueResponse *lowValue = lowDetail.value;
    self.lowDisplayLabel.text = [lowValue.value stringValue];
    
    MtGoxTickerDetailResponse *lastDetail = [response.data objectForKey:@"last"];
    MtGoxTickerValueResponse *lastValue = lastDetail.value;
    if (self.lastDisplayLabel.font.pointSize != 24) {
        self.lastDisplayLabel.font = [UIFont boldSystemFontOfSize:24];
    }
    self.lastDisplayLabel.text = [lastValue.value stringValue];
    
    MtGoxTickerDetailResponse *nowDetail = [response.data objectForKey:@"now"];
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)nowDetail.value longLongValue] / 1000000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setDateFormat:@"MMM dd HH:mm:ss"];
    self.nowLabel.text = [dateFormat stringFromDate:nowTime];
    
//    UIImage *currencyImage = nil;
//    switch (response.tag) {
//        case kActionTag_Response_USD:
//            currencyImage = [UIImage imageNamed:@"USD.png"];
//            break;
//        case kActionTag_Response_EUR:
//            currencyImage = [UIImage imageNamed:@"EUR.png"];
//            break;
//        case kActionTag_Response_JPY:
//            currencyImage = [UIImage imageNamed:@"JPY.png"];
//            break;
//        case kActionTag_Response_CNY:
//            currencyImage = [UIImage imageNamed:@"CNY.png"];
//            break;
//        default:
//            break;
//    }
//    if (currencyImage)
//        self.currencyImageView.image = currencyImage;
}

- (void) displayFailedMessage {
    self.hightDisplayLabel.text = @"----";
    self.lowDisplayLabel.text = @"----";
    if (self.lastDisplayLabel.font.pointSize != 18) {
        self.lastDisplayLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    self.lastDisplayLabel.text = @"MtGox网站异常";
    self.nowLabel.text = @"----";
}

-(void)setCurrencyType:(enum CurrencyType)inCurrencyType
{
    UIImage *currencyImage = nil;
    switch (inCurrencyType) {
        case CurrencyTypeUSD:
            currencyImage = [UIImage imageNamed:@"USD.png"];
            break;
        case CurrencyTypeEUR:
            currencyImage = [UIImage imageNamed:@"EUR.png"];
            break;
        case CurrencyTypeJPY:
            currencyImage = [UIImage imageNamed:@"JPY.png"];
            break;
        case CurrencyTypeCNY:
            currencyImage = [UIImage imageNamed:@"CNY.png"];
            break;
            
        default:
            break;
    }
    
    if (currencyImage)
        self.currencyImageView.image = currencyImage;
}

@end
