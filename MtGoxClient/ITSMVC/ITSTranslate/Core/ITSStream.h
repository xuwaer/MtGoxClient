//
//  BaseStream.h
//  MVCStruct
//
//  Created by Xukj on 3/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDMulticastDelegate.h"

@interface ITSStream : NSObject<ITSStreamDelegate>
{
    NSString *_hostname;
    NSString *_port;
    NSString *hostUrl;
    
    GCDMulticastDelegate *gcdMulticastDelegate;
    dispatch_queue_t streamQueue;
    dispatch_queue_t parseQueue;
}

@property (nonatomic, copy) NSString *hostname;
@property (nonatomic, copy) NSString *port;

/**
 *	@brief	在本对象queue中同步执行，注意该方法会阻塞当前线程（即：调用本方法的线程）
 *
 *  @param  block 执行的block代码。使用者把需要执行的代码以block方式传递给该方法。
 *          那么，这些block方法，会在该Controller的线程queue中执行
 */
- (void)execute:(dispatch_block_t) block;

/**
 *	@brief	在本对象queue中异步执行
 *
 *  @param  block 执行的block代码。使用者把需要执行的代码以block方式传递给该方法。
 *          那么，这些block方法，会在该Controller的线程queue中执行
 */
- (void)schedule:(dispatch_block_t) block;

@end
