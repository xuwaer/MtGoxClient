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
@class MBProgressHUD;

@protocol RemindSettingDelegate <NSObject>

-(void)finishEditRemind:(Remind *)remind;
-(void)finishAddRemind:(Remind *)remind;

@end

@interface RemindSettingController : UIViewController
{
    @private
    Remind *_remind;
    PickerViewUtil *picker;
    
    RemindSettingQueue *remindQueue;
    
    MBProgressHUD *progress;
}

@property (nonatomic, strong)Remind *remind;
@property (nonatomic, assign)enum Platform platform;

@property (nonatomic, strong)IBOutlet UIButton *confirmButton;
@property (nonatomic, strong)IBOutlet UIButton *cancelButton;
@property (nonatomic, strong)IBOutlet UIButton *currencyButton;
@property (nonatomic, strong)IBOutlet UITextField *thresholdTextField;

@property (nonatomic, assign)id<RemindSettingDelegate> delegate;

-(IBAction)onConfirmButtonClicked:(id)sender;
-(IBAction)onCancelButtonClicked:(id)sender;
-(IBAction)onCurrencyButtonClicked:(id)sender;
-(IBAction)onThresholdTextFieldEditDidBegin:(id)sender;
-(IBAction)onThresholdTextFieldEditDidEnd:(id)sender;

@end
