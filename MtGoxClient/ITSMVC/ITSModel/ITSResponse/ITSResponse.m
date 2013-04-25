//
//  Response.m
//  FactoryMode
//
//  Created by Xukj on 3/22/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "ITSResponse.h"
#import "ITSResponseFactory.h"

@implementation ITSResponse

+(id)decode:(id)source
{
    return [ITSResponse decode:source tag:nil];
}

+(id)decode:(id)source tag:(id)tag
{
    // 1.使用工厂创建解码器
    // 2.解码
    return [[ITSResponseFactory factory] decode:source tag:tag];
}

@end
