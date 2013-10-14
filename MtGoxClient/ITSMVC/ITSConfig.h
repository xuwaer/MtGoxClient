//
//  TranslateConfig.h
//  tfsp_rc
//
//  Created by Xukj on 3/25/13.
//
//

#import "ITSRequest.h"
#import "ITSResponse.h"

#ifndef tfsp_rc_TranslateConfig_h
#define tfsp_rc_TranslateConfig_h

//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - request type

//////////////////////////////////////////////////////////////////////////////////////////////////

// 只能选择其中一个，其他的请注释掉

//#ifndef request_datatype_json
//#define request_datatype_json
//#endif 
//
//#ifndef request_datatype_xml
//#define request_datatype_xml
//#endif
//
//#ifndef request_datatype_data
//#define request_datatype_data
//#endif

#ifndef request_datatype_url
#define request_datatype_url
#endif

//#ifndef request_datatype_other
//#define request_datatype_other
//#endif

//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - response type

//////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *  只能选择一个，其他的请注释掉
 */

#ifndef response_datatype_json
#define response_datatype_json
#endif

//#ifndef response_datatype_xml
//#define response_datatype_xml
//#endif
//
//#ifndef response_datatype_data
//#define response_datatype_data
//#endif
//
//#ifndef response_datatype_other
//#define response_datatype_other
//#endif

//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - response type

//////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *  只能选择一个，其他的请注释掉
 */

//#ifndef connectiontype_socket
//#define connectiontype_socket
//#endif

#ifndef connectiontype_http
#define connectiontype_http
#endif

//#ifndef connectiontype_other
//#define connectiontype_other
//#endif

//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 实体类标志符

//////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef kActionTag
#define kActionTag_Request_USD      1000            //美元行情
#define kActionTag_Request_JPY      1001            //日元行情
#define kActionTag_Request_EUR      1002            //欧元行情
#define kActionTag_Request_CNY      1003            //人民币行情
#define kActionTag_Request_Set_Remind 1004          //添加价格提醒
#define kActionTag_Request_Update_Remind 1005       //更新价格提醒
#define kActionTag_Request_Delete_Remind 1006       //删除价格提醒
#define kActionTag_Request_Sync_Remind 1007         //同步价格提醒

#define kActionTag_Response_USD     kActionTag_Request_USD
#define kActionTag_Response_JPY     kActionTag_Request_JPY
#define kActionTag_Response_EUR     kActionTag_Request_EUR
#define kActionTag_Response_CNY     kActionTag_Request_CNY
#define kActionTag_Response_Set_Remind kActionTag_Request_Set_Remind
#define kActionTag_Response_Update_Remind kActionTag_Request_Update_Remind
#define kActionTag_Response_Delete_Remind kActionTag_Request_Delete_Remind
#define kActionTag_Response_Sync_Remind kActionTag_Request_Sync_Remind

#endif

// 服务器连接方式
#ifdef connectiontype_socket

#elif defined (connectiontype_http)
#import "ITSHttpStream.h"
#import "ITSHttpQueueModule.h"
#elif defined (connectiontype_other)

#endif

#define HTTP_REQUEST_TIMEOUT 10

#endif
