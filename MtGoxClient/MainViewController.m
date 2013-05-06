//
//  MainViewController.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "MainViewController.h"
#import "MtGoxInformationQueue.h"
#import "MtGoxTickerRequest.h"
#import "MtGoxTickerResponse.h"

#import "PriceCell.h"
#import "TransManager.h"
#import "DeviceUtil.h"

//#import "SettingViewController.h"
#import "SettingAlertControllerViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(id)init
{
    self = [super init];
    if (self) {
        [self setupHttpQueue];
        customViews = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupHttpQueue];
        customViews = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupHttpQueue];
        customViews = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [customViews removeAllObjects];
    
    [self destoryHttpQueue];
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Request & Receive message from server

//////////////////////////////////////////////////////////////////////////////////////////

-(void)setupHttpQueue
{
    mtGoxQueue = [[MtGoxInformationQueue alloc] init];
    [[TransManager defaultManager] add:mtGoxQueue];
}

-(void)destoryHttpQueue
{
    [[TransManager defaultManager] remove:mtGoxQueue];
    mtGoxQueue = nil;
    
}

-(void)updateUIDisplay:(id)responseFromQueue
{
    if ([responseFromQueue isKindOfClass:[MtGoxTickerResponse class]]) {
                
        MtGoxTickerResponse *response = (MtGoxTickerResponse *)responseFromQueue;
        
        if (response.tag == kActionTag_Response_USD)
            mtGoxUSDResponse = response;
        else if (response.tag == kActionTag_Response_EUR)
            mtGoxEURResponse = response;
        else if (response.tag == kActionTag_Response_JPY)
            mtGoxJPYResponse = response;
        else if (response.tag == kActionTag_Response_CNY)
            mtGoxCNYResponse = response;
        
        
        PriceCell *cell = [customViews objectForKey:[NSString stringWithFormat:@"%d", response.tag]];
        [cell display:response];
//        [self.tableView reloadData];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - life cycle

//////////////////////////////////////////////////////////////////////////////////////////

-(void)loadView
{
    [super loadView];
    [self setupUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadTicker];
    timer = [NSTimer scheduledTimerWithTimeInterval:REPEAT_DELAY target:self selector:@selector(loadTicker) userInfo:nil repeats:YES];
}

- (void)setupUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, 300, 180)];
    imageView.image = [UIImage imageNamed:@"bg_pic.png"];
    [self.view addSubview:imageView];
    
    PriceCell *usdCell = [[[NSBundle mainBundle] loadNibNamed:@"PriceCell" owner:self options:nil] lastObject];
    PriceCell *eurCell = [[[NSBundle mainBundle] loadNibNamed:@"PriceCell" owner:self options:nil] lastObject];
    PriceCell *jpyCell = [[[NSBundle mainBundle] loadNibNamed:@"PriceCell" owner:self options:nil] lastObject];
    PriceCell *cnyCell = [[[NSBundle mainBundle] loadNibNamed:@"PriceCell" owner:self options:nil] lastObject];
    
    usdCell.currencyImageView.image = [UIImage imageNamed:@"USD.png"];
    eurCell.currencyImageView.image = [UIImage imageNamed:@"EUR.png"];
    jpyCell.currencyImageView.image = [UIImage imageNamed:@"JPY.png"];
    cnyCell.currencyImageView.image = [UIImage imageNamed:@"CNY.png"];
    
    if ([DeviceUtil getDeviceScrenType] == ScreenType_4_Inch) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 180)];
        imageView.image = [UIImage imageNamed:@"bg_pic.png"];
        [self.view addSubview:imageView];
        usdCell.frame = CGRectMake(10, 176, 300, 106);
        eurCell.frame = CGRectMake(10, 246, 300, 106);
        jpyCell.frame = CGRectMake(10, 316, 300, 106);
        cnyCell.frame = CGRectMake(10, 386, 300, 106);
    }
    else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, 300, 180)];
        imageView.image = [UIImage imageNamed:@"bg_pic.png"];
        [self.view addSubview:imageView];
        
        usdCell.frame = CGRectMake(10, 96, 300, 106);
        eurCell.frame = CGRectMake(10, 166, 300, 106);
        jpyCell.frame = CGRectMake(10, 236, 300, 106);
        cnyCell.frame = CGRectMake(10, 306, 300, 106);
    }

    [self.view addSubview:usdCell];
    [self.view addSubview:eurCell];
    [self.view addSubview:jpyCell];
    [self.view addSubview:cnyCell];
    
    [customViews setValue:usdCell forKey:[[NSNumber numberWithInt:kActionTag_Response_USD] stringValue]];
    [customViews setValue:eurCell forKey:[[NSNumber numberWithInt:kActionTag_Response_EUR] stringValue]];
    [customViews setValue:jpyCell forKey:[[NSNumber numberWithInt:kActionTag_Response_JPY] stringValue]];
    [customViews setValue:cnyCell forKey:[[NSNumber numberWithInt:kActionTag_Response_CNY] stringValue]];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setFrame:CGRectMake(0.0, 0.0, 26.0, 26.0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    [DeviceUtil view:self.view image35inch:@"bg.png" image4inch:@"bg_iphone5.png"];
//    UIImage *bgImage = [UIImage imageNamed:@"bg.png"];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	请求行情数据
 */
-(void)loadTicker

{
    // 请求美元兑换行情
    MtGoxTickerRequest *mtGoxUSDRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeUSD];
    [mtGoxQueue sendRequest:mtGoxUSDRequest target:self selector:@selector(updateUIDisplay:)];
    
    // 请求欧元兑换行情
    MtGoxTickerRequest *mtGoxEURRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeEUR];
    [mtGoxQueue sendRequest:mtGoxEURRequest target:self selector:@selector(updateUIDisplay:)];
    
    // 请求日元兑换行情
    MtGoxTickerRequest *mtGoxJPYRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeJPY];
    [mtGoxQueue sendRequest:mtGoxJPYRequest target:self selector:@selector(updateUIDisplay:)];
    
    // 请求人民币兑换行情
    MtGoxTickerRequest *mtGoxCNYRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeCNY];
    [mtGoxQueue sendRequest:mtGoxCNYRequest target:self selector:@selector(updateUIDisplay:)];
}

-(void)showSetting
{    
//    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    SettingAlertControllerViewController *settingViewController = [[SettingAlertControllerViewController alloc] init];
    settingViewController.title = @"设置";
    [self.navigationController pushViewController:settingViewController animated:YES];
}

@end
