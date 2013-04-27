//
//  RemindSettingController.m
//  MtGoxClient
//
//  Created by Xukj on 4/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSettingController.h"
#import "PickerViewUtil.h"

@interface RemindSettingController ()

@end

@implementation RemindSettingController

@synthesize remind = _remind;

@synthesize confirmButton;
@synthesize cancelButton;
@synthesize currencyButton;
@synthesize thresholdTextField;

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
    // Do any additional setup after loading the view from its nib.
    
    picker = [[PickerViewUtil alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"USD" forKey:@"美元"];
    [dic setValue:@"EUR" forKey:@"欧元"];
    [dic setValue:@"JPY" forKey:@"日元"];
    [dic setValue:@"CNY" forKey:@"人民币"];
    [picker createPickerView:@"请选择币种" dataSource:dic defaultIndex:2];
    
    [picker addTarget:self selector:@selector(didSelectedCurrency:) userinfo:nil forEvent:PickerViewUitlEventConfirm];
//    [picker addTarget:self selector:@selector(didCanceledCurrency:) userinfo:nil forEvent:PickerViewUitlEventCancel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onConfirmButtonClicked:(id)sender
{

}

-(void)onCancelButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onCurrencyButtonClicked:(id)sender
{
    [picker showPickerView:self.view];
}

-(void)onThresholdTextFieldEditDidBegin:(id)sender
{
    [sender setBackground:[UIImage imageNamed:@"bg_model_text_empty@2x.png"]];
}

-(void)onThresholdTextFieldEditDidEnd:(id)sender
{
    [sender setBackground:[UIImage imageNamed:@"bg_model_text@2x.png"]];
}

-(void)didSelectedCurrency:(PickerObject *)object
{
    DDLogVerbose(@"xxx : %@", object.value);
}

-(void)didCanceledCurrency:(PickerObject *)object
{
    [picker destroyPickerView];
}

@end
