//
//  UserDefault.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "UserDefault.h"
#import "Remind.h"
#import "Constant.h"

static NSString  * SETTING_PROPERTY_KEY_LASTPLATFORM = @"lastPlatform";
static NSString  * SETTING_PROPERTY_KEY_MTGOXREMINDS = @"mtGoxReminds";
static NSString  * SETTING_PROPERTY_KEY_BTCCHINAREMINDS = @"btcChinaReminds";
static NSString  * SETTING_PROPERTY_KEY_BTCEREMINDS = @"btcEReminds";

@implementation UserDefault

@synthesize platform = _platform;
@synthesize mtGoxRemind = _mtGoxRemind;
@synthesize btcChinaRemind = _btcChinaRemind;
@synthesize btcERemind = _btcERemind;

@synthesize lastPlatformTitle;
@synthesize token;

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

////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Setting file control

////////////////////////////////////////////////////////////////////////////////////////

-(void)getUserDefault
{
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:SettingFile];
    fileContent = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    if (fileContent == nil) {
        [self clearUserDefault];
    }
    else {
        _platform = [(NSNumber *)[fileContent objectForKey:SETTING_PROPERTY_KEY_LASTPLATFORM] intValue];
        _mtGoxRemind = [fileContent objectForKey:SETTING_PROPERTY_KEY_MTGOXREMINDS];
        _btcChinaRemind = [fileContent objectForKey:SETTING_PROPERTY_KEY_BTCCHINAREMINDS];
        _btcERemind = [fileContent objectForKey:SETTING_PROPERTY_KEY_BTCEREMINDS];
    }
        
    [self convertDataToRemind];
}

-(void)clearUserDefault
{
    _platform = PlatformMtGox;
    _mtGoxRemind = [[NSMutableArray alloc] init];
    _btcChinaRemind = [[NSMutableArray alloc] init];
    _btcERemind = [[NSMutableArray alloc] init];
    fileContent = [[NSMutableDictionary alloc] init];
}

-(void)saveUserDefault
{
    if (filePath == nil || fileContent == nil)
        return;
    
    [self convertRemindToData];
    
    [fileContent setValue:[NSNumber numberWithInt:_platform] forKey:SETTING_PROPERTY_KEY_LASTPLATFORM];
    [fileContent setValue:_mtGoxRemind forKey:SETTING_PROPERTY_KEY_MTGOXREMINDS];
    [fileContent setValue:_btcChinaRemind forKey:SETTING_PROPERTY_KEY_BTCCHINAREMINDS];
    [fileContent setValue:_btcERemind forKey:SETTING_PROPERTY_KEY_BTCEREMINDS];
    
    [fileContent writeToFile:filePath atomically:YES];
}

-(void)showlog
{
    
}

-(void)convertDataToRemind
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (NSData *data in _mtGoxRemind) {
        
        Remind *remind = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [tmp addObject:remind];
    }
    _mtGoxRemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    for (NSData *data in _btcChinaRemind) {
        
        Remind *remind = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [tmp addObject:remind];
    }
    _btcChinaRemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    for (NSData *data in _btcERemind) {
        
        Remind *remind = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [tmp addObject:remind];
    }
    _btcERemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    tmp = nil;
}

-(void)convertRemindToData
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (Remind *remind in _mtGoxRemind) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:remind];
        [tmp addObject:data];
    }
    _mtGoxRemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    for (Remind *remind in _btcChinaRemind) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:remind];
        [tmp addObject:data];
    }
    _btcChinaRemind = [NSMutableArray arrayWithArray:tmp];

    
    [tmp removeAllObjects];
    for (Remind *remind in _btcERemind) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:remind];
        [tmp addObject:data];
    }
    _btcERemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    tmp = nil;
}

-(NSString *)lastPlatformTitle
{
    NSString *title = @"";
    
    switch (_platform) {
        case PlatformMtGox:
            title = @"MtGox";
            break;
        case PlatformBtcChina:
            title = @"BtcChina";
            break;
        case PlatformBtcE:
            title = @"Btc-E";
            break;
        default:
            title = @"MtGox";
            break;
    }
    
    return title;
}

@end
