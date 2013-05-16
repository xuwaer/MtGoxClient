//
//  BaseViewController.m
//  MtGoxClient
//
//  Created by Xukj on 5/15/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize isCollectEvent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 收集用户行为
    if (isCollectEvent) {
        NSString *pageName = NSStringFromClass([self class]);
        [[BaiduMobStat defaultStat] pageviewStartWithName:pageName];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 收集用户行为
    if (isCollectEvent) {
        NSString *pageName = NSStringFromClass([self class]);
        [[BaiduMobStat defaultStat] pageviewEndWithName:pageName];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
