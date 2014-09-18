//
//  SKIMMessageDataManager.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-9-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMMessageDataManager.h"
#import "SKIMTcpHelper.h"
#import "TcpSendPackage.h"
#import "SKIMSocketConfig.h"
#import "SKIMXMLConstants.h"
#import "RegExCategories.h"
#import "SKIMServiceDefs.h"
#import "SKIMMessageDBModel.h"
#import "SKIMConversation.h"

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

- (void)sendMessageQueue:(void (^)())queue {
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
                [[SKIMTcpHelper shareChatTcpHelper] sendMessage:msgData withTimeout:-1 tag:TCP_SEND_COMMAND_ID];
                break;
            }
            default:
                break;
        }
        [self saveMessageToDB:message];
    }
}

//接收并更新发送个人消息后服务端返回的信息
- (void)receiveSendMessageRet:(NSDictionary *)messageRetDic {
    if (messageRetDic) {
        NSString *resultCode = [messageRetDic objectForKey:IM_XML_BODY_RESULTCODE_ATTR];

        if ([resultCode isEqualToString:RETURN_CODE_SUCCESS]) {
            NSString *index = [messageRetDic objectForKey:IM_XML_HEAD_INDEX_ATTR];
            NSString *msgId = [messageRetDic objectForKey:IM_XML_BODY_SENDMSG_MESSAGEID_ATTR];
            NSDate *sendDate = [messageRetDic objectForKey:IM_XML_BODY_SENDMSG_SENDDATE_ATTR];
            
            SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
            NSString *querySql = [[@"SELECT RID FROM IM_MESSAGE WHERE ISACKED = 0 AND MSGSENDTYPE = 0 AND MSGID = '" stringByAppendingString:index] stringByAppendingString:@"'"];
            NSArray* result = [msgModel querSelectSql:querySql];
            if (result.count) {
                NSString *rid = [result[0] objectForKey:@"RID"];
                NSString *updateSql = [NSString stringWithFormat:@"UPDATE IM_MESSAGE SET ISACKED = 1, MSGID = '%@', SENDTIME = '%@' WHERE RID = %@", msgId, sendDate, rid];
                [msgModel queryUpdateSql:updateSql];
            }
        }
    }
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
        message.timestamp = [messageDic objectForKey:IM_XML_BODY_SENDMSG_SENDDATE_ATTR];
        message.sender = [messageDic objectForKey:IM_XML_HEAD_USERID_ATTR];
        message.receiver = [APPUtils userUid];
        
        if ([_delegate respondsToSelector:@selector(addServerMessage:)]) {
            [_delegate addServerMessage:message];
        }
        
        [self saveMessageToDB:message];
    }
}


- (void)saveMessageToDB:(XHMessage *)message {
    if (message) {
        //获取会话
        NSString *chatterId = message.bubbleMessageType ? message.sender : message.receiver;
        SKIMConversation *conversation = [SKIMConversation getConversationWithChatterId:chatterId isGroup:message.isGroup];
        
        SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        NSNumber *msgType = [NSNumber numberWithInteger:message.messageMediaType];
        NSNumber *msgSendType = [NSNumber numberWithInteger:message.bubbleMessageType];
        NSNumber *isAcked = msgSendType;
        
        [dataDic setObject:(message.msgId ? message.msgId : [NSNull null]) forKey:@"MSGID"];
        [dataDic setObject:conversation.rid forKey:@"CONVERSATIONID"];
        [dataDic setObject:message.sender forKey:@"SENDERID"];
        [dataDic setObject:message.receiver forKey:@"RECEIVERID"];
        [dataDic setObject:[NSNumber numberWithBool:message.isGroup] forKey:@"ISGROUP"];
        [dataDic setObject:(message.isGroup ? message.groupId : [NSNull null]) forKey:@"GROUPID"];
        [dataDic setObject:[NSNumber numberWithBool:NO] forKey:@"ISREAD"];
        [dataDic setObject:isAcked forKey:@"ISACKED"];
        [dataDic setObject:[NSNumber numberWithInteger:0] forKey:@"DELIVERYSTATE"];
        [dataDic setObject:msgType forKey:@"MSGTYPE"];
        [dataDic setObject:msgSendType forKey:@"MSGSENDTYPE"];
        [dataDic setObject:message.text forKey:@"MSGBODY"];
        [dataDic setObject:message.timestamp forKey:@"SENDTIME"];
        
        [msgModel insertDB:dataDic];
    }
    
}

@end
