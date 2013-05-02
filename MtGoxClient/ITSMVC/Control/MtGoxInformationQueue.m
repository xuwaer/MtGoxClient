//
//  MtGoxInformationQueue.m
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "MtGoxInformationQueue.h"

#import "MtGoxTickerRequest.h"

@implementation MtGoxInformationQueue

-(void)requestFailed:(ASIHTTPRequest *)request
{
    DDLogVerbose(@"%@", request.error);
}

@end
