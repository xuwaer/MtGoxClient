//
//  PriceCell.h
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MtGoxTickerResponse;

@interface PriceCell : UIView

@property (nonatomic, strong)IBOutlet UILabel *lastDisplayLabel;
@property (nonatomic, strong)IBOutlet UILabel *hightDisplayShortLabel;
@property (nonatomic, strong)IBOutlet UILabel *lowDisplayShortLabel;
@property (nonatomic, strong)IBOutlet UILabel *nowLabel;

@property (nonatomic, strong)IBOutlet UIImageView *currencyImageView;
@property (nonatomic, strong)IBOutlet UIView *priceBackgroupView;

-(void)display:(MtGoxTickerResponse *)response;

@end
