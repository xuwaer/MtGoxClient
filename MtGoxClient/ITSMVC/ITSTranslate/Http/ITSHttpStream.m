//
//  HttpManager.m
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "ITSHttpStream.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "ITSRequest.h"
#import "ITSResponse.h"
#import "ITS.h"

#define kStream_Cache_RequestBean_Tag @"kStream_Cache_RequestBean_Tag"
#define kStream_Cache_Response_Data @"kStream_Cache_Response_Data"

@implementation ITSHttpStream

@synthesize requestGetQueue = _requestGetQueue;
@synthesize requestPostQueue = _requestPostQueue;

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - life cycle

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)init
{
    self = [super init];
    
    if (self) {
        cache = [[NSMutableDictionary alloc] init];
        cacheTag = 1;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Getter/Setter

///////////////////////////////////////////////////////////////////////////////////////////////////

-(ASINetworkQueue *)requestGetQueue
{
    __block ASINetworkQueue *result = nil;
    
    dispatch_block_t block = ^{@autoreleasepool{
        if (_requestGetQueue == nil) {
            _requestGetQueue = [[ASINetworkQueue alloc] init];
            [_requestGetQueue setShouldCancelAllRequestsOnFailure:NO];
        }
        
        result = _requestGetQueue;
    }};
    
    [self execute:block];
    
    return _requestGetQueue;
}

-(ASINetworkQueue *)requestPostQueue
{
    __block ASINetworkQueue *result = nil;
    
    dispatch_block_t block = ^{@autoreleasepool{
        if (_requestPostQueue == nil) {
            _requestPostQueue = [[ASINetworkQueue alloc] init];
            [_requestGetQueue setShouldCancelAllRequestsOnFailure:NO];
        }
        result = _requestPostQueue;
    }};
 
    [self execute:block];

    return result;
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

-(void)request:(ASIHTTPRequest *)request parse:(NSData *)data requestBeanTag:(NSUInteger)requestBeanTag
{
//    dispatch_block_t block = ^{@autoreleasepool{
    
    id object = [ITSResponse decode:data tag:[NSNumber numberWithUnsignedInt:requestBeanTag]];
    
    [self request:request didReceiveObject:object];
//    }};
//    
//    if (dispatch_get_current_queue() == parseQueue)
//        block();
//    else
//        dispatch_async(parseQueue, block);
}

-(NSUInteger)createTag
{
    return (cacheTag > 999) ? 1 : ++cacheTag;
}

-(NSUInteger)saveRequestBeanTagInCache:(NSUInteger)requestBeanTag
{
    NSNumber *cacheTagKey = [NSNumber numberWithUnsignedInteger:[self createTag]];
    
    NSMutableDictionary *tagDic = [[NSMutableDictionary alloc] init];
    NSNumber *tagValue = [NSNumber numberWithUnsignedInteger:requestBeanTag];
    [tagDic setValue:tagValue forKey:kStream_Cache_RequestBean_Tag];
    [tagDic setValue:[NSNull null] forKey:kStream_Cache_Response_Data];
    
    [cache setValue:tagDic forKey:[cacheTagKey stringValue]];
    
    return cacheTag;
}

-(void)saveDataInCache:(NSData *)data cacheTag:(NSUInteger)inCacheTag
{
    NSString *cacheTagKey = [[NSNumber numberWithUnsignedInteger:inCacheTag] stringValue];
    
    NSMutableDictionary *tagDic = [cache objectForKey:cacheTagKey];
    if (tagDic == nil)
        return;

    NSMutableData *cacheData = [tagDic objectForKey:kStream_Cache_Response_Data];
    if (![cacheData isEqual:[NSNull null]]) {
        [cacheData appendData:data];
    }
    else {
        NSMutableData *tmpData = [NSMutableData dataWithData:data];
        [tagDic setValue:tmpData forKey:kStream_Cache_Response_Data];
    }
    
}

-(NSDictionary *)loadCache:(NSUInteger)inCacheTag
{
    NSString *cacheTagKey = [[NSNumber numberWithUnsignedInteger:inCacheTag] stringValue];
    
    NSMutableDictionary *tagDic = [cache objectForKey:cacheTagKey];
    if (tagDic == nil)
        return nil;
    
    [cache removeObjectForKey:cacheTagKey];
    return tagDic;
}

-(void)addParams:(NSDictionary *)params request:(ASIFormDataRequest *)request
{
    if (params == nil)
        return;
    
    NSArray *keys = params.allKeys;
    NSArray *values = params.allValues;
    
    for (int i = 0; i < [keys count]; i++) {
        
        NSString *key = [keys objectAtIndex:i];
        id value = [values objectAtIndex:i];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self addParams:value request:request];
        }
        
        [request addPostValue:value forKey:key];
    }
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
            case HttpRequestTypePostWithFile:
            case HttpRequestTypePostWithData:
                [self sendPostHttpRequest:requestInfo userinfo:userinfo];
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
    
        //缓存请求、响应信息
        NSUInteger requestTag = [self saveRequestBeanTagInCache:[requestInfo tag]];
        NSString *requestCommand = [requestInfo encode];
        
        if (requestCommand == nil)  return ;
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[self actionURL:requestCommand]];
        request.timeOutSeconds = HTTP_REQUEST_TIMEOUT;
        [request setDelegate:self];
        [request setTag:requestTag];
        [request setUserInfo:userinfo];
        [request setRequestMethod:@"GET"];
        [[self requestGetQueue] addOperation:request];
        [[self requestGetQueue] go];
    }};
    
    [self schedule:block];
}

