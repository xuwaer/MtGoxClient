//
//  PickerViewUtil.h
//  likepal
//
//  Created by tfsp on 12-4-27.
//  Copyright (c) 2012年 uestc. All rights reserved.
//

#import <Foundation/Foundation.h>

enum PickerViewUitlEvent {
    PickerViewUitlEventConfirm,
    PickerViewUitlEventCancel,
    PickerViewUtilEventOther
};

@interface PickerObject : NSObject

@property (nonatomic, strong)id value;
@property (nonatomic, strong)NSString *key;
@property (nonatomic, assign)NSUInteger selection;
@property (nonatomic, strong)NSDictionary *userinfo;

@end

/**
 *	@brief	PickerView控制器，用于选取指定的项目。类似android中的spinner
 */
@interface PickerViewUtil : NSObject<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
{
    @private
    // UI
    UIActionSheet *_sheet;
    UIPickerView *_picker;
    UIToolbar *_toolBar;
    UIView *_superView;
    NSString *_title;
    
    // UIPickerView数据源
    NSDictionary *_dataSource;
    NSUInteger _defaultIndex;
    NSArray *keys;
    NSArray *values;
    
    // UIPickerView操作数据
    id selectedValue;               //选中值
    NSString *selectedKey;          //选中名
    NSUInteger selectedIndex;       //选中游标
    
    // 为选择器提供设置回调功
    id _target;
    SEL _selector;
    enum PickerViewUitlEvent _event;
    NSDictionary *_userinfo;
}

/**
 *	@brief	创建选择器
 *
 *	@param 	title 	选择器标题（暂时无效）
 *	@param 	superView 	选择器依附的view
 *	@param 	dataSource 	用于显示的数据源
 *	@param 	defaultIndex 	默认的选中项（暂时无效）
 */
-(void)createPickerView:(NSString *)title
             dataSource:(NSDictionary *)dataSource
           defaultIndex:(NSUInteger)defaultIndex;

/**
 *	@brief	为选择器提供设置回调功能。当选择器完成必要的动作后，执行这里设置的功能。
 *
 *	@param 	target 	执行功能的目标
 *	@param 	selector 	功能名
 *	@param 	userinfo 	自定义数据，用户回传。不会做任何改变
 *	@param 	event 	指定触发的动作
 */
-(void)addTarget:(id)target
        selector:(SEL)selector
        userinfo:(NSDictionary *)userinfo
        forEvent:(enum PickerViewUitlEvent)event;

/**
 *	@brief	显示PickerView
 */
-(void)showPickerView:(UIView *)superView;

/**
 *	@brief	销毁pickerview
 */
-(void)destroyPickerView;

@end
