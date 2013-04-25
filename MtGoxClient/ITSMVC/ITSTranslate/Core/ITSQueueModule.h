//
//  QueueModule.h
//  MVCStruct
//
//  Created by Xukj on 3/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSStream.h"

/**
 *	@brief	Control层父类，通信模块得到的数据会自动传递到该类
 */
@interface ITSQueueModule : NSObject
{
    // Control层运行所在的线程queue
    dispatch_queue_t _threadQueue;
    // 通信模块
    ITSStream *_stream;
}

@property (nonatomic, strong, readonly) ITSStream *stream;

@property (nonatomic, assign, readonly) dispatch_queue_t threadQueue;

/**
 *	@brief	初始化并指定运行的线程。
 *
 *	@param 	dispatch_queue 	该类中的所有逻辑，均在此线程queue下运行。如未指定，则由该类自行控制
 *
 *	@return	QueueModule
 */
-(id)initWithDispatchQueue:(dispatch_queue_t)dispatch_queue;

-(NSString *)queueName;

/**
 *	@brief	响应数据模块。当请求得到服务器的响应后，所有已加入的模块的对应方法均会被调用。
 *          调用的方法，参见具体的通信模块委托
 *
 *	@param 	stream 	通信模块
 *
 *	@return	是否成功加入控制响应
 */
-(BOOL)plugin:(ITSStream *)stream;

/**
 *	@brief	从控制响应中删除
 */
-(void)pullout;


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
