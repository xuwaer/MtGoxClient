//
//  MainViewController.m
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "MainViewController.h"
#import "MtGoxInformationQueue.h"
#import "MtGoxTickerRequest.h"
#import "MtGoxTickerResponse.h"

#import "TickerCell.h"

#import "SettingViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(id)init
{
    self = [super init];
    if (self) {
        [self setupHttpQueue];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupHttpQueue];
    }
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupHttpQueue];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setupHttpQueue];
    }
    return self;
}

-(void)dealloc
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [self destoryHttpQueue];
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Request & Receive message from server

//////////////////////////////////////////////////////////////////////////////////////////

-(void)setupHttpQueue
{
    mtGoxQueue = [[MtGoxInformationQueue alloc] init];
    [[TransManager defaultManager] add:mtGoxQueue];
}

-(void)destoryHttpQueue
{
    [[TransManager defaultManager] remove:mtGoxQueue];
    mtGoxQueue = nil;
    
}

-(void)updateUIDisplay:(id)responseFromQueue
{
    if ([responseFromQueue isKindOfClass:[MtGoxTickerResponse class]]) {
        
        MtGoxTickerResponse *response = (MtGoxTickerResponse *)responseFromQueue;
        
        if (response.tag == kActionTag_Response_USD)
            mtGoxUSDResponse = response;
        else if (response.tag == kActionTag_Response_EUR)
            mtGoxEURResponse = response;
        else if (response.tag == kActionTag_Response_JPY)
            mtGoxJPYResponse = response;
        else if (response.tag == kActionTag_Response_CNY)
            mtGoxCNYResponse = response;
        
        [self.tableView reloadData];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - life cycle

//////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupUI];
    
    [self loadTicker];
    timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(loadTicker) userInfo:nil repeats:YES];
}

- (void)setupUI
{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"Setting@2x.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setFrame:CGRectMake(0.0, 0.0, 35.0, 35.0)];
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    settingButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = settingButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TickerCell *cell = (TickerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TickerCell" owner:self options:nil] lastObject];
    }

    // Configure the cell...

    switch (indexPath.row) {
        case 0:
            [cell display:mtGoxUSDResponse];
            break;
        case 1:
            [cell display:mtGoxEURResponse];
            break;
        case 2:
            [cell display:mtGoxJPYResponse];
            break;
        case 3:
            [cell display:mtGoxCNYResponse];
            break;
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



-(void)loadTicker
{
    // 请求美元兑换行情
    MtGoxTickerRequest *mtGoxUSDRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeUSD];
    [mtGoxQueue sendRequest:mtGoxUSDRequest target:self selector:@selector(updateUIDisplay:)];
    
    // 请求欧元兑换行情
    MtGoxTickerRequest *mtGoxEURRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeEUR];
    [mtGoxQueue sendRequest:mtGoxEURRequest target:self selector:@selector(updateUIDisplay:)];
    
    // 请求日元兑换行情
    MtGoxTickerRequest *mtGoxJPYRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeJPY];
    [mtGoxQueue sendRequest:mtGoxJPYRequest target:self selector:@selector(updateUIDisplay:)];
    
    // 请求人民币兑换行情
    MtGoxTickerRequest *mtGoxCNYRequest = [[MtGoxTickerRequest alloc] initWithCurrency:CurrencyTypeCNY];
    [mtGoxQueue sendRequest:mtGoxCNYRequest target:self selector:@selector(updateUIDisplay:)];
}

-(void)showSetting
{    
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.title = @"设置";
    [self.navigationController pushViewController:settingViewController animated:YES];
}

@end
