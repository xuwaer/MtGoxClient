//
//  ModelUtil.m
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "ModelUtil.h"
#import <objc/runtime.h>

@implementation ModelUtil

+(id)convertObjectToJSON:(id)object
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    NSString *xml=@"{";
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key=[[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id value=[object valueForKey:key];
        
        if (value!=nil) {
            //IF NOT NSSTRING,LOOP!!!!!!
            if (![value isKindOfClass:[NSString class]]) {
                xml=[xml stringByAppendingFormat:@"%@:%@,",key,[ModelUtil convertObjectToJSON:[object valueForKey:key]]];
            }
            else
            {
                xml=[xml stringByAppendingFormat:@"%@:'%@',",key,value];
            }
        }
        else
        {
            xml=[xml stringByAppendingFormat:@"%@:'%@',",key,@""];
        }
    }
    xml=[xml substringToIndex:xml.length-1];
    xml=[xml stringByAppendingString:@"}"];
    
    //NSLog(@"结果：%@",xml);
    
    free(properties);
    
    return xml;
}

+(id)convertObjectToXML:(id)object
{

}

@end