-(void)sendPostHttpRequest:(BaseRequest *)requestInfo
                  userinfo:(NSDictionary *)userinfo
{
    dispatch_block_t block = ^{@autoreleasepool{
    
        //缓存请求、响应信息
        NSUInteger requestTag = [self saveRequestBeanTagInCache:[requestInfo tag]];
        NSString *requestCommand = requestInfo.requestCommand;
        NSDictionary *params = [requestInfo encode];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[self actionURL:requestCommand]];
        [self addParams:params request:request];
        
        if (requestInfo.requestType == HttpRequestTypePostWithFile) {
            [request addFile:requestInfo.filePath forKey:requestInfo.fileKey];
        }
        else if (requestInfo.requestType == HttpRequestTypePostWithData) {
            [request addData:requestInfo.fileData forKey:requestInfo.fileKey];
        }
        
        [request setDelegate:self];
        [request setTag:requestTag];
        [request setUserInfo:userinfo];
        [request setRequestMethod:@"POST"];
        [[self requestPostQueue] addOperation:request];
        [[self requestPostQueue] go];
        
    }};
    
    [self schedule:block];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ASIProgressDelegate delegate

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    [gcdMulticastDelegate performSelector:@selector(request:didReceiveBytes::)
                            withObject:request
                            withObject:[NSNumber numberWithLongLong:bytes]];
}

-(void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    [gcdMulticastDelegate performSelector:@selector(request:didSendBytes:)
                            withObject:request
                            withObject:[NSNumber numberWithLongLong:bytes]];
}

-(void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    [gcdMulticastDelegate performSelector:@selector(request:incrementDownloadSizeBy:)
                            withObject:request
                            withObject:[NSNumber numberWithLongLong:newLength]];

}

-(void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    [gcdMulticastDelegate performSelector:@selector(request:incrementUploadSizeBy:)
                            withObject:request
                            withObject:[NSNumber numberWithLongLong:newLength]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ASIHTTPRequestDelegate delegate

///////////////////////////////////////////////////////////////////////////////////////////////////

//
//-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
//    
//    [self saveDataInCache:data cacheTag:request.tag];
//
//}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
   
    [gcdMulticastDelegate performSelector:@selector(request:didReceiveResponseHeaders:) withObject:request withObject:responseHeaders];
}

-(void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);

    [gcdMulticastDelegate performSelector:@selector(request:willRedirectToURL:) withObject:request withObject:newURL];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    NSDictionary *cacheDic = [self loadCache:request.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRequest_Failed_Notification object:[[cacheDic objectForKey:kStream_Cache_RequestBean_Tag] stringValue]];
    [gcdMulticastDelegate performSelector:@selector(requestFailed:) withObject:request];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{    
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    dispatch_block_t block = ^{@autoreleasepool{
        NSDictionary *cacheDic = [self loadCache:request.tag];
        NSUInteger requestBeanTag = [[cacheDic objectForKey:kStream_Cache_RequestBean_Tag] unsignedIntegerValue];
//        NSData *data = [cacheDic objectForKey:kStream_Cache_Response_Data];

        [self request:[request copy] parse:[request responseData] requestBeanTag:requestBeanTag];
    }};
    
    if (dispatch_get_current_queue() == parseQueue)
        block();
    else
        dispatch_sync(parseQueue, block);
    
    [gcdMulticastDelegate performSelector:@selector(requestFinished:) withObject:request];
}

-(void)requestRedirected:(ASIHTTPRequest *)request
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);

    [gcdMulticastDelegate performSelector:@selector(requestRedirected:) withObject:request];
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    DDLogVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);

    [gcdMulticastDelegate performSelector:@selector(requestStarted:) withObject:request];
}

// 通过插件管理对象，调用插件中实现的方法
-(void)request:(ASIHTTPRequest *)request didReceiveObject:(id)object
{
    // 该方法在dataStreamQueue中执行
    dispatch_block_t block = ^{

        DDLogVerbose(@"%@(%@)tag:%d", THIS_FILE, THIS_METHOD, [(id<ITSResponseDelegate>)object tag]);
        
        // multicastDelgate没有实现该方法，所以在其内部，会把该函数调用消息传递给其保存的delegate中去执行。
        [gcdMulticastDelegate performSelector:@selector(request:didReceiveObject:) withObject:request withObject:object];

    };
    
    // 在dataStreamQueue线程中执行，提交给上层逻辑处理。
    // 上层处理时，需要到对应的线程中执行
    [self execute:block];
}

@end
