//
//  BitcoinMiningController.m
//  MtGoxClient
//
//  Created by WHY? on 13-7-31.
//  Copyright (c) 2013年 tosc-its. All rights reserved.
//

#import "BitcoinMiningController.h"
#import "DeviceUtil.h"

@interface BitcoinMiningController ()

@end

@implementation BitcoinMiningController

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
    [DeviceUtil view:self.view image35inch:@"bg.png" image4inch:@"bg_iphone5.png"];
    [self.contentScroll setContentSize:CGSizeMake(320, 1746)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentScroll:nil];
    [super viewDidUnload];
}
@end
