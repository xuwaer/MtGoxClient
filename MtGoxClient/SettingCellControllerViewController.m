//
//  SettingCellControllerViewController.m
//  MtGoxClient
//
//  Created by Xukj on 5/2/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "SettingCellControllerViewController.h"
#import "Constant.h"
#import "Remind.h"
#import "UserDefault.h"

#import "RemindCell.h"
#import "RemindAddCell.h"

#import "RemindSettingController.h"
#import "SettingAlertControllerViewController.h"

@interface SettingCellControllerViewController ()

// 对数据源进行处理，用作展示和以后的操作
-(void)initData;
// 界面初始化
-(void)setupUI;

// 删除数据源中的对应，并保存
-(void)removeDataAtIndex:(NSUInteger)index;
// 数据源中添加数据，并保存
-(void)addData:(Remind *)remind;
// 修改数据源中的数据，并保存
-(void)editData:(Remind *)remind atIndex:(NSUInteger)index;

// 表格cell与数据源对应数据绑定
-(UITableViewCell *)updateCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withRemind:(Remind *)remind;

@end

@implementation SettingCellControllerViewController

@synthesize alertTableView;
@synthesize dataArray;
@synthesize alterDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initData
{
    dataSource = [[NSMutableArray alloc] init];
    // 生成默认cell的数据源
    for (int i = 0; i < ThresholdCount; i++) {
        [dataSource addObject:[NSNull null]];
    }
    
    // 替换默认cell的数据源
    if (dataArray != nil && [dataArray count] > 0) {
        for (int i = 0; i < [dataArray count]; i++) {
            id value = [dataArray objectAtIndex:i];
            
            if (i < [dataSource count])
                [dataSource replaceObjectAtIndex:i withObject:value];
        }
    }
}

-(void)setupUI
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_section.png"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table view data source

//////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setupCell:tableView cellForRowAtIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id value = [dataSource objectAtIndex:indexPath.row];
    
    return [value isEqual:[NSNull null]] ? NO : YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeDataAtIndex:indexPath.row];
    [tableView reloadData];
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table view delegate

//////////////////////////////////////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    RemindSettingController *remindSettingController = [[RemindSettingController alloc] init];
    remindSettingController.title = @"设置";
    remindSettingController.delegate = self;
    if ([cell isKindOfClass:[RemindAddCell class]]) {
        [remindSettingController setRemind:nil];
    }
    else {
        [remindSettingController setRemind:[(RemindCell *)cell remind]];
    }
    
    [alterDelegate presentModalViewController:remindSettingController animated:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table view UI

//////////////////////////////////////////////////////////////////////////////////////////

-(UITableViewCell *)setupCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    id value = [dataSource objectAtIndex:indexPath.row];
    cell = [self updateCell:tableView atIndexPath:indexPath withRemind:value];
    
    return cell;
}

/**
 *	@brief	数据源与cell绑定
 *
 *	@param 	tableView
 *	@param 	indexPath
 *	@param 	remind 	与该cell绑定的数据源
 *
 *	@return	绑定后的cell
 */
-(UITableViewCell *)updateCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withRemind:(Remind *)remind
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if (remind != nil && ![remind isEqual:[NSNull null]]) {
            // 显示对象与行列绑定
            remind.tag = indexPath.row;
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindCell" owner:self options:nil] lastObject];
            [(RemindCell *)cell setupRemindShow:remind];
        }
        else {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindAddCell" owner:self options:nil] lastObject];
        }
    }
    
    // 去掉tableview group的背景样式
    UIImageView *backView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 281, 39)];
    [backView setImage:[UIImage imageNamed:@"bg_cell.png"]];
    [cell setBackgroundView:backView];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Data souce operation

//////////////////////////////////////////////////////////////////////////////////////////

-(void)removeDataAtIndex:(NSUInteger)index
{
    [dataArray removeObjectAtIndex:index];
    [[UserDefault defaultUser] saveUserDefault];
    [self initData];
}

-(void)addData:(Remind *)remind
{
    for (int i = 0; i < [dataSource count]; i++) {
        id value = [dataSource objectAtIndex:i];
        if ([value isEqual:[NSNull null]]) {
            [dataSource replaceObjectAtIndex:i withObject:remind];
            break;
        }
    }
    
    [dataArray addObject:remind];
    [[UserDefault defaultUser] saveUserDefault];
}

-(void)editData:(Remind *)remind atIndex:(NSUInteger)index
{
    [dataSource replaceObjectAtIndex:index withObject:remind];
    [dataArray replaceObjectAtIndex:index withObject:remind];
    [[UserDefault defaultUser] saveUserDefault];
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - RemindSetting delegate

//////////////////////////////////////////////////////////////////////////////////////////

/**
 *	@brief	当阀值设置界面完成添加后，调用
 *
 *	@param 	remind 	添加后需要保存的数据
 */
-(void)finishAddRemind:(Remind *)remind
{
    [self addData:remind];
    [self.alertTableView reloadData];
}

/**
 *	@brief	当阀值设置界面完成修改后，调用
 *
 *	@param 	remind 	修改后需要保存的数据
 */
-(void)finishEditRemind:(Remind *)remind
{
    [self editData:remind atIndex:remind.tag];
    [self.alertTableView reloadData];
}

@end
