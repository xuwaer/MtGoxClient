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

@interface RemindSettingController : UIViewController
{
    @private
    Remind *_remind;
    PickerViewUtil *picker;
}

@property (nonatomic, strong)Remind *remind;

@property (nonatomic, strong)IBOutlet UIButton *confirmButton;
@property (nonatomic, strong)IBOutlet UIButton *cancelButton;
@property (nonatomic, strong)IBOutlet UIButton *currencyButton;
@property (nonatomic, strong)IBOutlet UITextField *thresholdTextField;

-(IBAction)onConfirmButtonClicked:(id)sender;
-(IBAction)onCancelButtonClicked:(id)sender;
-(IBAction)onCurrencyButtonClicked:(id)sender;
-(IBAction)onThresholdTextFieldEditDidBegin:(id)sender;
-(IBAction)onThresholdTextFieldEditDidEnd:(id)sender;

@end
