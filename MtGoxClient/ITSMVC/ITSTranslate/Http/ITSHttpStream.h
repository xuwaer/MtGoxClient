//
//  HttpManager.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ITSStream.h"
#import "BaseRequest.h"

/**
 *	@brief	通信时调用的方法。需要在QueueModule中实现。所有加入控制且实现了该委托的QueueModule，在与服务器进行数据通信时
 *          会被自动调用。
 */
@protocol HttpStreamDelegate <ASIHTTPRequestDelegate>

@optional
-(void)request:(ASIHTTPRequest *)request didReceiveObject:(id)object;

@end

@class ASINetworkQueue;

/**
 *	@brief 通信类。完成创建、断开连接，发送、接收消息等功能
 */
@interface ITSHttpStream : ITSStream<ASIHTTPRequestDelegate, ASIProgressDelegate, ITSStreamDelegate>
{
    @protected
    ASINetworkQueue *_requestGetQueue;
    ASINetworkQueue *_requestPostQueue;
    
    NSMutableDictionary *cache;
    NSUInteger cacheTag;
}

/**
 *	@brief	http get请求
 *
 *	@param 	requestInfo 	实现接口ITSRequestDelegate的实体类
 */
-(void)sendGetHttpRequest:(BaseRequest *)requestInfo
                 userinfo:(NSDictionary *)userinfo;

/**
 *	@brief	http post请求
 *
 *	@param 	requestInfo 	实现接口ITSRequestDelegate的实体类
 */
-(void)sendPostHttpRequest:(BaseRequest *)requestInfo
                  userinfo:(NSDictionary *)userinfo;

-(void)sendHttpRequest:(BaseRequest *)requestInfo
              userinfo:(NSDictionary *)userinfo;

/**
 *	@brief	http get请求队列，最好不要使用。会破坏stream的线程安全
 */
@property (nonatomic, strong, readonly) ASINetworkQueue *requestGetQueue;
/**
 *	@brief	http post请求队列，最好不要使用。会破坏stream的线程安全
 */
@property (nonatomic, strong, readonly) ASINetworkQueue *requestPostQueue;

@end
