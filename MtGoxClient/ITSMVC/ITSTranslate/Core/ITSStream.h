//
//  BaseStream.h
//  MVCStruct
//
//  Created by Xukj on 3/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDMulticastDelegate.h"

/*************/
/*  请勿修改  */
/************/

/**
 *	@brief	控制整个网络请求流程中的数据发送、接收父类。该类必须针对特定的网络情况设计(http、socket等)。
 */
@interface ITSStream : NSObject<ITSStreamDelegate>
{
    NSString *_hostname;
    NSString *_port;
    NSString *hostUrl;
    
    // 动作分发管理器。把通信层的操作，分发给控制层
    GCDMulticastDelegate *gcdMulticastDelegate;
    
    // 通信线程
    dispatch_queue_t streamQueue;
    // 解析线程
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
