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

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:self.threshold] forKey:@"threshold"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.currency] forKey:@"currency"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isLarge] forKey:@"isLarge"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.threshold = [(NSNumber *)[aDecoder decodeObjectForKey:@"threshold"] intValue];
        self.currency = [(NSNumber *)[aDecoder decodeObjectForKey:@"currency"] intValue];
        self.isLarge = [(NSNumber *)[aDecoder decodeObjectForKey:@"isLarge"] boolValue];
    }
    
    return self;
}

@end
