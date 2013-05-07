//
//  BaseRequest.m
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "BaseRequest.h"
#import <objc/runtime.h>

@implementation BaseRequest

@synthesize requestCommand = _requestCommand;
@synthesize requestType = _requestType;
@synthesize filePath;
@synthesize fileData;
@synthesize fileKey;

-(id)initWithCommand:(NSString *)command type:(enum HttpRequestType)type
{
    self = [super init];
    
    if (self) {
        self.requestCommand = command;
        self.requestType = type;
    }
    
    return self;
}

#pragma mark - Get request method

-(NSString *)generatorRequestUrl
{
    if (self.requestCommand == nil)
        return nil;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?", self.requestCommand];
    
    unsigned int propertyCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        
        NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        if ([key isEqualToString:@"tag"])
            continue;
        if ([key isEqualToString:@"requestType"])
            continue;
        if ([key isEqualToString:@"requestCommand"])
            continue;
        if ([key isEqualToString:@"filePath"])
            continue;
        if ([key isEqualToString:@"fileData"])
            continue;
        if ([key isEqualToString:@"fileKey"])
            continue;
        
        id value = [self valueForKey:key];
        
        if (value == nil)
            continue;
        
        if ([value isKindOfClass:[NSString class]]) 
            requestUrl = [requestUrl stringByAppendingFormat:@"%@=%@&", key, value];
        else if ([value isKindOfClass:[NSNumber class]])
            requestUrl = [requestUrl stringByAppendingFormat:@"%@=%@&", key, [value stringValue]];
        else
            requestUrl = [requestUrl stringByAppendingFormat:@"%@=%@&", key, [self requestUrlWithNonObjcType:value]];

    }
    
    NSString *lastWord = [requestUrl substringFromIndex:([requestUrl length] - 1)];
    if ([lastWord isEqualToString:@"?"] || [lastWord isEqualToString:@"&"]) {
        requestUrl = [requestUrl substringToIndex:([requestUrl length] - 1)];
    }
    
    free(properties);
    
    return requestUrl;
}

-(NSString *)requestUrlWithNonObjcType:(id)value
{
    const char *type = [value objCType];
    
    if (strcmp(type, @encode(char))) {
        return [NSString stringWithFormat:@"%c", [value charValue]];
    }
    else if (strcmp(type, @encode(int))) {
        return [NSString stringWithFormat:@"%d", [value intValue]];
    }
    else if (strcmp(type, @encode(int32_t))) {
        return [NSString stringWithFormat:@"%ld", [value longValue]];
    }
    else if (strcmp(type, @encode(int64_t))) {
        return [NSString stringWithFormat:@"%lld", [value longLongValue]];
    }
    else if (strcmp([value objCType], @encode(float))) {
        return [NSString stringWithFormat:@"%.f", [value floatValue]];
    }
    else if (strcmp(type, @encode(double))) {
        return [NSString stringWithFormat:@"%.f", [value doubleValue]];
    }
    else {
        return @"";
    }
}

#pragma mark - Post request method

-(NSDictionary *)generatorRequestParams
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    unsigned int propertyCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        
        NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        if ([key isEqualToString:@"tag"])
            continue;
        if ([key isEqualToString:@"requestType"])
            continue;
        if ([key isEqualToString:@"requestCommand"])
            continue;
        
        
        id value = [self valueForKey:key];
        
        if (value == nil)
            continue;
        
        if ([value isKindOfClass:[BaseRequest class]])
            [params setValue:[value encode] forKey:key];
        else
            [params setValue:value forKey:key];
        
    }
    
    free(properties);
    
    return params;
}

-(id)requestParamsWithNonObjcType:(id)value
{
    const char *type = [value objCType];
    
    if (strcmp(type, @encode(char))) {
        return [NSString stringWithFormat:@"%c", [value charValue]];
    }
    else if (strcmp(type, @encode(int))) {
        return [NSNumber numberWithInt:[value intValue]];
    }
    else if (strcmp(type, @encode(int32_t))) {
        return [NSNumber numberWithLong:[value longValue]];
    }
    else if (strcmp(type, @encode(int64_t))) {
        return [NSNumber numberWithLongLong:[value longLongValue]];
    }
    else if (strcmp([value objCType], @encode(float))) {
        return [NSNumber numberWithFloat:[value floatValue]];
    }
    else if (strcmp(type, @encode(double))) {
        return [NSNumber numberWithDouble:[value doubleValue]];
    }
    else {
        return @"";
    }
}

-(id)encode
{
    id result;
    
    switch (self.requestType) {
        case HttpRequestTypeGet:
            result = [self generatorRequestUrl];
            break;
        case HttpRequestTypePost:
        case HttpRequestTypePostWithFile:
        case HttpRequestTypePostWithData:
            result = [self generatorRequestParams];
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}

-(NSUInteger)tag
{
    return -1;
}

@end
