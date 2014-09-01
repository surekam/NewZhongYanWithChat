//
//  SKIMSocketConfig.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-28.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#ifndef NewZhongYan_SKIMSocketConfig_h
#define NewZhongYan_SKIMSocketConfig_h

// iM 服务器地址
#define SOCKETIP    @"10.159.30.220"
//#define SOCKETIP    @"127.0.0.1"
//#define SOCKETIP    @"192.168.1.198"

// iM 服务器端口
#define SOCKETPORT  8100

/******************************** 消息包头 **********************************/
//消息包头长度
#define HeadLen 16

//识别码
#define ZYIM            @"ZYIM"

//消息长度
#define MSGLEN          @"MSGLEN"

//加密标识
#define ENCRYPT         @"ENCRYPT"

//预留字段
#define RESERVED        @"RESERVED"


//加密标识 默认值
#define EncryptFlag @"0000"

//预留字段 默认值
#define ReservedField @"0000"
/******************************** 消息包头 **********************************/


//登录
#define TCP_LOGIN_COMMAND_ID                300

#endif
