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
#import "ITS.h"

static NSString  * SETTING_PROPERTY_KEY_LASTPLATFORM = @"lastPlatform";
static NSString  * SETTING_PROPERTY_KEY_MTGOXREMINDS = @"mtGoxReminds";
static NSString  * SETTING_PROPERTY_KEY_BTCCHINAREMINDS = @"btcChinaReminds";
static NSString  * SETTING_PROPERTY_KEY_BTCEREMINDS = @"btcEReminds";
static NSString  * SETTING_PROPERTY_KEY_PREVIOUSTOKEN = @"previoustoken";

@implementation UserDefault

@synthesize platform = _platform;
@synthesize mtGoxRemind = _mtGoxRemind;
@synthesize btcChinaRemind = _btcChinaRemind;
@synthesize btcERemind = _btcERemind;
@synthesize prevToken = _prevToken;

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
//    NSString *fileName = [NSString stringWithCString:SettingFile encoding:NSUTF8StringEncoding];
    
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
        _prevToken = [fileContent objectForKey:SETTING_PROPERTY_KEY_PREVIOUSTOKEN];
    }
    
    // 封装
    [self convertDataToRemind];
}

-(void)clearUserDefault
{
    _platform = PlatformMtGox;
    _mtGoxRemind = [[NSMutableArray alloc] init];
    _btcChinaRemind = [[NSMutableArray alloc] init];
    _btcERemind = [[NSMutableArray alloc] init];
    fileContent = [[NSMutableDictionary alloc] init];
    _prevToken = nil;
}

-(void)saveUserDefault
{
    if (filePath == nil || fileContent == nil)
        return;
    
    [self convertRemindToData];
    
    [fileContent setValue:[NSNumber numberWithInt:_platform] forKey:SETTING_PROPERTY_KEY_LASTPLATFORM];
    [fileContent setValue:tmpMtGoxRemind forKey:SETTING_PROPERTY_KEY_MTGOXREMINDS];
    [fileContent setValue:tmpBtcChinaRemind forKey:SETTING_PROPERTY_KEY_BTCCHINAREMINDS];
    [fileContent setValue:tmpBtcERemind forKey:SETTING_PROPERTY_KEY_BTCEREMINDS];
    
    // 保存本次获取的token，如果本次未获取，则不做任何操作
    DDLogVerbose(@"%@", self.token);
    if (self.token)
        [fileContent setValue:self.token forKey:SETTING_PROPERTY_KEY_PREVIOUSTOKEN];
    
    [fileContent writeToFile:filePath atomically:YES];
}

-(void)showlog
{
    
}

-(void)convertDataToRemind
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dic in _mtGoxRemind) {
        Remind *remind = [[Remind alloc] initWithDictionary:dic];
        [tmp addObject:remind];
    }
    _mtGoxRemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    for (NSMutableDictionary *dic in _btcChinaRemind) {
        Remind *remind = [[Remind alloc] initWithDictionary:dic];
        [tmp addObject:remind];
    }
    _btcChinaRemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    for (NSMutableDictionary *dic in _btcERemind) {
        Remind *remind = [[Remind alloc] initWithDictionary:dic];
        [tmp addObject:remind];
    }
    _btcERemind = [NSMutableArray arrayWithArray:tmp];
    
    [tmp removeAllObjects];
    tmp = nil;
}

-(void)convertRemindToData
{
    tmpMtGoxRemind = [[NSMutableArray alloc] init];
    for (Remind *remind in _mtGoxRemind) {
        NSDictionary *dic = [remind encode];
        [tmpMtGoxRemind addObject:dic];
    }
    
    tmpBtcChinaRemind = [[NSMutableArray alloc] init];
    for (Remind *remind in _btcChinaRemind) {
        NSDictionary *dic = [remind encode];
        [tmpBtcChinaRemind addObject:dic];
    }
    
    tmpBtcERemind = [[NSMutableArray alloc] init];
    for (Remind *remind in _btcERemind) {
        NSDictionary *dic = [remind encode];
        [tmpBtcERemind addObject:dic];
    }
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
