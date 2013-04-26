//
//  TickerCell.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MtGoxTickerResponse;

@interface TickerCell : UITableViewCell

@property (nonatomic, strong)IBOutlet UILabel *lastDisplayLabel;
@property (nonatomic, strong)IBOutlet UILabel *hightDisplayShortLabel;
@property (nonatomic, strong)IBOutlet UILabel *lowDisplayShortLabel;
@property (nonatomic, strong)IBOutlet UILabel *nowLabel;

/**
 *	@brief	绑定数据源
 *
 *	@param 	response 	需要绑定的数据源类型
 */
-(void)display:(MtGoxTickerResponse *)response;

@end
