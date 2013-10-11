//
//  HttpQueueModule.h
//  tfsp_rc
//
//  Created by Xukj on 3/28/13.
//
//

#import "ITSQueueModule.h"
#import "BaseRequest.h"

#define kTarget @"target"
#define kSelector @"selector"

@class TargetContext;
@class MKNetworkOperation;

/**
 *	@brief	Control层，接收通信层数据（封装完毕）。完成不同project的逻辑处理
 */
@interface HttpQueueModule : ITSQueueModule<HttpStreamDelegate>
{
    @private
    TransManager *transManager;             //通信管理类
}

/**
 *	@brief	发送请求
 *
 *	@param 	request 	请求数据，必须继承BaseRequest
 *	@param 	target      该请求响应后，期望执行的对象
 *	@param 	selector 	该请求响应后，期望执行的方法
 */
-(void)sendRequest:(BaseRequest *)request;
-(void)sendRequest:(BaseRequest *)request target:(id)target selector:(SEL)selector;

@end
