//
//  Remind.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "Remind.h"

@implementation Remind

@synthesize threshold;
@synthesize currency;
@synthesize isLarge;
@synthesize platform;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithFloat:self.threshold] forKey:@"threshold"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.currency] forKey:@"currency"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isLarge] forKey:@"isLarge"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.platform] forKey:@"platform"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.threshold = [(NSNumber *)[aDecoder decodeObjectForKey:@"threshold"] floatValue];
        self.currency = [(NSNumber *)[aDecoder decodeObjectForKey:@"currency"] intValue];
        self.isLarge = [(NSNumber *)[aDecoder decodeObjectForKey:@"isLarge"] boolValue];
        self.platform = [(NSNumber *)[aDecoder decodeObjectForKey:@"platform"] intValue];
    }
    
    return self;
}

@end
