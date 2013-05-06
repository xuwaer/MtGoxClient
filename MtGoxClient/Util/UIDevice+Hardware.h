//
//  UIDevice+Platform.h
//  MtGoxClient
//
//  Created by Xukj on 5/3/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

/**
 *	@brief	内部平台版本信息
 *
 *	@return	内部版本信息
 */
-(NSString *)platform;

/**
 *	@brief	把内部版本转换成对外的版本信息
 *
 *	@return	对外的版本信息
 */
-(NSString *)platformString;

/**
 *	@brief	是否retina屏幕
 *
 *	@return	结果标识
 */
-(BOOL)hasRetinaDisplay;

/**
 *	@brief	是否支持多线程
 *
 *	@return	结果标识
 */
-(BOOL)hasMultitasking;

/**
 *	@brief	是否有摄像头
 *
 *	@return	结果标识
 */
-(BOOL)hasCamera;

@end
