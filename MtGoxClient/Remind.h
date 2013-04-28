//
//  Remind.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface Remind : NSObject
{
    @private
    NSDictionary *_dataSource;
}

@property (nonatomic, assign)float threshold;
@property (nonatomic, assign)enum CurrencyType currency;
@property (nonatomic, assign)BOOL isLarge;
@property (nonatomic, assign)enum Platform platform;

-(id)initWithDictionary:(NSDictionary *)dataSource;

-(NSDictionary *)encode;

@end
