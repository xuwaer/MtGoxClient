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
 *	@brief	进行数据交互时会自动回调的委托，用于监控数据传递、接收状态。需要在QueueModule中实现。
 *          要让该委托在与服务器进行数据通信时会被自动调用，需要完成以下操作.
 *          1.在ITSQueueModule的子类中实现该委托
 *          2.调用ITSQueueModule中的方法：-(BOOL)plugin:(ITSStream *)stream;
 */
@protocol HttpStreamDelegate

@optional
- (void)request:(MKNetworkOperation *)opt didReceiveObject:(id)object;
- (void)requestStarted:(MKNetworkOperation *)opt;
- (void)requestFinished:(MKNetworkOperation *)opt;
- (void)requestFailed:(MKNetworkOperation *)opt error:(NSError *)error;
- (void)request:(MKNetworkOperation *)opt didReceiveData:(NSData *)data;

@end

/**
 *	@brief 通信类。完成创建、断开连接，发送、接收消息等功能
 */
@interface ITSHttpStream : ITSStream<ITSStreamDelegate>
{
    @protected
    MKNetworkEngine *netEngine;
}

/**
 *	@brief	http get请求.(取消该方法的对外开发）
 *
 *	@param 	requestInfo 	实现接口ITSRequestDelegate的实体类
 */
//-(void)sendGetHttpRequest:(BaseRequest *)requestInfo
//                 userinfo:(NSDictionary *)userinfo;

/**
 *	@brief	http post请求.(取消该方法的对外开发)
 *
 *	@param 	requestInfo 	实现接口ITSRequestDelegate的实体类
 */
//-(void)sendPostHttpRequest:(BaseRequest *)requestInfo
//                  userinfo:(NSDictionary *)userinfo;

-(void)sendHttpRequest:(BaseRequest *)requestInfo
              userinfo:(NSDictionary *)userinfo;

@end
