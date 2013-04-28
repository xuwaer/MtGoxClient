//
//  RemindSettingController.m
//  MtGoxClient
//
//  Created by Xukj on 4/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSettingController.h"
#import "PickerViewUtil.h"

#import "Remind.h"
#import "RemindSettingQueue.h"
#import "TransManager.h"

#import "UserDefault.h"

@interface RemindSettingController ()

@end

@implementation RemindSettingController

@synthesize remind = _remind;
@synthesize platform;

@synthesize confirmButton;
@synthesize cancelButton;
@synthesize currencyButton;
@synthesize thresholdTextField;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setupHttpQueue];
    }
    return self;
}

-(void)dealloc
{
    delegate = nil;
    [self destoryHttpQueue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    picker = [[PickerViewUtil alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeUSD] forKey:@"美元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeEUR] forKey:@"欧元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeJPY] forKey:@"日元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeCNY] forKey:@"人民币"];
    [picker createPickerView:@"请选择币种" dataSource:dic defaultIndex:2];
    
    [picker addTarget:self selector:@selector(didSelectedCurrency:) userinfo:nil forEvent:PickerViewUitlEventConfirm];
//    [picker addTarget:self selector:@selector(didCanceledCurrency:) userinfo:nil forEvent:PickerViewUitlEventCancel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Request & Receive message from server

//////////////////////////////////////////////////////////////////////////////////////////

-(void)setupHttpQueue
{
    remindQueue = [[RemindSettingQueue alloc] init];
    [[TransManager defaultManager] add:remindQueue];
}

-(void)destoryHttpQueue
{
    [[TransManager defaultManager] remove:remindQueue];
    remindQueue = nil;
    
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UI Action method

//////////////////////////////////////////////////////////////////////////////////////////

-(void)onConfirmButtonClicked:(id)sender
{
    if (![self checkValidate]) return;
    
    if (self.remind) {
        int currency = self.currencyButton.tag;
        float threshold = [self.thresholdTextField.text floatValue];
        self.remind.threshold = threshold;
        self.remind.currency = currency;
        
        [delegate finishEditRemind:self.remind];
    }
    else {
        self.remind = [[Remind alloc] init];
        
        int currency = self.currencyButton.tag;
        float threshold = [self.thresholdTextField.text floatValue];
        self.remind.threshold = threshold;
        self.remind.currency = currency;
        self.remind.platform = self.platform;
        
        [delegate finishAddRemind:self.remind];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
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
    self.currencyButton.tag = [(NSNumber *)object.value intValue];
    self.currencyButton.titleLabel.text = object.key;
}

-(void)didCanceledCurrency:(PickerObject *)object
{
    [picker destroyPickerView];
}

-(BOOL)checkValidate
{
    if ([self.currencyButton.titleLabel.text isEqualToString:@"请选择币种"]) {
        return NO;
    }
    
    if (self.thresholdTextField.text.length <= 0) {
        return NO;
    }
    
    return YES;
}

@end
