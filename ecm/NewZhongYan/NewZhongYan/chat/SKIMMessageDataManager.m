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
//                msgData = [TcpSendPackage createMessagePackageWithMsg:message.text toUser:chatterId msgType:@""];
//                [[SKIMTcpHelper shareChatTcpHelper] sendMessage:msgData withTimeout:-1 tag:TCP_SEND_COMMAND_ID];
//                break;
            case XHBubbleMessageMediaTypeMix: {
                NSString *text = [message.text copy];
                NSArray *emotionMatchs = [text matchesWithDetails:RX(EMOTION_NAME_REGX)];
                for (RxMatch *emotionMatch in emotionMatchs) {
                    NSUInteger index = [EMOTION_NAME indexOfObject:emotionMatch.value];
                    if (index != NSNotFound) {
                        text = [text stringByReplacingOccurrencesOfString:emotionMatch.value withString:EMOTION_ID[index]];
                    }
                }
                msgData = [TcpSendPackage createMessagePackageWithMsg:text toUser:message.receiver msgType:@""];
                [[SKIMTcpHelper shareChatTcpHelper] sendMessage:msgData withTimeout:-1 tag:TCP_SEND_COMMAND_ID];
                break;
            }
            default:
                break;
        }
    }
}

- (void)addMessage:(NSDictionary *)messageDic
{
    if (_delegate && messageDic) {
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
        }
        
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        [_delegate addServerMessage:message];
    }
}


- (void)saveMessageToDB:(XHMessage *)message {
    if (message) {
        //获取会话
        SKIMConversation *conversation = [SKIMConversation getConversationWithChatterId:message.sender isGroup:message.isGroup];
        
        SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        
        [dataDic setObject:message.msgId forKey:@"MSGID"];
        [dataDic setObject:conversation.rid forKey:@"CONVERSATIONID"];
        [dataDic setObject:message.sender forKey:@"SENDERID"];
        [dataDic setObject:message.receiver forKey:@"RECEIVERID"];
        [dataDic setObject:[NSNumber numberWithBool:message.isGroup] forKey:@"ISGROUP"];
        [dataDic setObject:message.msgId forKey:@"GROUPID"];
        [dataDic setObject:message.msgId forKey:@"ISREAD"];
        [dataDic setObject:message.msgId forKey:@"ISACKED"];
        [dataDic setObject:message.msgId forKey:@"DELIVERYSTATE"];
        [dataDic setObject:message.msgId forKey:@"MSGTYPE"];
        [dataDic setObject:message.msgId forKey:@"MSGSENDTYPE"];
        [dataDic setObject:message.msgId forKey:@"MSGBODY"];
        [dataDic setObject:message.msgId forKey:@"SENDTIME"];
    }
    
}

@end
