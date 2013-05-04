//
//  SettingAlertControllerViewController.m
//  MtGoxClient
//
//  Created by Xukj on 5/2/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "SettingAlertControllerViewController.h"

#import "UserDefault.h"
#import "SettingCellControllerViewController.h"
#import "DeviceUtil.h"

@interface SettingAlertControllerViewController ()

//初始化数据，从plist读取用户配置
-(void)initData;
//完成界面显示的调整
-(void)setupUI;

@end

@implementation SettingAlertControllerViewController

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

-(void)initData
{
    UserDefault *userDefault = [UserDefault defaultUser];
    [userDefault getUserDefault];
    
    mtGoxCellController = [[SettingCellControllerViewController alloc] init];
    mtGoxCellController.dataArray = userDefault.mtGoxRemind;
    mtGoxCellController.alterDelegate = self;
    
    btcChinaCellController = [[SettingCellControllerViewController alloc] init];
    btcChinaReminds = userDefault.btcChinaRemind;
    btcChinaCellController.alterDelegate = self;
    
    btcECellController = [[SettingCellControllerViewController alloc] init];
    btcEReminds = userDefault.btcERemind;
    btcECellController.alterDelegate = self;
}

-(void)setupUI
{
    // 针对iphone4、4s
    CGRect mtGoxFrame = CGRectMake(8, 12, 303, 169);
    mtGoxCellController.view.frame = mtGoxFrame;
    [self.scrollView addSubview:mtGoxCellController.view];
    mtGoxCellController.headerTitleLabel.text = @"MtGox";
//    
//    CGRect btcChinaFrame = CGRectMake(8, 147, 303, 169);
//    btcChinaCellController.view.frame = btcChinaFrame;
//    [self.scrollView addSubview:btcChinaCellController.view];
//    btcChinaCellController.headerTitleLabel.text = @"BTCChina";
//    
//    CGRect btcEFrame = CGRectMake(8, 282, 303, 169);
//    btcECellController.view.frame = btcEFrame;
//    [self.scrollView addSubview:btcECellController.view];
//    btcECellController.headerTitleLabel.text = @"BTC-E";
//
//    UIImage *bgImage = [UIImage imageNamed:@"bg.png"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    [DeviceUtil view:self.view image35inch:@"bg.png" image4inch:@"bg_iphone5.png"];

    // 设置返回按钮样式
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0.0, 0.0, 26, 26)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
