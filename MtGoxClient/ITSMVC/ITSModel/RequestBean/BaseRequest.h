//
//  BaseRequest.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import <Foundation/Foundation.h>
#import "ITSConfig.h"
#import "ITSRequestDelegate.h"

enum HttpRequestType {
    HttpRequestTypeGet = 0,             //默认使用get上传
    HttpRequestTypePost = 1,
    HttpRequestTypePostWithFile = 2,    //post上传文件
    HttpRequestTypePostWithData = 3     //post上传二进制bytes
    };

@interface BaseRequest : NSObject<ITSRequestDelegate>
{
    NSString *_requestCommand;
    enum _requestType;
}

/**
 *	@brief	请求命令
 */
@property (nonatomic, copy)NSString *requestCommand;

/**
 *	@brief	请求类型
 */
@property (nonatomic, assign)enum HttpRequestType requestType;

// 发送文件时使用以下数据
// 文件发送方式为表单提交
/**
 *	@brief	需要上传的文件路径。与fileData二选一
 */
@property (nonatomic, strong)NSString *filePath;

/**
 *	@brief	需要上传的文件data。与filePath二选一
 */
@property (nonatomic, strong)NSData *fileData;

/**
 *	@brief	表单提交文件的key
 */
@property (nonatomic, strong)NSString *fileKey;

/**
 *	@brief	初始化请求类
 *
 *	@param 	command 	请求命令
 *	@param 	type 	使用get还是post请求
 *
 *	@return	请求类
 */
-(id)initWithCommand:(NSString *)command type:(enum HttpRequestType)type;

@end
