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
#import "RemindUpdateRequest.h"
#import "RemindUpdateResponse.h"
#import "Remind.h"
#import "RemindSettingQueue.h"
#import "TransManager.h"

#import "ProgressController.h"
#import "DeviceUtil.h"

#import "UserDefault.h"
#import "Constant.h"
#import "ConstantUtil.h"

#import "UINavigationBar+CustomNav.h"

#import <QuartzCore/QuartzCore.h>

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
    [progressController destroyProgress];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
    // 生成币种选择器
    picker = [[PickerViewUtil alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeUSD] forKey:@"美元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeEUR] forKey:@"欧元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeJPY] forKey:@"日元"];
    [dic setValue:[NSNumber numberWithInt:CurrencyTypeCNY] forKey:@"人民币"];
    [picker createPickerView:@"请选择币种" dataSource:dic defaultIndex:2];
    // 指定回调方法
    [picker addTarget:self selector:@selector(didSelectedCurrency:) userinfo:nil forEvent:PickerViewUitlEventConfirm];
    
    // 如果是修改提醒，则初始化数据并展示
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

/**
 *	@brief	设置界面UI
 */
-(void)setupUI
{
    [DeviceUtil view:self.view image35inch:@"bg.png" image4inch:@"bg_iphone5.png"];
    // 设置导航栏背景
    // iOS4.x没有该方法，在iOS4.x下，使用类别UINavigationBar+CustomNav来实现背景替换功能
    if ([self.navBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navbgImage= [UIImage imageNamed:@"bg_nav.png"];
        [self.navBar setBackgroundImage:navbgImage forBarMetrics:UIBarMetricsDefault];
    }
    // iOS4.x下，去掉黑边
    self.thresholdTextField.layer.opaque = NO;
    progressController = [[ProgressController alloc] initWithView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Request & Receive message from server

//////////////////////////////////////////////////////////////////////////////////////////

/**
 *	@brief	设置通信层监听器
 */
-(void)setupHttpQueue
{
    remindQueue = [[RemindSettingQueue alloc] init];
    [[TransManager defaultManager] add:remindQueue];
}

/**
 *	@brief	移除通信层监听器
 */
-(void)destoryHttpQueue
{
    [[TransManager defaultManager] remove:remindQueue];
    remindQueue = nil;
    
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UI相关方法，以及事件方法

//////////////////////////////////////////////////////////////////////////////////////////

/**
 *	@brief	确定按钮事件
 *
 *	@param 	sender
 */
-(void)onConfirmButtonClicked:(id)sender
{
    if (![self checkValidate]) return;
    
    [progressController showProgress];
    
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

/**
 *	@brief	取消按钮事件
 *
 *	@param 	sender
 */
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

/**
 *	@brief	选择币种按钮事件
 *
 *	@param 	sender
 */
-(void)onCurrencyButtonClicked:(id)sender
{
    [picker showPickerView:self.view];
}

/**
 *	@brief	设置输入框编辑时的UI
 *
 *	@param 	sender
 */
-(void)onThresholdTextFieldEditDidBegin:(id)sender
{
    [sender setBackground:[UIImage imageNamed:@"bg_model_text_empty@2x.png"]];
}

/**
 *	@brief	设置输入框未编辑时的UI
 *
 *	@param 	sender
 */
-(void)onThresholdTextFieldEditDidEnd:(id)sender
{
    [sender setBackground:[UIImage imageNamed:@"bg_model_text@2x.png"]];
}

/**
 *	@brief	币种选择器回调方法
 *
 *	@param 	object
 */
-(void)didSelectedCurrency:(PickerObject *)object
{
    self.currencyButton.tag = [(NSNumber *)object.value intValue];
    self.currencyButton.titleLabel.text = object.key;
    
    [picker destroyPickerView];
}

/**
 *	@brief	币种选择器取消
 *
 *	@param 	object
 */
-(void)didCanceledCurrency:(PickerObject *)object
{
    [picker destroyPickerView];
}

/**
 *	@brief	根据软键盘弹出，调整UI
 *
 *	@param 	sender
 */
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

/**
 *	@brief	更新前一界面
 */
-(void)updateSettingController:(int)tag
{
    if (tag == kActionTag_Response_Update_Remind) {
        [delegate finishEditRemind:self.remind];
    }
    else if (tag == kActionTag_Response_Set_Remind){
        [delegate finishAddRemind:self.remind];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UITextField delegate

//////////////////////////////////////////////////////////////////////////////////////////

/**
 *	@brief	根据软键盘弹出，调整UI
 *
 *	@param 	sender
 */
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 限制输入字符长度
    if (textField == self.thresholdTextField) {
        if ([textField.text length] >= 10)
            return NO;
        else
            return YES;
    }
    else {
        return YES;
    }
}

/**
 *	@brief	验证输入合法性
 *
 *	@return	验证结果
 */
-(BOOL)checkValidate
{
    if ([self.currencyButton.titleLabel.text isEqualToString:@"请选择币种"]) {
        
        [progressController showToast:@"请选择币种"];
        return NO;
    }
    
    if (self.thresholdTextField.text.length <= 0) {
        
        [progressController showToast:@"请输入阀值"];
        return NO;
    }
    
    return YES;
}

/**
 *	@brief	通讯层访问应答结果的回调方法
 *
 *	@param 	responseFromQueue 	应答结果
 */
-(void)updateUIDisplay:(id)responseFromQueue
{
    [progressController hideProgress];
    
    // 验证应答结果
    if (responseFromQueue == nil || [responseFromQueue isEqual:[NSNull null]]) {
        [progressController showToast:@"添加失败"];
    }
    else if ([responseFromQueue isKindOfClass:[MtGoxTickerResponse class]]) {
        
        // 验证应答类型
        MtGoxTickerResponse *response = (MtGoxTickerResponse *)responseFromQueue;
        if ([self checkResponse:response.tag]) {
            
            // 验证应答数据是否合法
            MtGoxTickerDetailResponse *detail = [response.data objectForKey:lastKey];
            if (detail && [detail.value isKindOfClass:[MtGoxTickerValueResponse class]]) {
                
                MtGoxTickerValueResponse *value = detail.value;
                self.remind.isLarge = self.remind.threshold > [value.value floatValue] ? YES : NO;
                
                //                [ProgressUtil showProgress:@"添加成功" super:self.view];
                
                // 向服务器发送添加&设置提醒请求
                if (isNew)
                    [self addNewRemind];
                else
                    [self editRemind];
            }
            else {
                [progressController showToast:@"添加失败"];
            }
        }
        
    }
    else {
        [progressController showToast:@"添加失败"];
    }
}

/**
 *	@brief	通讯层访问应答结果的回调方法
 *
 *	@param 	responseFromQueue 	应答结果
 */
-(void)showSettingResult:(id)responseFromQueue
{
    // 去掉菊花并销毁
    [progressController destroyProgress];
    
    if (responseFromQueue == nil || [responseFromQueue isEqual:[NSNull null]]) {
        // request fail.
        // 网络异常会导致添加失败
        [progressController showToast:@"添加失败"];
    }
    else if ([responseFromQueue isKindOfClass:[RemindSetResponse class]]) {
        RemindSetResponse *response = (RemindSetResponse *)responseFromQueue;
        // 解析服务器返回数据失败
        if (response.remindID == -1) {
            [progressController showToast:@"添加失败"];
            return;
        }
        // 获取服务器id
        self.remind.remindId = response.remindID;
        [self updateSettingController:response.tag];
    }
    else if ([responseFromQueue isKindOfClass:[RemindUpdateResponse class]]) {
        RemindUpdateResponse *response = (RemindUpdateResponse *)responseFromQueue;
        // 服务器返回失败
        if (response.result == NO) {
            [progressController showToast:@"添加失败"];
            return;
        }
        [self updateSettingController:response.tag];
    }
    else {
        [progressController showToast:@"添加失败"];
    }
}


//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 提醒相关服务器功能

//////////////////////////////////////////////////////////////////////////////////////////

/**
 *	@brief	添加一个新的提醒，并提交给服务器
 */
-(void)addNewRemind
{
    [progressController showProgress];
    
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
    NSData *token = [UserDefault defaultUser].token;
    if (token == nil || [token isEqual:[NSNull null]]) {
        [progressController hideProgress];
        [progressController showToast:@"请检查接收通知功能是否开启。"];
        return;
    }
    request.token = [ConstantUtil getTokenStr:token];    
//    request.token = DEFAULT_TOKEN;
    // 设置回调方法
    [remindQueue sendRequest:request target:self selector:@selector(showSettingResult:)];
}

/**
 *	@brief	添加一个新的提醒，并提交给服务器
 */
-(void)editRemind
{
    [progressController showProgress];
    
    // 请求Url
    const char * commandChar = getRemindServerRequestUrl(RemindType_UpdateAlert);
    NSString *commandStr = [NSString stringWithCString:commandChar encoding:NSUTF8StringEncoding];
    RemindUpdateRequest *request = [[RemindUpdateRequest alloc] initWithCommand:commandStr type:HttpRequestTypeGet];
    
    // id
    request.mid = self.remind.remindId;
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
    NSData *token = [UserDefault defaultUser].token;
    if (token == nil || [token isEqual:[NSNull null]]) {
        [progressController hideProgress];
        [progressController showToast:@"请检查接收通知功能是否开启。"];
        return;
    }
    request.token = [ConstantUtil getTokenStr:token];
//    request.token = DEFAULT_TOKEN;
    // 设置回调方法
    [remindQueue sendRequest:request target:self selector:@selector(showSettingResult:)];
}

/**
 *	@brief	删除一个提醒
 */
-(void)deleteRemind
{
    
}

/**
 *	@brief	判断应答类型
 *
 *	@param 	actionTag 	tag
 *
 *	@return	应答是否合法
 */
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

@end
