//
//  URLRequest.m
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "URLRequestFactory.h"

@implementation URLRequestFactory

-(id)encode:(id<ITSRequestDelegate>) source;
{
    return [source encode];
}

@end
