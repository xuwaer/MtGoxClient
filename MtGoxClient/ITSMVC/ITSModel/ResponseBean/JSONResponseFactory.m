//
//  JSONResponseFactory.m
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "JSONResponseFactory.h"
#import "ITSConfig.h"

#import "MtGoxTickerResponse.h"
#import "RemindSetResponse.h"
#import "RemindUpdateResponse.h"
#import "RemindDelResponse.h"

@implementation JSONResponseFactory

-(id<ITSResponseDelegate>)decode:(NSData *)source tag:(id)tag
{
    id<ITSResponseDelegate> response = [self decodeDataToResponse:source tag:tag];
    
    if (response) {
        [response decode];
    }
    
    return response;
}

-(id<ITSResponseDelegate>)decodeDataToResponse:(NSData *)source tag:(id)tag
{
    id<ITSResponseDelegate> response = nil;
    
    NSUInteger responseTag = [(NSNumber *)tag unsignedIntegerValue];
    switch (responseTag) {
        case kActionTag_Response_USD:
        case kActionTag_Response_EUR:
        case kActionTag_Response_JPY:
        case kActionTag_Response_CNY:
            response = [[MtGoxTickerResponse alloc] initWithJSONData:source tag:responseTag];
            break;
        case kActionTag_Response_Set_Remind:
            response = [[RemindSetResponse alloc] initWithJSONData:source];
            break;
        case kActionTag_Response_Update_Remind:
            response = [[RemindUpdateResponse alloc] initWithJSONData:source];
            break;
        case kActionTag_Response_Delete_Remind:
            response = [[RemindDelResponse alloc] initWithJSONData:source];
            break;
        default:
            break;
    }
    
    return response;
}

@end
