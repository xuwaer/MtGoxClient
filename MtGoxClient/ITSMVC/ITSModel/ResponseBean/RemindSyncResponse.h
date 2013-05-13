//
//  RemindSyncResponse.h
//  MtGoxClient
//
//  Created by Xukj on 5/8/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "BaseResponse.h"

@interface RemindSyncResponse : BaseResponse<ITSResponseDelegate>

@property (nonatomic, strong)NSArray *reminds;

@end
