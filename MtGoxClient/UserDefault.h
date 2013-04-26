//
//  UserDefault.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface UserDefault : NSObject
{
    enum Platform _platform;
    NSMutableArray *_mtGoxRemind;
    NSMutableArray *_btcChinaRemind;
    NSMutableArray *_btcERemind;
}

@property (nonatomic, assign)enum Platform platform;
@property (nonatomic, strong)NSMutableArray *mtGoxRemind;
@property (nonatomic, strong)NSMutableArray *btcChinaRemind;
@property (nonatomic, strong)NSMutableArray *btcERemind;

/**
 *	@brief	Get Userdefault instance.
 *
 *	@return	UserDefault instance.
 */
+ (UserDefault *)defaultUser;

/**
 *	@brief	Read UserDefault in config file.
 */
- (void)getUserDefault;

/**
 *	@brief	Write UserDefault in config file.
 */
- (void)saveUserDefault;

/**
 *	@brief	Clear UserDefault in config file.
 */
- (void)clearUserDefault;

/**
 *	@brief	For debug. Show log
 */
- (void)showlog;

@end
