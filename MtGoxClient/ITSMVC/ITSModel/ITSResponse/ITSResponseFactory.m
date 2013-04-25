//
//  BaseResponseModel.m
//  FactoryMode
//
//  Created by Xukj on 3/22/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "ITSResponseFactory.h"
#import "JSONResponseFactory.h"
#import "ITSConfig.h"

static ITSResponseFactory *responseFactory;

@implementation ITSResponseFactory

+(ITSResponseFactory *)factory
{
    // 根据配置，使用不同的解码工厂来解码对象。

    if (responseFactory == nil) {
        @synchronized(self){
            
#ifdef response_datatype_json
            responseFactory = [[JSONResponseFactory alloc] init];
#elif defined (response_datatype_xml)
            responseFactory = nil;
#elif defined (response_datatype_data)
            responseFactory = nil;
#elif defined (response_datatype_other)
            responseFactory = nil;
#endif
        }
    }
    
    return responseFactory;
 
}

-(id<ITSResponseDelegate>)decode:(NSData *)source tag:(id)tag
{
    return nil;
}

@end
