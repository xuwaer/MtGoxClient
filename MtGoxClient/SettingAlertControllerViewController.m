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

@interface SettingAlertControllerViewController ()

@end

@implementation SettingAlertControllerViewController

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
    btcChinaCellController = [[SettingCellControllerViewController alloc] init];
    btcECellController = [[SettingCellControllerViewController alloc] init];
    mtGoxCellController.dataArray = userDefault.mtGoxRemind;
    mtGoxCellController.alterDelegate = self;
    btcChinaReminds = userDefault.btcChinaRemind;
    btcChinaCellController.alterDelegate = self;
    btcEReminds = userDefault.btcERemind;
    btcECellController.alterDelegate = self;
}

-(void)setupUI
{
    // 针对iphone4、4s
    CGRect mtGoxFrame = CGRectMake(8, 10, 303, 240);
    mtGoxCellController.view.frame = mtGoxFrame;
    [self.view addSubview:mtGoxCellController.view];
    
    CGRect btcChinaFrame = CGRectMake(8, 150, 303, 240);
    btcChinaCellController.view.frame = btcChinaFrame;
    [self.view addSubview:btcChinaCellController.view];
    
    CGRect btcEFrame = CGRectMake(8, 290, 303, 240);
    btcECellController.view.frame = btcEFrame;
    [self.view addSubview:btcECellController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
