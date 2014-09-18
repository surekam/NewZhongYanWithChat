//
//  SKIMMessageDBModel.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-14.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMMessageDBModel.h"
#import "FileManager.h"
#import "SKIMDBTables.h"
#import "XHMessage.h"
#import "SKIMUser.h"

@implementation SKIMMessageDBModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        dbFilePath=[FileManager getFileDBPath:IMDataBaseFileName];
        db = [FMDatabase databaseWithPath:dbFilePath];
        tableName = IM_MESSAGE;
        _limit = 0;
        
    }
    return self;
}

+ (NSArray *)getMessagesFromModelArray:(NSArray *)modelArray
{
    if (modelArray == nil || modelArray.count == 0) {
        return nil;
    }
    NSMutableArray *msgArray = [NSMutableArray array];
    for (NSDictionary *dic in modelArray) {
        XHMessage *msg = [[XHMessage alloc] init];
        msg.rid = [dic objectForKey:@"RID"];
        msg.msgId = [dic objectForKey:@"MSGID"];
        msg.sender = [dic objectForKey:@"SENDERID"];
        msg.receiver = [dic objectForKey:@"RECEIVERID"];
        msg.isGroup = [[dic objectForKey:@"ISGROUP"] boolValue];
        msg.groupId = [dic objectForKey:@"GROUPID"];
        msg.isRead = [[dic objectForKey:@"ISREAD"] boolValue];
        msg.isAcked = [[dic objectForKey:@"ISACKED"] boolValue];
        msg.deliveryState = [dic objectForKey:@"DELIVERYSTATE"];
        msg.messageMediaType = (XHBubbleMessageMediaType)[[dic objectForKey:@"MSGTYPE"] integerValue];
        msg.bubbleMessageType = (XHBubbleMessageType)[[dic objectForKey:@"MSGSENDTYPE"] integerValue];
        msg.text = [dic objectForKey:@"MSGBODY"];
        msg.timestamp = [DateUtils stringToDate:[dic objectForKey:@"SENDTIME"] DateFormat:displayDateTimeFormat];
        msg.avatorUrl = [SKIMUser getUserFromUid:[dic objectForKey:@"SENDERID"]].avatarUri;
        msg.avator = [UIImage imageNamed:@"avator"];
        
        [msgArray addObject:msg];
    }
    return msgArray;
}

@end
