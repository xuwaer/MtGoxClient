//
//  RemindSettingController.h
//  MtGoxClient
//
//  Created by Xukj on 4/27/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Remind;
@class PickerViewUtil;
@class RemindSettingQueue;
@class ProgressController;

/**
 *	@brief	委托。完成添加、修改操作后，调用
 */
@protocol RemindSettingDelegate <NSObject>

-(void)finishEditRemind:(Remind *)remind;
-(void)finishAddRemind:(Remind *)remind;

@end

/**
 *	@brief	阀值设置界面
 */
@interface RemindSettingController : UIViewController<UITextFieldDelegate>
{
    @private
    Remind *_remind;            //提醒实体bean
    PickerViewUtil *picker;     //用于生成picker的工具
    
    RemindSettingQueue *remindQueue;    //通讯控制层
    
    ProgressController *progressController;     //提示信息控制器
}

@property (nonatomic, strong)Remind *remind;
@property (nonatomic, assign)enum Platform platform;

@property (nonatomic, strong)IBOutlet UIButton *confirmButton;
@property (nonatomic, strong)IBOutlet UIButton *cancelButton;
@property (nonatomic, strong)IBOutlet UIButton *currencyButton;
@property (nonatomic, strong)IBOutlet UITextField *thresholdTextField;

@property (nonatomic, strong)IBOutlet UIView *containView;
@property (nonatomic, strong)IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong)IBOutlet UIButton *backgroundButton;

@property (nonatomic, assign)id<RemindSettingDelegate> delegate;

-(IBAction)onConfirmButtonClicked:(id)sender;
-(IBAction)onCancelButtonClicked:(id)sender;
-(IBAction)onCurrencyButtonClicked:(id)sender;
-(IBAction)onThresholdTextFieldEditDidBegin:(id)sender;
-(IBAction)onThresholdTextFieldEditDidEnd:(id)sender;
-(IBAction)onTouchUpBackGround:(id)sender;

@end
