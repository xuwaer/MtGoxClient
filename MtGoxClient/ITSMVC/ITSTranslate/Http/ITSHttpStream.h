//
//  HttpManager.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import <Foundation/Foundation.h>
#import "ITSStream.h"
#import "BaseRequest.h"

#import "MKNetworkKit.h"

/**
 *	@brief	通信时调用的方法。需要在QueueModule中实现。所有加入控制且实现了该委托的QueueModule，在与服务器进行数据通信时
 *          会被自动调用。
 */
@protocol HttpStreamDelegate

@optional
- (void)request:(MKNetworkOperation *)opt didReceiveObject:(id)object;
- (void)requestStarted:(MKNetworkOperation *)opt;
- (void)requestFinished:(MKNetworkOperation *)opt;
- (void)requestFailed:(MKNetworkOperation *)opt error:(NSError *)error;
- (void)request:(MKNetworkOperation *)opt didReceiveData:(NSData *)data;

@end

@class ASINetworkQueue;

/**
 *	@brief 通信类。完成创建、断开连接，发送、接收消息等功能
 */
@interface ITSHttpStream : ITSStream<ITSStreamDelegate>
{
    @protected
    MKNetworkEngine *netEngine;
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

@end
