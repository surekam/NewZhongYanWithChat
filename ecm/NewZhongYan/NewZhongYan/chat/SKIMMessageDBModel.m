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
        msg.timestamp = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"SENDTIME"] doubleValue]/1000];
        msg.isGroup = [[dic objectForKey:@"ISGROUP"] intValue];
        
        
        if ([[SKIMUser currentUser].uid isEqualToString:[dic objectForKey:@"SENDERID"]]) {
            msg.bubbleMessageType = XHBubbleMessageTypeSending;
            msg.avatorUrl = [SKIMUser getUserFromUid:[dic objectForKey:@"SENDERID"]].avatarUri;
        } else if (msg.isGroup) {
            msg.bubbleMessageType = XHBubbleMessageTypeReceiving;
            msg.avatorUrl = [SKIMUser getUserFromUid:[dic objectForKey:@"GROUPSENDERID"]].avatarUri;
        } else {
            msg.bubbleMessageType = XHBubbleMessageTypeReceiving;
            msg.avatorUrl = [SKIMUser getUserFromUid:[dic objectForKey:@"RECEIVERID"]].avatarUri;
        }
        msg.avator = [UIImage imageNamed:@"avator"];
        msg.messageMediaType = XHBubbleMessageMediaTypeText;
        msg.text = [dic objectForKey:@"MSGBODY"];
        
        
        //TODO: 完善消息实体赋值
        [msgArray addObject:msg];
    }
    return msgArray;
}

@end
