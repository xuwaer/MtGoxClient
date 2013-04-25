//
//  HttpQueueModule.h
//  tfsp_rc
//
//  Created by Xukj on 3/28/13.
//
//

#import "ITSQueueModule.h"
#import "BaseRequest.h"

@class TargetContext;

/**
 *	@brief	Control层，接收通信层数据（封装完毕）。完成不同project的逻辑处理
 */
@interface HttpQueueModule : ITSQueueModule<HttpStreamDelegate>
{
    
    TransManager *transManager;             //通信管理类
    
    @private
    NSUInteger tag;                         //标识，用于请求与响应--对应。
    NSMutableDictionary *contextDic;        //上下文，用于执行期望对象的期望方法
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

/**
 *	@brief	获取上下文标识
 *
 *	@param 	request 	从http请求应答中获取
 *
 *	@return	上下文标识，用于从上下文dictionary中获取上下文（target、selector）
 */
-(NSUInteger)getContextTag:(ASIHTTPRequest *)request;

/**
 *	@brief	获取上下文
 *
 *	@param 	inTag	上下文标识
 *  @param  上下文对象
 */
-(TargetContext *)getContext:(NSUInteger)inTag;

/**
 *	@brief	删除上下文
 *
 *	@param 	inTag 	上下文标识
 */
-(void)removeContext:(NSUInteger)inTag;

/**
 *	@brief	保存上下文
 *
 *	@param 	context 	上下文
 *  @param  上下文标识
 */
-(NSUInteger)saveContext:(TargetContext *)inContext;

/**
 *	@brief	执行上下文提供的功能。该方法执行后，上下文环境会自动从缓存中删除。
 *
 *	@param 	inTag 	上下文标志符
 */
-(void)performContext:(NSUInteger)inTag;

/**
 *	@brief	执行上下文提供的功能。该方法执行后，上下文环境会自动从缓存中删除。
 *
 *	@param 	inTag 	流水号，匹配上下文
 *  @param  object  上下文功能需要使用的object
 */
-(void)performContext:(NSUInteger)inTag object:(id)object;

/**
 *	@brief	执行上下文提供的功能.该方法执行后，上下文环境会自动从缓存中删除。
 *
 *	@param 	inTag 	流水号，匹配上下文
 *  @param  object1  上下文功能需要使用的object1
 *  @param  object2  上下文功能需要使用的object2
 */
-(void)performContext:(NSUInteger)inTag object1:(id)object1 object2:(id)object2;

@end


/**
 *	@brief	上下文类
 */
@interface TargetContext : NSObject

@property (nonatomic, strong) id target;        //上下文对象
@property (nonatomic, assign) SEL selector;     //上下文方法

-(id)initWithTarget:(id)inTarget selector:(SEL)inSelector;

@end
