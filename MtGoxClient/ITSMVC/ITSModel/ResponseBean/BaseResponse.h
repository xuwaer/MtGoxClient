//
//  BaseResponse.h
//  MVCStruct
//
//  Created by Xukj on 3/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface BaseResponse : NSObject
{
    NSData *_jSONData;
}

@property (nonatomic, strong) NSData *jSONData;

-(id)initWithJSONData:(NSData *)data;

@end

@interface SubResponse : NSObject
{
    NSDictionary *_subDic;
}

@property (nonatomic, strong) NSDictionary *subDic;

-(id)initWithDictionary:(NSDictionary *)dic;

@end