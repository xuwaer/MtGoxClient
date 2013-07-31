//
//  AppDelegate.m
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "TransManager.h"
#import "UserDefault.h"
#import "BaiduMobStat.h"
#import "BitcoinIntroController.h"
#import "BitcoinMiningController.h"


#import "UINavigationBar+CustomNav.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 配置用户行为收集
    if (IsCollectUserEvent) 
        [self setupBaiduMobStat];
    
    // 设置连接配置
    [self setupConfig];
    
    // 申请远程推送token
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    viewController.title = @"最新汇率";
    
    if (IsCollectUserEvent) 
        viewController.isCollectEvent = YES;
    
    BitcoinIntroController *introController = [[BitcoinIntroController alloc] init];
    introController.title = @"交易指南";
    BitcoinMiningController *miningController = [[BitcoinMiningController alloc] init];
    miningController.title = @"挖矿指南";
    
    UINavigationController *mtgNav = [[UINavigationController alloc] initWithRootViewController:viewController];
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:introController];
    UINavigationController *miningNav = [[UINavigationController alloc] initWithRootViewController:miningController];
    
    [viewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_mtg"] withFinishedUnselectedImage:[UIImage imageNamed:@"btn_mtg"]];
    [introController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_intro"] withFinishedUnselectedImage:[UIImage imageNamed:@"btn_intro"]];
    [miningController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_miming"] withFinishedUnselectedImage:[UIImage imageNamed:@"btn_mining"]];
    // 设置导航栏背景
    if ([mtgNav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        UIImage *navbgImage= [UIImage imageNamed:@"bg_nav.png"];
        [mtgNav.navigationBar setBackgroundImage:navbgImage forBarMetrics:UIBarMetricsDefault];
    }
    if ([introNav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        UIImage *navbgImage= [UIImage imageNamed:@"bg_nav.png"];
        [introNav.navigationBar setBackgroundImage:navbgImage forBarMetrics:UIBarMetricsDefault];
    }
    if ([miningNav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        UIImage *navbgImage= [UIImage imageNamed:@"bg_nav.png"];
        [miningNav.navigationBar setBackgroundImage:navbgImage forBarMetrics:UIBarMetricsDefault];
    }
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = @[mtgNav, introNav, miningNav];
    tabbar.tabBar.backgroundImage = [UIImage imageNamed:@"bg_tabbar"];

    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // 重置标识数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    userDefault.token = deviceToken;
    [userDefault saveUserDefault];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    userDefault.token = nil;
}

-(void)setupConfig
{
    // 完成环境初始化
    userDefault = [UserDefault defaultUser];
    [TransManager defaultManager];

//    const char * hostnameChar = getHostnameWithPlatform(userDefault.platform);
//    NSString * hostnameStr = [NSString stringWithCString:hostnameChar encoding:NSUTF8StringEncoding];
//    TransManager *transManager = [TransManager defaultManager];
//    [transManager setHostname:hostnameStr];
//    hostnameChar = NULL;
}

-(void)setupBaiduMobStat
{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    // 配置是否打开崩溃日志收集
    statTracker.enableExceptionLog = NO;
    // 配置渠道名，默认为appStore
//    statTracker.channelId = @"";
    // 自定义日志发送间隔
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
    // 日志发送间隔1小时
    statTracker.logSendInterval = 1;
    // 仅在WIFI发送
    statTracker.logSendWifiOnly = YES;
    statTracker.sessionResumeInterval = 60;
    // AppKey
    [statTracker startWithAppId:BaiduAppId];
}

@end
