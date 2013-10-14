//
//  HttpQueueModule.m
//  tfsp_rc
//
//  Created by Xukj on 3/28/13.
//
//

#import "ITSHttpQueueModule.h"
#import "MKNetworkOperationExt.h"

@implementation ITSHttpQueueModule

-(id)init
{
    self = [super init];
    
    if (self) {
        transManager = [ITSTransManager defaultManager];
    }
    
    return self;
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
            
            userinfo = [NSDictionary dictionaryWithObjectsAndKeys:target, kTarget, NSStringFromSelector(selector), kSelector, nil];
        }
        
        ITSStream *stream = [transManager stream];
        if ([stream isKindOfClass:[ITSHttpStream class]]) {
            [(ITSHttpStream *)stream sendHttpRequest:request userinfo:userinfo];
        }
    }}];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - HttpStream delegate。这里只实现了部分

////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)request:(MKNetworkOperation *)opt didReceiveObject:(id)object
{
    DDLogCVerbose(@"%@(%@)tag:%d", NSStringFromClass([self class]), THIS_METHOD, [(id<ITSResponseDelegate>)object tag]);
    
    NSDictionary *userinfo = ((MKNetworkOperationExt *)opt).userinfo;
    
    if (userinfo) {
        id target = [userinfo objectForKey:kTarget];
        SEL selector = NSSelectorFromString([userinfo objectForKey:kSelector]);
        
        if (target && selector) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:selector withObject:object];
#pragma clang diagnostic pop
            });
        }
    }
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
