//
//  UserDefault.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "UserDefault.h"
#import "Remind.h"

@implementation UserDefault

@synthesize platform = _platform;
@synthesize mtGoxRemind = _mtGoxRemind;
@synthesize btcChinaRemind = _btcChinaRemind;
@synthesize btcERemind = _btcERemind;

static UserDefault *userDefault;

+(UserDefault *)defaultUser
{
    if (userDefault == nil) {
        @synchronized(self) {
            userDefault = [[UserDefault alloc] init];
        }
    }
    
    return userDefault;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        [self getUserDefault];
    }
    
    return self;
}

-(void)getUserDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    @try {
        _platform = [(NSNumber *)[defaults objectForKey:@"platform"] intValue];
    }
    @catch (NSException *exception) {
        _platform = PlatformMtGox;
    }
    
    @try {
        NSData *mtGoxRemindData = [defaults objectForKey:@"mtGoxRemind"];
        _mtGoxRemind = [NSKeyedUnarchiver unarchiveObjectWithData:mtGoxRemindData];
    }
    @catch (NSException *exception) {
        _mtGoxRemind = nil;
    }
    
    @try {
        NSData *btcChinaRemindData = [defaults objectForKey:@"btcChinaRemind"];
        _btcChinaRemind = [NSKeyedUnarchiver unarchiveObjectWithData:btcChinaRemindData];
    }
    @catch (NSException *exception) {
        _btcChinaRemind = nil;
    }
    
    @try {
        NSData *btcERemindData = [defaults objectForKey:@"btcERemind"];
        _btcERemind = [NSKeyedUnarchiver unarchiveObjectWithData:btcERemindData];
    }
    @catch (NSException *exception) {
        _btcERemind = nil;
    }
}

-(void)clearUserDefault
{
    _platform = 0;
    _mtGoxRemind = nil;
    _btcERemind = nil;
    _btcChinaRemind = nil;
}

-(void)saveUserDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithInt:_platform] forKey:@"platform"];
    
    if (_mtGoxRemind != nil) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_mtGoxRemind];
        [defaults setObject:data forKey:@"mtGoxRemind"];
        
//        NSMutableArray *tmpMtGoxRemind = [[NSMutableArray alloc] init];
//        for (Remind *remind in _mtGoxRemind) {
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:remind];
//            [tmpMtGoxRemind addObject:data];
//        }
//        
//        [defaults setObject:tmpMtGoxRemind forKey:@"mtGoxRemind"];
    }
    
    if (_btcChinaRemind != nil) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_btcChinaRemind];
        [defaults setObject:data forKey:@"btcChinaRemind"];
        
//        NSMutableArray *tmpBtcChinaRemind = [[NSMutableArray alloc] init];
//        for (Remind *remind in _btcChinaRemind) {
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:remind];
//            [tmpBtcChinaRemind addObject:data];
//        }
//        [defaults setObject:tmpBtcChinaRemind forKey:@"btcChinaRemind"];
    }

    if (_btcERemind != nil) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_btcERemind];
        [defaults setObject:data forKey:@"btcERemind"];

//        NSMutableArray *tmpBtcERemind = [[NSMutableArray alloc] init];
//        for (Remind *remind in _btcERemind) {
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:remind];
//            [tmpBtcERemind addObject:data];
//        }
//        [defaults setObject:tmpBtcERemind forKey:@"btcERemind"];
    }
    
    [defaults synchronize];
    
    //    [self showlog];
}

//-(NSMutableArray *)mtGoxRemind
//{
//    NSMutableArray *tmpMtGoxRemind = [[NSMutableArray alloc] init];
//    if (_mtGoxRemind == nil)    return nil;
//
//    for (NSData *data in _mtGoxRemind) {
//        id remindObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        if ([remindObject isKindOfClass:[Remind class]])
//            [tmpMtGoxRemind addObject:remindObject];
//    }
//    
//    return tmpMtGoxRemind;
//}
//
//-(NSMutableArray *)btcChinaRemind
//{
//    
//    NSMutableArray *tmpBtcChinaRemind = [[NSMutableArray alloc] init];
//    if (_btcChinaRemind == nil)    return nil;
//    
//    for (NSData *data in _btcChinaRemind) {
//        id remindObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        if ([remindObject isKindOfClass:[Remind class]])
//            [tmpBtcChinaRemind addObject:remindObject];
//    }
//    
//    return tmpBtcChinaRemind;
//}
//
//-(NSMutableArray *)btcERemind
//{
//    NSMutableArray *tmpBtcERemind = [[NSMutableArray alloc] init];
//    if (_btcERemind == nil)    return nil;
//    
//    for (NSData *data in _btcERemind) {
//        id remindObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        if ([remindObject isKindOfClass:[Remind class]])
//            [tmpBtcERemind addObject:remindObject];
//    }
//    
//    return tmpBtcERemind;
//}

-(void)showlog
{

}

@end
