//
//  Request.m
//  tfsp_rc
//
//  Created by Xukj on 3/22/13.
//
//

#import "ITSRequest.h"
#import "ITSRequestFactory.h"

@implementation ITSRequest

+(id)encode:(id<ITSRequestDelegate>)source
{
    // 1.使用工厂方法创建编码器。
    // 2.编码
    return [[ITSRequestFactory factory] encode:source];
}

@end
