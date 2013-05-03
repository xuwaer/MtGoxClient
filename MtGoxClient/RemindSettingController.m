//
//  RemindSettingController.m
//  MtGoxClient
//
//  Created by Xukj on 4/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "RemindSettingController.h"
#import "PickerViewUtil.h"

#import "MtGoxTickerRequest.h"
#import "MtGoxTickerResponse.h"
#import "RemindSetReqest.h"
#import "RemindSetResponse.h"
#import "Remind.h"
#import "RemindSettingQueue.h"
#import "TransManager.h"

#import "MBProgressHUD.h"
#import "ProgressUtil.h"
#import "DeviceUtil.h"

#import "UserDefault.h"
#import "Constant.h"

@interface RemindSettingController ()
{
    BOOL isNew;         // 是否是添加操作
}

@end

@implementation RemindSettingController

@synthesize remind = _remind;
@synthesize platform;

@synthesize confirmButton;
@synthesize cancelButton;
@synthesize currencyButton;
@synthesize thresholdTextField;
@synthesize navBar;
@synthesize containView;
@synthesize backgroundButton;

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
    
    [self setupUI];
    
    picker = [[PickerViewUtil alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeUSD] forKey:@"美元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeEUR] forKey:@"欧元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeJPY] forKey:@"日元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeCNY] forKey:@"人民币"];
    [picker createPickerView:@"请选择币种" dataSource:dic defaultIndex:2];
    
    [picker addTarget:self selector:@selector(didSelectedCurrency:) userinfo:nil forEvent:PickerViewUitlEventConfirm];

    isNew = NO;
    if (self.remind) {
        self.currencyButton.tag = self.remind.currency;
        const char * currencyChar = currencyTypeConvertToCurrencyName(self.remind.currency);
        NSString *currencyStr = [NSString stringWithCString:currencyChar encoding:NSUTF8StringEncoding];
        self.currencyButton.titleLabel.text = currencyStr;
        self.thresholdTextField.text = [NSString stringWithFormat:@"%.4f", self.remind.threshold];
        currencyChar = NULL;
    }
}

-(void)setupUI
{
//    UIImage *bgImage = [UIImage imageNamed:@"bg.png"];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
    [DeviceUtil setBackground:self.view imageiPhone:@"bg.png" imageiPhone5:@"bg_iphone5.png"];
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"bg_nav.png"] forBarMetrics:0];
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
        
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.mode = MBProgressHUDModeIndeterminate;
    [progress show:YES];
    
    if (self.remind) {
        int currency = self.currencyButton.tag;
        float threshold = [self.thresholdTextField.text floatValue];
        self.remind.threshold = threshold;
        self.remind.currency = currency;
        isNew = NO;
    }
    else {
        self.remind = [[Remind alloc] init];
        isNew = YES;
        
        int currency = self.currencyButton.tag;
        float threshold = [self.thresholdTextField.text floatValue];
        self.remind.threshold = threshold;
        self.remind.currency = currency;
        self.remind.platform = self.platform;
        
    }
    
    MtGoxTickerRequest *mtGoxUSDRequest = [[MtGoxTickerRequest alloc] initWithCurrency:self.remind.currency];
    [remindQueue sendRequest:mtGoxUSDRequest target:self selector:@selector(updateUIDisplay:)];
    
}

