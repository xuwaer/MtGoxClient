//
//  BaseStream.m
//  MVCStruct
//
//  Created by Xukj on 3/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "ITSStream.h"

@implementation ITSStream

@synthesize hostname = _hostname;
@synthesize port = _port;

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - life cycle

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)init
{
    self = [super init];
    
    if (self) {
        gcdMulticastDelegate = [[GCDMulticastDelegate alloc] init];
        streamQueue = dispatch_queue_create("streamQueue", NULL);
        parseQueue = dispatch_queue_create("parseQueue", NULL);
    }
    
    return self;
}

-(void)dealloc
{
    dispatch_release(streamQueue);
    dispatch_release(parseQueue);
    streamQueue = NULL;
    parseQueue = NULL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Getter/Setter

///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSString *)hostname
{
    __block NSString *result = nil;
    
    dispatch_block_t block = ^{@autoreleasepool{
        result = _hostname;
    }};
    
    [self execute:block];
    
    return result;
}

-(NSString *)port
{
    __block NSString *result = nil;
    
    dispatch_block_t block = ^{@autoreleasepool{
        
        result = _port;
    }};
    
    [self execute:block];
    
    return result;
}

-(void)setHostname:(NSString *)inHostname
{
    dispatch_block_t block = ^{@autoreleasepool{
        _hostname = inHostname;
    }};
    
    [self execute:block];
}

-(void)setPort:(NSString *)inPort
{
    dispatch_block_t block = ^{@autoreleasepool{
        _port = inPort;
    }};
    
    [self execute:block];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Stream delegate

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    dispatch_block_t block = ^{
        
        [gcdMulticastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    };
    
    // 为保证线程安全，必须使用同步
    [self execute:block];
}

-(void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    dispatch_block_t block = ^{
        
        [gcdMulticastDelegate removeDelegate:delegate delegateQueue:delegateQueue];

    };
    
    // 为保证线程安全，必须使用同步
    [self execute:block];
}

-(void)removeDelegate:(id)delegate
{
    dispatch_block_t block = ^{
        
        [gcdMulticastDelegate removeDelegate:delegate];

    };
    
    // 为保证线程安全，必须使用同步
    [self execute:block];

}

-(void)removeAllDelegate
{
    dispatch_block_t block = ^{
        
        [gcdMulticastDelegate removeAllDelegates];

    };
    
    // 为保证线程安全，必须使用同步
    [self execute:block];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Public API

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)execute:(dispatch_block_t)block
{
    if (dispatch_get_current_queue() == streamQueue)
        block();
    else
        dispatch_sync(streamQueue, block);
}

-(void)schedule:(dispatch_block_t)block
{
    if (dispatch_get_current_queue() == streamQueue)
        block();
    else
        dispatch_async(streamQueue, block);
}

@end
