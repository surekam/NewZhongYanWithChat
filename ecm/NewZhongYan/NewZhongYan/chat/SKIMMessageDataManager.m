//
//  SKIMMessageDataManager.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-9-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMMessageDataManager.h"
#import "SKIMTcpRequestHelper.h"
#import "TcpSendPackage.h"
#import "SKIMSocketConfig.h"
#import "SKIMXMLConstants.h"
#import "RegExCategories.h"
#import "SKIMServiceDefs.h"
#import "SKIMMessageDBModel.h"
#import "SKIMConversation.h"
#import "SKIMStatus.h"

@implementation SKIMMessageDataManager

+ (SKIMMessageDataManager *)sharedMessageDataManager
{
    static SKIMMessageDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[SKIMMessageDataManager alloc] init];
        }
    });
    
    return sharedInstance;
}

- (void)messageHandlerQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)sendAndSaveMessage:(XHMessage *)message
{
    if (message) {
        NSData *msgData = nil;
        switch (message.messageMediaType) {
            case XHBubbleMessageMediaTypeText:
            case XHBubbleMessageMediaTypeMix: {
                NSString *text = [message.text copy];
                NSArray *emotionMatchs = [text matchesWithDetails:RX(EMOTION_NAME_REGX)];
                for (RxMatch *emotionMatch in emotionMatchs) {
                    NSUInteger index = [EMOTION_NAME indexOfObject:emotionMatch.value];
                    if (index != NSNotFound) {
                        text = [text stringByReplacingOccurrencesOfString:emotionMatch.value withString:EMOTION_ID[index]];
                    }
                }
                NSString *sendIndex = nil;
                msgData = [TcpSendPackage createMessagePackageWithMsg:text toUser:message.receiver msgType:@"" bySendIndex:&sendIndex];
                message.msgId = sendIndex;
                if ([SKIMStatus sharedStatus].isConnected) {
                    [[SKIMTcpRequestHelper shareTcpRequestHelper] sendMessagePackageCommandWithMessageData:msgData withTimeout:-1];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSendMessageFailed object:[NSDictionary dictionaryWithObject:sendIndex forKey:IM_XML_HEAD_INDEX_ATTR]];
                    message.msgId = SENDFAILED_MSGID;
                    message.deliveryState = MessageDeliveryState_Failure;
                }
                
                break;
            }
            default:
                break;
        }
        [self saveMessageToDB:message];
        [self performSelector:@selector(messageSendTimeOut:) withObject:message afterDelay:DEFAULT_TIMEOUT];
    }
}

//发送消息超时处理
- (void)messageSendTimeOut:(XHMessage *)message {
    if (message && message.deliveryState == MessageDeliveryState_Delivering) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSendMessageFailed object:[NSDictionary dictionaryWithObject:message.msgId forKey:IM_XML_HEAD_INDEX_ATTR]];
        
        if (message.rid && ![message.rid isEqualToString:@""]) {
            [self messageHandlerQueue:^{
                SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
                NSString *updateSql = [NSString stringWithFormat:@"UPDATE IM_MESSAGE SET ISACKED = 0, DELIVERYSTATE = 2, MSGID = '%@' WHERE RID = %@", SENDFAILED_MSGID, message.rid];
                [msgModel queryUpdateSql:updateSql];
            }];

        }
    }
}

//接收并更新发送个人消息后服务端返回的信息
- (void)receiveSendMessageRet:(NSDictionary *)messageRetDic {
    [self messageHandlerQueue:^{
        if (messageRetDic) {
            NSString *resultCode = [messageRetDic objectForKey:IM_XML_BODY_RESULTCODE_ATTR];
            NSString *index = [messageRetDic objectForKey:IM_XML_HEAD_INDEX_ATTR];
            NSString *rid = @"";
            NSString *querySql = [[@"SELECT RID FROM IM_MESSAGE WHERE ISACKED = 0 AND MSGSENDTYPE = 0 AND MSGID = '" stringByAppendingString:index] stringByAppendingString:@"'"];
            NSString *updateSql = nil;
            
            SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
            NSArray* result = [msgModel querSelectSql:querySql];
            if (result.count) {
                rid = [result[0] objectForKey:@"RID"];
                if ([resultCode isEqualToString:RETURN_CODE_SUCCESS]) {
                    NSString *msgId = [messageRetDic objectForKey:IM_XML_BODY_SENDMSG_MESSAGEID_ATTR];
                    NSString *sendDate = [messageRetDic objectForKey:IM_XML_BODY_SENDMSG_SENDDATE_ATTR];
                    updateSql = [NSString stringWithFormat:@"UPDATE IM_MESSAGE SET ISACKED = 1, DELIVERYSTATE = 1, MSGID = '%@', SENDTIME = '%@' WHERE RID = %@", msgId, sendDate, rid];
                } else {
                    updateSql = [NSString stringWithFormat:@"UPDATE IM_MESSAGE SET ISACKED = 1, DELIVERYSTATE = 2, MSGID = '%@' WHERE RID = %@", SENDFAILED_MSGID, rid];
                }
                [msgModel queryUpdateSql:updateSql];
            }
        }
    }];
}