-(void)onCancelButtonClicked:(id)sender
{
    if (self.thresholdTextField.editing) {
        
        //当用户按下return，把焦点从textField移开那么键盘就会消失了
        NSTimeInterval animationDuration = 0.3f;
        CGRect frame = self.containView.frame;
        frame.origin.y +=216;
        frame.size. height -=216;
        //self.view移回原位置
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.containView.frame = frame;
        [UIView commitAnimations];
        [self.thresholdTextField resignFirstResponder];
        
    }
    
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

-(void)onTouchUpBackGround:(id)sender
{
    if (self.thresholdTextField.editing) {
        
        //当用户按下return，把焦点从textField移开那么键盘就会消失了
        NSTimeInterval animationDuration = 0.3f;
        CGRect frame = self.containView.frame;
        frame.origin.y +=216;
        frame.size. height -=216;
        //self.view移回原位置
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.containView.frame = frame;
        [UIView commitAnimations];
        [self.thresholdTextField resignFirstResponder];

    }
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UITextField delegate

//////////////////////////////////////////////////////////////////////////////////////////

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.containView.frame;
    frame.origin.y -=216;
    frame.size.height +=216;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.containView.frame = frame;
    [UIView commitAnimations];
}

-(BOOL)checkValidate
{
    if ([self.currencyButton.titleLabel.text isEqualToString:@"请选择币种"]) {
        
        [ProgressUtil showProgress:@"请选择币种" super:self.view];
        return NO;
    }
    
    if (self.thresholdTextField.text.length <= 0) {
        
        [ProgressUtil showProgress:@"请输入阀值" super:self.view];
        return NO;
    }
    
    return YES;
}

-(void)updateUIDisplay:(id)responseFromQueue
{
    if (responseFromQueue == nil || [responseFromQueue isEqual:[NSNull null]]) {
        [progress removeFromSuperview];
        [ProgressUtil showProgress:@"添加失败" super:self.view];
    }
    else if ([responseFromQueue isKindOfClass:[MtGoxTickerResponse class]]) {
                
        MtGoxTickerResponse *response = (MtGoxTickerResponse *)responseFromQueue;
        if ([self checkResponse:response.tag]) {
            
            MtGoxTickerDetailResponse *detail = [response.data objectForKey:lastKey];
            if (detail && [detail.value isKindOfClass:[MtGoxTickerValueResponse class]]) {
                
                MtGoxTickerValueResponse *value = detail.value;
                self.remind.isLarge = self.remind.threshold > [value.value floatValue] ? YES : NO;
                
//                [ProgressUtil showProgress:@"添加成功" super:self.view];
                
                [self sendRemind];
            }
            else {
                [progress removeFromSuperview];
                [ProgressUtil showProgress:@"添加失败" super:self.view];
            }
        }

    }
    else {
        [progress removeFromSuperview];
        [ProgressUtil showProgress:@"添加失败" super:self.view];
    }
}

-(void)showSettingResult:(id)responseFromQueue
{
    if (responseFromQueue && [responseFromQueue isKindOfClass:[RemindSetResponse class]]) {
        [progress removeFromSuperview];
        
        [self updateSettingController];
    }
}

-(void)sendRemind
{
    // 请求Url
    const char * commandChar = getRemindServerRequestUrl(RemindType_SetAlert);
    NSString *commandStr = [NSString stringWithCString:commandChar encoding:NSUTF8StringEncoding];
    RemindSetReqest *request = [[RemindSetReqest alloc] initWithCommand:commandStr type:HttpRequestTypeGet];
    
    // 平台
    const char *platformCodeChar = getPlatformCodeWithPlatform(self.remind.platform);
    NSString *platformCodeStr = [NSString stringWithCString:platformCodeChar encoding:NSUTF8StringEncoding];
    request.plat = platformCodeStr;
    platformCodeStr = NULL;
    // 币种
    const char *currencyCodeChar = currencyTypeConvertToCurrencyCode(self.remind.currency);
    NSString *currencyCodeStr = [NSString stringWithCString:currencyCodeChar encoding:NSUTF8StringEncoding];
    request.cur = currencyCodeStr;
    currencyCodeChar = NULL;
    // 阀值
    request.check = self.remind.threshold;
    // 大于？
    request.islarge = self.remind.isLarge;
    // token
    request.token = DEFAULT_TOKEN;
    
    [remindQueue sendRequest:request target:self selector:@selector(showSettingResult:)];
}

-(BOOL)checkResponse:(int)actionTag
{
    if (actionTag == kActionTag_Request_USD && self.remind.currency == CurrencyTypeUSD)
        return YES;
    
    if (actionTag == kActionTag_Request_EUR && self.remind.currency == CurrencyTypeEUR)
        return YES;
    
    if (actionTag == kActionTag_Request_JPY && self.remind.currency == CurrencyTypeJPY)
        return YES;
    
    if (actionTag == kActionTag_Request_CNY && self.remind.currency == CurrencyTypeCNY)
        return YES;
    
    return NO;
}

-(void)updateSettingController
{
    if (!isNew) {
        [delegate finishEditRemind:self.remind];
    }
    else {
        [delegate finishAddRemind:self.remind];
    }
        
    [self dismissModalViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    
    //自适应代码
    CGRect containFrame = self.containView.frame;
    containFrame = CGRectMake(containFrame.origin.x, containFrame.origin.y - (distanceToMove + normalKeyboardHeight), containFrame.size.width, containFrame.size.width);
    self.containView.frame = containFrame;
}

@end
