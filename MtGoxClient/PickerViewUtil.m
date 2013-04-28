//
//  PickerViewUtil.m
//  likepal
//
//  Created by tfsp on 12-4-27.
//  Copyright (c) 2012年 uestc. All rights reserved.
//

#import "PickerViewUtil.h"

@implementation PickerObject

@synthesize value;
@synthesize key;
@synthesize selection;
@synthesize userinfo;

@end

@implementation PickerViewUtil

///////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Pick Control

///////////////////////////////////////////////////////////////////////////////////////////

-(void)sure
{
    [_sheet dismissWithClickedButtonIndex:0 animated:YES];
    
    if (_event == PickerViewUitlEventConfirm && _target && _selector) {
        PickerObject *object= [[PickerObject alloc] init];
        object.value = selectedValue;
        object.key = selectedKey;
        object.selection = selectedIndex;
        object.userinfo = _userinfo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_selector withObject:object];
#pragma clang diagnostic pop
    }    
}

-(void)cancel
{
    [_sheet dismissWithClickedButtonIndex:0 animated:YES];
    
    if (_event == PickerViewUitlEventCancel && _target && _selector) {
        PickerObject *object= [[PickerObject alloc] init];
        object.userinfo = _userinfo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_selector withObject:object];
#pragma clang diagnostic pop
    }
}

///////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - View Delegate / PickerView DataSource

///////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //返回每个组件行数
    return [keys count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //指定组件某一行添加数据
    return [keys objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedValue = [values objectAtIndex:row];
    selectedKey = [keys objectAtIndex:row];
    selectedIndex = row;
}

-(void)addTarget:(id)target
        selector:(SEL)selector
        userinfo:(NSDictionary *)userinfo
        forEvent:(enum PickerViewUitlEvent)event
{
    _target = target;
    _selector = selector;
    _event = event;
    _userinfo = [NSDictionary dictionaryWithDictionary:userinfo];
}

///////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Create PickerView

///////////////////////////////////////////////////////////////////////////////////////////

-(void)createPickerView:(NSString *)title
             dataSource:(NSDictionary *)dataSource
           defaultIndex:(NSUInteger)defaultIndex
{
    _title = title;
    _dataSource = dataSource;
    _defaultIndex = defaultIndex;
    
    keys = [NSArray arrayWithArray:[_dataSource allKeys]];
    values = [NSArray arrayWithArray:[_dataSource allValues]];
    
    DDLogVerbose(@"%@", keys);
    DDLogVerbose(@"%@", values);
    
    [self createPickerView];
    [self setupDefaultCursor];
}

-(void)createPickerView
{
    _sheet=[[UIActionSheet alloc]initWithTitle:_title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    _picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 320, 0)];
    _picker.delegate=self;
    _picker.dataSource=self;
    _picker.showsSelectionIndicator=YES;
    _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _toolBar.barStyle=UIBarStyleBlackOpaque;
    [_toolBar sizeToFit];
    
    // 设置pickerview上方的title
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sure)];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    NSArray *barArray=[NSArray arrayWithObjects:leftBar,fixedButton,rightBar, nil];
    
    [_toolBar setItems:barArray animated:YES];
    [_sheet addSubview:_toolBar];
    [_sheet addSubview:_picker];
}

-(void)setupDefaultCursor
{
    selectedKey = [keys objectAtIndex:0];
    selectedValue = [values objectAtIndex:0];
//    [_picker selectRow:_defaultIndex inComponent:1 animated:NO];
}

-(void)showPickerView:(UIView *)superView
{
    _superView = superView;
    [_sheet showInView:_superView];
    [_sheet setBounds:CGRectMake(0, 0, 320, 450)];
}

-(void)destroyPickerView
{
    [_sheet removeFromSuperview];
    
    _dataSource = nil;
    
    _superView = nil;
    _toolBar = nil;
    _picker = nil;
    _sheet = nil;
    
    _target = nil;
    _selector = NULL;
    _userinfo = nil;
}

@end
