//
//  HttpManager.m
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "ITSHttpStream.h"
#import "ITSRequest.h"
#import "ITSResponse.h"
#import "ITS.h"

#import "MKNetworkKit.h"
#import "MKNetworkOperationExt.h"

#define kStream_Cache_RequestBean_Tag @"kStream_Cache_RequestBean_Tag"
#define kStream_Cache_Response_Data @"kStream_Cache_Response_Data"

@implementation ITSHttpStream

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - life cycle

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)init
{
    self = [super init];
    
    if (self) {
        //TODO
        netEngine = [[MKNetworkEngine alloc] init];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private API delegate

///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSURL *)actionURL:(NSString *)requestCommand
{
    hostUrl = @"";
    // 如果没有设置hostname，那么直接把requestCommand当做请求url发送
    if (_hostname) {
        hostUrl = _hostname;
    }
    else {
        hostUrl = requestCommand;
        
        DDLogVerbose(@"%@", hostUrl);
        
        return [NSURL URLWithString:hostUrl];
    }
    
    if (_port) {
        hostUrl = [hostUrl stringByAppendingFormat:@":%@", _port];
    }
    
    hostUrl = [hostUrl stringByAppendingFormat:@"/%@", requestCommand];
        
    return [NSURL URLWithString:hostUrl];
}

-(void)request:(MKNetworkOperation *)opt parse:(NSData *)data requestBeanTag:(NSUInteger)requestBeanTag
{
    id object = [ITSResponse decode:data tag:[NSNumber numberWithUnsignedInt:requestBeanTag]];
    
    [self request:opt didReceiveObject:object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Public API delegate

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)sendHttpRequest:(BaseRequest *)requestInfo userinfo:(NSDictionary *)userinfo
{
    dispatch_block_t block = ^{@autoreleasepool{
    
        switch (requestInfo.requestType) {
            case HttpRequestTypeGet:
                [self sendGetHttpRequest:requestInfo userinfo:userinfo];
                break;
            case HttpRequestTypePost:
                //暂不支持Post请求
//                [self sendPostHttpRequest:requestInfo userinfo:userinfo];
                break;
            case HttpRequestTypePostWithFile:
            case HttpRequestTypePostWithData:
                
                //文件传输暂时未支持
                
                break;
            default:
                break;
        }
    }};
    
    [self schedule:block];
}

-(void)sendGetHttpRequest:(BaseRequest *)requestInfo
                 userinfo:(NSDictionary *)userinfo
{
    dispatch_block_t block = ^{@autoreleasepool{
        
        DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
        
        NSString *requestCommand = [requestInfo encode];
        
        if (requestCommand == nil)
            return;
        
        NSURL *url = [self actionURL:requestCommand];
        
        MKNetworkOperationExt *operationExt = [[MKNetworkOperationExt alloc] initWithURLString:[url absoluteString] params:nil httpMethod:@"GET"];
        // 防止block丢失,出现错误时会通知缓存更新
        operationExt.userinfo = userinfo;
        operationExt.tag = requestInfo.tag;
        // MKNetworkOperation *operation = [self.netEngine operationWithPath:url];
        
        MKNKResponseBlock responseBlock = ^(MKNetworkOperation *operation) {
            [self requestFinished:operation];
        };
        
        MKNKResponseErrorBlock errorBlock = ^(MKNetworkOperation *operation, NSError *error) {
            [self requestFailed:operation error:error];
        };
        
        [operationExt addCompletionHandler:responseBlock errorHandler:errorBlock];
        
        [self requestStarted:operationExt];
        
        // 如果请求失败，重新请求
        [netEngine enqueueOperation:operationExt forceReload:YES];
    }};
    
    [self schedule:block];
}

-(void)sendPostHttpRequest:(BaseRequest *)requestInfo
                  userinfo:(NSDictionary *)userinfo
{
    dispatch_block_t block = ^{@autoreleasepool{
        
        DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
        
    }};
    
    [self schedule:block];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Http请求以及应答，在各个状态下的处理回调

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)request:(MKNetworkOperation *)opt didReceiveData:(NSData *)data
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    //不作任何处理
}

- (void)requestStarted:(MKNetworkOperation *)opt
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    [gcdMulticastDelegate performSelector:@selector(requestStarted:) withObject:opt];
}

- (void)requestFinished:(MKNetworkOperation *)opt
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    dispatch_block_t block = ^{@autoreleasepool{
        
        MKNetworkOperationExt *optExt = (MKNetworkOperationExt *)opt;
        [self request:optExt parse:[optExt responseData] requestBeanTag:optExt.tag];
    }};
    
    if (dispatch_get_current_queue() == parseQueue)
        block();
    else
        dispatch_sync(parseQueue, block);
    
    [gcdMulticastDelegate performSelector:@selector(requestFinished:) withObject:opt];
}

- (void)requestFailed:(MKNetworkOperation *)opt error:(NSError *)error
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    DDLogVerbose(@"%@", error);
    
    [gcdMulticastDelegate performSelector:@selector(requestFailed::) withObject:opt withObject:error];
}

// 通过插件管理对象，调用插件中实现的方法
-(void)request:(MKNetworkOperation *)opt didReceiveObject:(id)object
{
    // 该方法在dataStreamQueue中执行
    dispatch_block_t block = ^{

        DDLogVerbose(@"%@(%@)tag:%d", THIS_FILE, THIS_METHOD, [(id<ITSResponseDelegate>)object tag]);
        
        // multicastDelgate没有实现该方法，所以在其内部，会把该函数调用消息传递给其保存的delegate中去执行。
        [gcdMulticastDelegate performSelector:@selector(request:didReceiveObject:) withObject:opt withObject:object];

    };
    
    // 在dataStreamQueue线程中执行，提交给上层逻辑处理。
    // 上层处理时，需要到对应的线程中执行
    [self execute:block];
}

@end
