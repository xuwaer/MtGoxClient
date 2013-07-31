//
//  PriceCell.h
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@class MtGoxTickerResponse;

@interface PriceCell : UIView

/**
 *	@brief	上次价格
 */
@property (nonatomic, strong)IBOutlet UILabel *lastDisplayLabel;

/**
 *	@brief	最高价格
 */
@property (nonatomic, strong)IBOutlet UILabel *hightDisplayLabel;

/**
 *	@brief	最低价格
 */
@property (nonatomic, strong)IBOutlet UILabel *lowDisplayLabel;

/**
 *	@brief	时间
 */
@property (nonatomic, strong)IBOutlet UILabel *nowLabel;

/**
 *	@brief	币种图标
 */
@property (nonatomic, strong)IBOutlet UIImageView *currencyImageView;

@property (nonatomic, strong)IBOutlet UIView *priceBackgroupView;

/**
 *	@brief	根据数据，生成UI展示
 *
 *	@param 	response 	需要展示的数据
 */
-(void)display:(MtGoxTickerResponse *)response;

/**
 *	@brief	请求失败时显示
 *
 */
-(void) displayFailedMessage;

@end
