//
//  SettingViewController.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "SettingViewController.h"
#import "UserDefault.h"
#import "Remind.h"
#import "RemindCell.h"
#import "RemindAddCell.h"
#import "RemindSettingController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UserDefault *userDefault = [UserDefault defaultUser];
        [userDefault getUserDefault];
        mtGoxReminds = userDefault.mtGoxRemind;
        btcChinaReminds = userDefault.btcChinaRemind;
        btcEReminds = userDefault.btcERemind;
    }
    return self;
}

-(void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table view data source

//////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = @"";
    
    switch (section) {
        case 0:
            headerTitle = @"MtGox";
            break;
        case 1:
            headerTitle = @"BTCChina";
            break;
        case 2:
            headerTitle = @"BTC-E";
            break;
        default:
            headerTitle = @"MtGox";
            break;
    }
    
    return headerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case 0:
            if (mtGoxReminds == nil) {
                rows = 1;
            }
            else {
                int count =  [mtGoxReminds count];
                rows = count < ThresholdCount ? count + 1 : count;
            }
            break;
        case 1:
            if (btcChinaReminds == nil) {
                rows = 1;
            }
            else {
                int count =  [btcChinaReminds count];
                rows = count < ThresholdCount ? count + 1 : count;
            }
        case 2:
            if (btcEReminds == nil) {
                rows = 1;
            }
            else {
                int count =  [btcEReminds count];
                rows = count < ThresholdCount ? count + 1 : count;
            }
            break;
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self setupCell:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[RemindCell class]]) {
        return YES;
    }
    else {
        return NO;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 从数据源中删除
        [self deleteRemindInDataSource:indexPath];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table view delegate

//////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    RemindSettingController *remindSettingController = [[RemindSettingController alloc] init];
    remindSettingController.title = @"设置";
    remindSettingController.delegate = self;
    if ([cell isKindOfClass:[RemindAddCell class]]) {
        [remindSettingController setRemind:nil];
    }
    else {
        [remindSettingController setRemind:[(RemindCell *)cell remind]];
    }
    
    [self presentModalViewController:remindSettingController animated:YES];
}

-(UITableViewCell *)setupCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
                
        if (mtGoxReminds == nil || indexPath.row >= [mtGoxReminds count])
            cell = [self updateCell:tableView remind:nil];
        else
            cell = [self updateCell:tableView remind:[mtGoxReminds objectAtIndex:indexPath.row]];
    }
    
    else if (indexPath.section == 1) {
        
        if (btcChinaReminds == nil || indexPath.row >= [btcChinaReminds count])
            cell = [self updateCell:tableView remind:nil];
        else
            cell = [self updateCell:tableView remind:[btcChinaReminds objectAtIndex:indexPath.row]];
    }

    else if (indexPath.section == 2) {
        
        if (btcEReminds == nil || indexPath.row >= [btcEReminds count])
            cell = [self updateCell:tableView remind:nil];
        else
            cell = [self updateCell:tableView remind:[btcEReminds objectAtIndex:indexPath.row]];
    }

    else {
        cell = [self updateCell:tableView remind:nil];
    }
    
    return cell;
}

-(UITableViewCell *)updateCell:(UITableView *)tableView remind:(Remind *)remind
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if (remind != nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindCell" owner:self options:nil] lastObject];
            [(RemindCell *)cell setupRemindShow:remind];            
        }
        else {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindAddCell" owner:self options:nil] lastObject];
        }
    }
    
    // 去掉tableview group的背景样式
    UIView *backView  = [[UIView alloc] init];
    [cell setBackgroundView:backView];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - RemindSettingController delegate

//////////////////////////////////////////////////////////////////////////////////////////

-(void)finishEditRemind:(Remind *)remind
{
    [self.tableView reloadData];
    
    [[UserDefault defaultUser] saveUserDefault];
}

-(void)finishAddRemind:(Remind *)remind
{
    switch (remind.platform) {
        case PlatformMtGox:
            [mtGoxReminds addObject:remind];
            break;
        case PlatformBtcChina:
            [btcChinaReminds addObject:remind];
            break;
        case PlatformBtcE:
            [btcEReminds addObject:remind];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    [[UserDefault defaultUser] saveUserDefault];

//    [self insertTableViewCell:remind.platform];
}
//
//-(void)insertTableViewCell:(enum Platform)platform
//{
//    int section = 0;
//    int count = 0;
//    
//    switch (platform) {
//        case PlatformMtGox:
//            section = 0;
//            count = [mtGoxReminds count];
//            break;
//        case PlatformBtcChina:
//            section = 1;
//            count = [btcChinaReminds count];
//            break;
//        case PlatformBtcE:
//            section = 2;
//            count = [btcEReminds count];
//            break;
//        default:
//            count = -1;
//            break;
//    }
//    
//    if (count >= 0 && count < ThresholdCount - 1) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    }
//}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - other

//////////////////////////////////////////////////////////////////////////////////////////

/**
 *	@brief	根据indexPath，删除数据源中的提醒
 *
 *	@param 	indexPath 	需要删除的位置
 */
-(void)deleteRemindInDataSource:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [mtGoxReminds removeObjectAtIndex:indexPath.row];
            break;
        case 1:
            [btcChinaReminds removeObjectAtIndex:indexPath.row];
            break;
        case 2:
            [btcEReminds removeObjectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
}

@end
