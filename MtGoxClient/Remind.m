//
//  Remind.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "Remind.h"

static NSString  * SETTING_PROPERTY_KEY_REMIND_THRESHOLD = @"threshold";
static NSString  * SETTING_PROPERTY_KEY_REMIND_CURRENCY = @"currency";
static NSString  * SETTING_PROPERTY_KEY_REMIND_ISLARGE = @"isLarge";
static NSString  * SETTING_PROPERTY_KEY_REMIND_PLATFORM = @"platform";

@implementation Remind

@synthesize threshold;
@synthesize currency;
@synthesize isLarge;
@synthesize platform;
@synthesize tag;

-(id)initWithDictionary:(NSDictionary *)dataSource
{
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        [self decode];
    }
    
    return self;
}

-(void)decode
{
    if (_dataSource == nil) return;
    
    self.threshold = [(NSNumber *)[_dataSource objectForKey:SETTING_PROPERTY_KEY_REMIND_THRESHOLD] floatValue];
    self.currency = [(NSNumber *)[_dataSource objectForKey:SETTING_PROPERTY_KEY_REMIND_CURRENCY] intValue];
    self.isLarge = [(NSNumber *)[_dataSource objectForKey:SETTING_PROPERTY_KEY_REMIND_ISLARGE] boolValue];
    self.platform = [(NSNumber *)[_dataSource objectForKey:SETTING_PROPERTY_KEY_REMIND_PLATFORM] intValue];
}

-(NSDictionary *)encode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithFloat:self.threshold] forKey:SETTING_PROPERTY_KEY_REMIND_THRESHOLD];
    [dic setValue:[NSNumber numberWithInt:self.currency] forKey:SETTING_PROPERTY_KEY_REMIND_CURRENCY];
    [dic setValue:[NSNumber numberWithBool:self.isLarge] forKey:SETTING_PROPERTY_KEY_REMIND_ISLARGE];
    [dic setValue:[NSNumber numberWithInt:self.platform] forKey:SETTING_PROPERTY_KEY_REMIND_PLATFORM];
    
    return dic;
}

@end
