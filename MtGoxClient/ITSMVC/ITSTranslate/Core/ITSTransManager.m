//
//  TransManager.m
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "ITSTransManager.h"
#import "ITSConfig.h"

static ITSTransManager *transManager;

@implementation ITSTransManager

@synthesize stream = _stream;

+(id)defaultManager
{
    if (transManager == nil) {
        @synchronized(transManager){
            transManager = [[ITSTransManager alloc] init];
        }
    }
    
    return transManager;
}

-(id)init
{
    self = [super init];
    
    if (self) {
#ifdef connectiontype_socket
        _stream = nil;
#elif defined (connectiontype_http)
        _stream = [[ITSHttpStream alloc] init];
#elif defined (connectiontype_other)
        _stream = nil;
#endif
        controllers = [[NSMutableArray alloc] init];
        
        // log日志记录
#if DEBUG
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
    }
    
    return self;
}

-(NSString *)hostname
{
    if (_stream) {
        return [_stream hostname];
    }
    
    return nil;
}

-(void)setHostname:(NSString *)inHostname
{
    if (_stream) {
        [_stream setHostname:inHostname];
    }
}

-(NSString *)port
{
    if (_stream) {
        return [_stream port];
    }
    
    return nil;
}

-(void)setPort:(NSString *)inPort
{
    if (_stream) {
        [_stream setPort:inPort];
    }
}

-(BOOL)add:(ITSQueueModule *)queueModule
{
    
    //加入callback缓存
    if ([queueModule plugin:_stream]) {
        [controllers addObject:queueModule];
        return YES;
    }
    
    return NO;
}

-(void)remove:(ITSQueueModule *)queueModule
{
    [controllers removeObject:queueModule];
    [queueModule pullout];
}

@end
