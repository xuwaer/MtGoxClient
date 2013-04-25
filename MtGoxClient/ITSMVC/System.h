//
//  System.h
//  tfsp_rc
//
//  Created by TFSP  on 13-4-9.
//
//

#define IS_OFFICIAL_IP 1
#define kTestRequest @"www.hr028.com.cn"
#if IS_OFFICIAL_IP
//#define kHttpRequest @"http://118.112.188.16:7373/"
//#define kHttpRequest @"http://118.112.188.16:8383/"
#define kHttpRequest @"http://www.hr028.com.cn/"
#else
#define kHttpRequest @"http://10.15.3.129/"
#endif

