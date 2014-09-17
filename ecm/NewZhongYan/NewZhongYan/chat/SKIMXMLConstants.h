//
//  SKIMXMLConstants.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#ifndef NewZhongYan_SKIMXMLConstants_h
#define NewZhongYan_SKIMXMLConstants_h

#define     XML_ENCODING                                    @"GB18030"

#define     IM_XML_ROOT_NODE_NAME                           @"R"

#define     IM_XML_HEAD_NODE_NAME                           @"H"

#define     IM_XML_BODY_NODE_NAME                           @"B"

#define     IM_XML_BASE_NODE_NAME                           @"F"

#define     IM_XML_PARAM_SINGLE_NODE_NAME                   @"S"

#define     IM_XML_PARAM_MULTI_NODE_NAME                    @"M"

#define     IM_XML_PARAM_MULIT_LINE_NODE_NAME               @"L"

#define     IM_XML_BASE_ATTR_NAME                           @"n"


#define     IM_XML_HEAD_SOURCE_ATTR                         @"SOURCE"

#define     IM_XML_HEAD_BUSINESS_ATTR                       @"BUSINESS"

#define     IM_XML_HEAD_SESSIONID_ATTR                      @"SESSIONID"

#define     IM_XML_HEAD_USERID_ATTR                         @"USERID"

#define     IM_XML_HEAD_INDEX_ATTR                          @"INDEX"


#define     IM_XML_HEAD_SOURCE_MOBILE_VALUE                 @"MOBILE"

#define     IM_XML_HEAD_SOURCE_SERVER_VALUE                 @"SERVER"


#define     IM_XML_BODY_VERSION_ATTR                        @"VERSION"

#define     IM_XML_BODY_VERSION_VALUE                       @"1.0"


//MLogin
#define     IM_XML_HEAD_BUSINESS_LOGIN_VALUE                @"MLogin"

#define     IM_XML_BODY_LOGIN_USERID_ATTR                   @"USERID"

#define     IM_XML_BODY_LOGIN_USERPSW_ATTR                  @"USERPSW"

//MSendMsg
#define     IM_XML_HEAD_BUSINESS_SENDMSG_VALUE              @"MSendMsg"

#define     IM_XML_BODY_SENDMSG_TOUSER_ATTR                 @"TOUSER"

#define     IM_XML_BODY_SENDMSG_MSGTYPE_ATTR                @"MSGTYPE"

#define     IM_XML_BODY_SENDMSG_CONTENT_ATTR                @"CONTENT"


#define     IM_XML_HEAD_BUSINESS_SENDGMSG_VALUE             @"MSendGMsg"

#define     IM_XML_BODY_SENDGMSG_TOCLUB_ATTR                @"TOCLUE"

#define     IM_XML_BODY_SENDGMSG_CONTENT_ATTR               @"CONTENT"



#define     IM_XML_BODY_RESULTCODE_ATTR                     @"RESULTCODE"

#define     IM_XML_BODY_SESSIONID_ATTR                      @"SESSIONID"

/******************************** 返回业务码 **********************************/
//登录业务码
#define     BUSINESS_SERVER_MLOGINRET                       @"MLoginRet"

//用户在他处重新登录
#define     BUSINESS_SERVER_RELOGIN                         @"ReLogin"

//服务端发送消息
#define     BUSINESS_SERVER_SENDMSG                         @"SendMsg"

#define     LOGIN_SUCCESS                                   @"0"

/******************************** 返回业务码 **********************************/

#endif
