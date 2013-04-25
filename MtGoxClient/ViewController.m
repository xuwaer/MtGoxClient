//
//  ViewController.m
//  MtGoxClient
//
//  Created by Xukj on 4/25/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "ViewController.h"
#import "MtGoxInformationQueue.h"
#import "TransManager.h"

#import "MtGoxTickerRequest.h"
#import "MtGoxTickerResponse.h"

@interface ViewController ()

@end

@implementation ViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MtGoxTickerRequest *mtGoxRequest = [[MtGoxTickerRequest alloc] initWithCurrency:USD];
    [mtGoxQueue sendRequest:mtGoxRequest target:self selector:@selector(updateUI:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self destoryHttpQueue];
}

#pragma mark - init Config

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

#pragma mark - receive information

-(void)updateUI:(id)responseFromQueue
{
    if ([responseFromQueue isKindOfClass:[MtGoxTickerResponse class]]) {
        
        MtGoxTickerResponse *response = (MtGoxTickerResponse *)responseFromQueue;
        NSArray *data = response.data;
        
        for (int i = 0; i < [data count]; i++) {
            
            MtGoxTickerDetailResponse *detail = [data objectAtIndex:i];
            DDLogCVerbose(@"%@", detail.key);
            if ([detail.value isKindOfClass:[MtGoxTickerValueResponse class]]) {
                MtGoxTickerValueResponse *value = (MtGoxTickerValueResponse *)(detail.value);
                
                DDLogCVerbose(@"%@,%@,%@,%@,%@", value.value, value.value_int, value.display, value.display_short, value.currency);
            }
            else {
                DDLogCVerbose(@"%@", detail.value);
            }
            
        }
    }
}

@end
