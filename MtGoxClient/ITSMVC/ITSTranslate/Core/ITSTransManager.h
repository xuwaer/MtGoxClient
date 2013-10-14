//
//  TransManager.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//
//  所有的于通信有关的连接控制，均在此类中进行管理
//
//
//
//

#import <Foundation/Foundation.h>
#import "ITSQueueModule.h"
#import "ITSStream.h"

/*************/
/*  请勿修改  */
/************/

/**
 *	@brief	通信层核心。协调数据请求、接收、解析、分发给控制层。
 *  1.steam，使用线程管理数据发送、接收、解析。(ITSStream)
 *  2.controllers，缓存需要callback的控制层对象
 */
@interface ITSTransManager : NSObject
{
    // 通信层，管理数据发送、接收、解析线程
    ITSStream *_stream;
    
    // 控制层对象。(保存类型:ITSQueueModule)
    NSMutableArray *controllers;
}

/**
 *	@brief	通信层，管理数据发送、接收、解析线程
 */
@property (nonatomic, strong, readonly) ITSStream *stream;

/**
 *	@brief	服务器地址
 */
@property (nonatomic, copy) NSString *hostname;

/**
 *	@brief	服务器端口
 */
@property (nonatomic, copy) NSString *port;


/**
 *	@brief	作为统一管理控制层和通信层的交互的核心控制器。它完成整个数据流程的控制，因此必须为单例。
 *
 *	@return
 */
+(id)defaultManager;

/**
 *	@brief	把该控制层对象加入缓存。当通信数据完成发送、接收、解析后，会callback该控制层对象
 *
 *	@param 	queueModule 	实现ITSQueueModule的控制层对象
 *
 *	@return	是否成功callback
 */
-(BOOL)add:(ITSQueueModule *)queueModule;

/**
 *	@brief	把该控制层对象移除缓存。当通信数据完成发送、接收、解析后，系统不再callback该控制层对象
 *
 *	@param 	queueModule 	需要remove的对象
 */
-(void)remove:(ITSQueueModule *)queueModule;

@end
