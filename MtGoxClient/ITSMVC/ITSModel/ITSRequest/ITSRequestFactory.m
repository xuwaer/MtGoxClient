//
//  RequestFactory.m
//  tfsp_rc
//
//  Created by Xukj on 3/22/13.
//
//

#import "ITSRequestFactory.h"
#import "URLRequestFactory.h"
#import "ITSConfig.h"

static ITSRequestFactory *requestFactory;

@implementation ITSRequestFactory

+(ITSRequestFactory *)factory
{
    // 根据配置，使用不同的编码工厂来编码对象。
    
    if (requestFactory == nil) {
        @synchronized(self){
            
#ifdef request_datatype_json
            requestFactory = nil;
#elif defined (request_datatype_xml)
            requestFactory = nil;
#elif defined (request_datatype_data)
            requestFactory = nil;
#elif defined (request_datatype_url)
            requestFactory = [[URLRequestFactory alloc] init];
#elif defined (request_datatype_other)
            requestFactory = nil;
#endif

        }
    }
    
    return requestFactory;
}

-(id)encode:(id<ITSRequestDelegate>)source
{
    return [source encode];
}

@end
