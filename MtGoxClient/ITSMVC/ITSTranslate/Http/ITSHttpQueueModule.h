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
 *	@brief	控制层子类。完成数据传递和接收callback。
 *  在本项目中，实现了HttpStreamDelegate。通信层接收并处理完毕后，callback该委托对象的方法
 */
@interface ITSHttpQueueModule : ITSQueueModule<HttpStreamDelegate>
{
    @private
    ITSTransManager *transManager;             //通信管理类
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