//接收并保存服务端的个人消息
- (void)receiveAndSaveMessage:(NSDictionary *)messageDic
{
    if (messageDic) {
        NSString *emoticonRegexStr = EMOTION_REGX;
        NSString *pictureRegexStr = PICTURE_REGX;
        NSString *fontRegexStr = FONT_REGX;
        
        NSString *msgContent = [messageDic objectForKey:IM_XML_BODY_SENDGMSG_CONTENT_ATTR];
        msgContent = [msgContent replace:RX(fontRegexStr) with:@""];
        
        BOOL isEmoticonMatch = [RX(emoticonRegexStr) isMatch:msgContent];
        BOOL isPictureMatch = [RX(pictureRegexStr) isMatch:msgContent];
        NSString *textContent = [[msgContent replace:RX(emoticonRegexStr) with:@""] replace:RX(pictureRegexStr) with:@""];
        
        NSArray *emotionMatchs = [msgContent matchesWithDetails:RX(EMOTION_REGX)];
        for (RxMatch *emotionMatch in emotionMatchs) {
            NSUInteger index = [EMOTION_ID indexOfObject:emotionMatch.value];
            if (index != NSNotFound) {
                msgContent = [msgContent stringByReplacingOccurrencesOfString:emotionMatch.value withString:EMOTION_NAME[index]];
            }
        }
        
        XHMessage *message = [[XHMessage alloc] init];
        if ((isEmoticonMatch || isPictureMatch) && textContent.length) {
            message.messageMediaType = XHBubbleMessageMediaTypeMix;
            message.text = msgContent;
        } else if (isPictureMatch && !isEmoticonMatch && textContent.length == 0) {
            message.messageMediaType = XHBubbleMessageMediaTypePhoto;
            //TODO
        } else if (isEmoticonMatch && !isPictureMatch && textContent.length == 0) {
            message.messageMediaType = XHBubbleMessageMediaTypeMix;
            message.text = msgContent;
        } else if (!isPictureMatch && !isEmoticonMatch && textContent.length) {
            message.messageMediaType = XHBubbleMessageMediaTypeText;
            message.text = msgContent;
        } else {
            message.messageMediaType = XHBubbleMessageMediaTypeText;
            message.text = msgContent;
        }
        
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        message.isGroup = NO;
        message.msgId = [messageDic objectForKey:IM_XML_BODY_SENDMSG_MESSAGEID_ATTR];
        //message.timestamp = [messageDic objectForKey:IM_XML_BODY_SENDMSG_SENDDATE_ATTR];
        message.timestamp = [DateUtils stringToDate:[messageDic objectForKey:IM_XML_BODY_SENDMSG_SENDDATE_ATTR] DateFormat:displayDateTimeFormat];
        message.sender = [messageDic objectForKey:IM_XML_HEAD_USERID_ATTR];
        message.receiver = [APPUtils userUid];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiMessageReceived object:message];
        
        [self saveMessageToDB:message];
    }
}

- (void)getHistoryMessageFromServer:(NSInteger)msgNumber {
}

- (void)sendGetMessageCountData {
    [self messageHandlerQueue:^{
        NSData *getMsgCountData = [TcpSendPackage createGetMessageCountPackage];
        if (getMsgCountData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SKIMTcpRequestHelper shareTcpRequestHelper] sendGetMessageCountPackageCommandWithGetMessageCountData:getMsgCountData withTimeout:-1];
            });
        }
    }];
}

- (void)getUserInfoFromServer {
    
}

- (void)saveMessageToDB:(XHMessage *)message {
    [self messageHandlerQueue:^{
        if (message) {
            //获取会话
            NSString *chatterId = message.bubbleMessageType ? message.sender : message.receiver;
            SKIMConversation *conversation = [SKIMConversation getConversationWithChatterId:chatterId isGroup:message.isGroup];
            
            SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            NSNumber *msgType = [NSNumber numberWithInteger:message.messageMediaType];
            NSNumber *msgSendType = [NSNumber numberWithInteger:message.bubbleMessageType];
            NSNumber *isAcked = msgSendType;
            NSNumber *deliveryState = msgSendType.intValue ? [NSNumber numberWithInteger:(NSInteger)MessageDeliveryState_Delivered] : [NSNumber numberWithInteger:(NSInteger)message.deliveryState];
            
            [dataDic setObject:(message.msgId ? message.msgId : [NSNull null]) forKey:@"MSGID"];
            [dataDic setObject:conversation.rid forKey:@"CONVERSATIONID"];
            [dataDic setObject:message.sender forKey:@"SENDERID"];
            [dataDic setObject:message.receiver forKey:@"RECEIVERID"];
            [dataDic setObject:[NSNumber numberWithBool:message.isGroup] forKey:@"ISGROUP"];
            [dataDic setObject:(message.isGroup ? message.groupId : [NSNull null]) forKey:@"GROUPID"];
            [dataDic setObject:[NSNumber numberWithBool:message.isRead] forKey:@"ISREAD"];
            [dataDic setObject:isAcked forKey:@"ISACKED"];
            [dataDic setObject:deliveryState forKey:@"DELIVERYSTATE"];
            [dataDic setObject:msgType forKey:@"MSGTYPE"];
            [dataDic setObject:msgSendType forKey:@"MSGSENDTYPE"];
            [dataDic setObject:message.text forKey:@"MSGBODY"];
            [dataDic setObject:[DateUtils dateToString:message.timestamp DateFormat:displayDateTimeFormat] forKey:@"SENDTIME"];
            
            if (message.rid && ![message.rid isEqualToString:@""]) {
                msgModel.where = [NSString stringWithFormat:@"RID = %@", message.rid];
                [msgModel updateDB:dataDic];
            } else {
                message.rid = [NSString stringWithFormat:@"%d", [msgModel insertDB:dataDic]];
            }
        }
    }];
}

- (void)deleteMessageFromDataBaseWithId:(NSString *)rid {
    [self messageHandlerQueue:^{
        if (rid && ![rid isEqualToString:@""]) {
            SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
            msgModel.where = [NSString stringWithFormat:@"RID = %@", rid];
            [msgModel deleteDBdata];
        }
    }];
}
@end
