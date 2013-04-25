//
//  QueueModule.m
//  MVCStruct
//
//  Created by Xukj on 3/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "ITSQueueModule.h"

@implementation ITSQueueModule

@synthesize threadQueue = _threadQueue;
@synthesize stream = _stream;

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - life cycle

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)init
{
    return [self initWithDispatchQueue:NULL];
}

-(id)initWithDispatchQueue:(dispatch_queue_t)dispatch_queue
{
    self = [super init];
    if (self) {
        
        // 创建线程queue
        if (dispatch_queue) {
            _threadQueue = dispatch_queue;
            dispatch_retain(dispatch_queue);
        }
        else {
            const char *queueNames = [[self queueName] UTF8String];
            _threadQueue = dispatch_queue_create(queueNames, NULL);
        }
        
    }
    
    return self;
}

-(void)dealloc
{
    dispatch_release(_threadQueue);
    _threadQueue = NULL;
    _stream = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Public API

///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSString *)queueName
{
    return NSStringFromClass([self class]);
}

-(BOOL)plugin:(ITSStream *)inStream
{
    __block BOOL result = YES;
    
    dispatch_block_t block = ^{
        
        if (inStream == nil) {
            result = NO;
        }
        else {
            // 数据流对象中插入本线程
            // 插入本线程后，当数据流执行到委托方法后，会回到本线程执行该委托方法
            _stream = inStream;
            [_stream addDelegate:self delegateQueue:_threadQueue];
        }
    };
    
    // 指定block中的方法在本线程中运行
    // 这里必须使用同步，否则在运行速度过快的情况下，回调会被阻塞。
//    dispatch_sync(_threadQueue, block);
    [self execute:block];
    
    return result;
}

-(void)pullout
{
    dispatch_block_t block = ^{
        
        // 数据流对象中删除本线程
        [_stream removeDelegate:self delegateQueue:_threadQueue];
    };
    
    // 指定block中的方法在本线程中运行
    // 这里必须使用同步，否则在运行速度过快的情况下，回调会被阻塞。
//    dispatch_sync(_threadQueue, block);
    [self execute:block];
}

-(void)execute:(dispatch_block_t)block
{
    if (dispatch_get_current_queue() == _threadQueue)
        block();
    else
        dispatch_sync(_threadQueue, block);
}

-(void)schedule:(dispatch_block_t)block
{
    if (dispatch_get_current_queue() == _threadQueue)
        block();
    else
        dispatch_async(_threadQueue, block);
}

@end
