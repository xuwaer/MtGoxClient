//
//  MainViewController.h
//  MtGoxClient
//
//  Created by Xukj on 4/26/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MtGoxInformationQueue;
@class MtGoxTickerResponse;

@interface MainViewController : UITableViewController
{
    @private
    MtGoxInformationQueue *mtGoxQueue;
    
    MtGoxTickerResponse *mtGoxUSDResponse;
    MtGoxTickerResponse *mtGoxEURResponse;
    MtGoxTickerResponse *mtGoxJPYResponse;
    MtGoxTickerResponse *mtGoxCNYResponse;
    
    NSTimer *timer;
}

@end
