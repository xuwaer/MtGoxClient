//
//  RemindUpdateRequest.h
//  MtGoxClient
//
//  Created by Xukj on 5/6/13.
//  Copyright (c) 2013 tosc-its. All rights reserved.
//

#import "BaseRequest.h"

@interface RemindUpdateRequest : BaseRequest

@property (nonatomic, assign)int mid;
@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *plat;
@property (nonatomic, copy)NSString *cur;
@property (nonatomic, assign)float check;
@property (nonatomic, assign)BOOL islarge;

@end
