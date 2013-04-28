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
    @private    
    NSString *filePath;
    NSMutableDictionary *fileContent;
    
    enum Platform _platform;
    NSMutableArray *_mtGoxRemind;
    NSMutableArray *_btcChinaRemind;
    NSMutableArray *_btcERemind;
}

@property (nonatomic, assign, readonly)enum Platform platform;
@property (nonatomic, strong, readonly)NSMutableArray *mtGoxRemind;
@property (nonatomic, strong, readonly)NSMutableArray *btcChinaRemind;
@property (nonatomic, strong, readonly)NSMutableArray *btcERemind;

@property (nonatomic, strong, readonly)NSString *lastPlatformTitle;

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
