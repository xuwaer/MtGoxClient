//
//  HttpQueueModule.m
//  tfsp_rc
//
//  Created by Xukj on 3/28/13.
//
//

#import "HttpQueueModule.h"
#import "MKNetworkOperationExt.h"

#define kTag @"tag"

@interface HttpQueueModule ()

/**
 *	@brief	生成流水号，配对请求与响应
 *
 *	@return	流水号
 */
-(NSUInteger)waterTag;

/**
 *	@brief	获取指定的上下文
 *
 *	@param 	inTag 	流水号，查找配对的上下文
 *
 *	@return	上下文
 */
-(TargetContext *)loadContextWithTag:(NSUInteger)inTag;

@end

@implementation HttpQueueModule

-(id)init
{
    self = [super init];
    
    if (self) {
        contextDic = [[NSMutableDictionary alloc] init];
        transManager = [TransManager defaultManager];
        tag = 1;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private API

////////////////////////////////////////////////////////////////////////////////////////////////////

-(TargetContext *)loadContextWithTag:(NSUInteger)inTag
{
    TargetContext *context = [self getContext:inTag];
    [self removeContext:inTag];
    return context;
}

-(void)performContext:(NSUInteger)inTag
{    
    TargetContext *context = [self loadContextWithTag:inTag];
    
    if (context && context.target && context.selector) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [context.target performSelector:context.selector];
#pragma clang diagnostic pop
        });
    }}

-(void)performContext:(NSUInteger)inTag object:(id)object
{
    TargetContext *context = [self loadContextWithTag:inTag];
    
    if (context && context.target && context.selector) {
                
        dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [context.target performSelector:context.selector withObject:object];
#pragma clang diagnostic pop
        });
    }}

-(void)performContext:(NSUInteger)inTag object1:(id)object1 object2:(id)object2
{
    TargetContext *context = [self loadContextWithTag:inTag];
    
    if (context && context.target && context.selector) {
        
        __block id inObject1 = object1;
        __block id inObject2 = object2;

        dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [context.target performSelector:context.selector withObject:inObject1 withObject:inObject2];
#pragma clang diagnostic pop
        });
    }
}


-(NSUInteger)waterTag
{
    return (tag > 999) ? 1 : ++tag;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Public API

////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)sendRequest:(BaseRequest *)request
{
    [self sendRequest:request target:nil selector:nil];
}

-(void)sendRequest:(BaseRequest *)request
            target:(id)target
          selector:(SEL)selector
{
    DDLogCVerbose(@"%@(%@)", THIS_FILE, THIS_METHOD);
    
    [self schedule:^{@autoreleasepool{
        NSDictionary *userinfo = nil;
        
        if (target && selector) {
            
            TargetContext *context = [[TargetContext alloc] initWithTarget:target selector:selector];
            NSUInteger requestTag = [self saveContext:context];
            userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:requestTag] forKey:kTag];
        }
        
        ITSStream *stream = [transManager stream];
        if ([stream isKindOfClass:[ITSHttpStream class]]) {
            [(ITSHttpStream *)stream sendHttpRequest:request userinfo:userinfo];
        }
    }}];
}

-(NSUInteger)getContextTag:(MKNetworkOperation *)request
{
    __block NSUInteger result = 0;
    
    [self execute:^{@autoreleasepool{
        
        if (request == nil) {
            result = 0;
        }
        else {
            
            NSDictionary *userinfo = ((MKNetworkOperationExt *)request).userinfo;
            if (userinfo == nil || ![userinfo objectForKey:kTag]) {
                result = 0;
            }
            else {
                result = [(NSNumber * )[userinfo objectForKey:kTag] unsignedIntegerValue];
            }
        }
    }}];
    
    return result;
}

-(TargetContext *)getContext:(NSUInteger)inTag
{
    
    __block TargetContext *result = nil;
    
    [self execute:^{@autoreleasepool{
        NSString *key = [NSString stringWithFormat:@"%d", inTag];
        TargetContext *context = [contextDic objectForKey:key];
        result = context;
    }}];
    
    return result;
}

-(void)removeContext:(NSUInteger)inTag
{
    [self execute:^{@autoreleasepool{
        NSString *key = [NSString stringWithFormat:@"%d", inTag];
        [contextDic removeObjectForKey:key];
    }}];
}

-(NSUInteger)saveContext:(TargetContext *)inContext
{
    __block NSUInteger result = 0;
    
    [self execute:^{@autoreleasepool{
        NSUInteger inTag = [self waterTag];
        [contextDic setValue:inContext forKey:[NSString stringWithFormat:@"%d", inTag]];
        
        result = inTag;
    }}];

    return result;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - HttpStream delegate

////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)request:(MKNetworkOperation *)opt didReceiveObject:(id)object
{
    
    DDLogCVerbose(@"%@(%@)tag:%d", NSStringFromClass([self class]), THIS_METHOD, [(id<ITSResponseDelegate>)object tag]);
    
    NSUInteger resultTag = [self getContextTag:opt];
    
    [self performContext:resultTag object:object];
}

-(void)requestFailed:(MKNetworkOperation *)opt error:(NSError *)error
{
    DDLogCVerbose(@"%@(%@)", NSStringFromClass([self class]), THIS_METHOD);
}

-(void)requestFinished:(MKNetworkOperation *)opt
{
    DDLogCVerbose(@"%@(%@)", NSStringFromClass([self class]), THIS_METHOD);
}

@end

@implementation TargetContext

@synthesize target;
@synthesize selector;

-(id)initWithTarget:(id)inTarget selector:(SEL)inSelector
{
    self = [super init];
    
    if (self) {
        self.target = inTarget;
        self.selector = inSelector;
    }
    
    return self;
}

@end
