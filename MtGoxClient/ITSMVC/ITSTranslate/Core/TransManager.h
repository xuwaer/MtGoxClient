//
//  TransManager.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//
//  所有的于通信有关的连接控制，均在此类中进行管理
//
//
//
//

#import <Foundation/Foundation.h>
#import "ITSQueueModule.h"
#import "ITSStream.h"


@interface TransManager : NSObject
{
    ITSStream *_stream;
    
    NSMutableArray *controllers;
}

@property (nonatomic, strong, readonly) ITSStream *stream;
@property (nonatomic, copy) NSString *hostname;
@property (nonatomic, copy) NSString *port;

+(id)defaultManager;

-(BOOL)add:(ITSQueueModule *)queueModule;

-(void)remove:(ITSQueueModule *)queueModule;

@end
