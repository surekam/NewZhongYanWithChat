//
//  SKIMDBConfig.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-11.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMDBConfig.h"
#import "SKIMDBTables.h"

@implementation SKIMDBConfig

//所有数据表
+(NSDictionary *)getDBTablesDic
{
    // IM_CONVERSATION 表
    NSString *im_conversation = IM_CONVERSATION;
    NSString *im_conversation_sql = @"create table IM_CONVERSATION(                 \
                                    RID             INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,   \
                                    CHATTERID       TEXT,                           \
                                    ISGROUP         INTEGER,                        \
                                    ISRECEIVEMSG    INTEGER,                        \
                                    ISENABLE        INTEGER                         \
                                    )";
    
    // IM_MESSAGE 表
    // DELIVERYSTATE
    NSString *im_message = IM_MESSAGE;
    NSString *im_message_sql = @"create table IM_MESSAGE(                           \
                                RID                 INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,   \
                                MSGID               TEXT,                           \
                                CONVERSATIONID      INTEGER,                        \
                                SENDERID            TEXT,                           \
                                RECEIVERID          TEXT,                           \
                                ISGROUP             INTEGER,                        \
                                GROUPID             TEXT,                           \
                                ISREAD              INTEGER,                        \
                                ISACKED             INTEGER,                        \
                                DELIVERYSTATE       INTEGER,                        \
                                MSGTYPE             INTEGER,                        \
                                MSGSENDTYPE         INTEGER,                        \
                                MSGBODY             TEXT,                           \
                                SENDTIME            DATETIME                        \
                                )";
    
    // IM_USER 表
    NSString *im_user = IM_USER;
    NSString *im_user_sql = @"create table IM_USER(                                 \
                            UID             TEXT PRIMARY KEY NOT NULL,              \
                            SIGNATURE       TEXT,                                   \
                            AVATAR          TEXT                                    \
                            )";

    // IM_GROUP 表
    NSString *im_group = IM_GROUP;
    NSString *im_group_sql = @"create table IM_GROUP(                               \
                                RID             INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,       \
                                GROUPID         TEXT,                               \
                                GROUPTYPE       INTEGER,                            \
                                GROUPNAME       TEXT,                               \
                                AVATAR          TEXT,                               \
                                ANNONCEMENT     TEXT,                               \
                                CREATOR         TEXT,                               \
                                CREATTIME       INTEGER,                            \
                                ISENABLE        INTEGER                             \
                                )";
    
    NSDictionary *tableDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              im_conversation_sql, im_conversation,
                              im_message_sql, im_message,
                              im_user_sql, im_user,
                              im_group_sql, im_group,
                              nil];
    return tableDic;
}
@end