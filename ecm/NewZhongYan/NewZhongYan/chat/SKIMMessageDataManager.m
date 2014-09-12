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

- (void)sendMessage:(XHMessage *)message withType:(XHBubbleMessageMediaType)messageType toChatter:(NSString *)chatterId
{
    if (message) {
        NSData *msgData = nil;
        switch (messageType) {
            case XHBubbleMessageMediaTypeText:
                msgData = [TcpSendPackage createMessagePackageWithMsg:message.text toUser:chatterId msgType:@""];
                [[SKIMTcpHelper shareChatTcpHelper] sendMessage:msgData withTimeout:-1 tag:TCP_SEND_COMMAND_ID];
                break;
                
            default:
                break;
        }
    }
}

- (void)addMessage:(NSDictionary *)messageDic
{
    if (_delegate && messageDic) {
        NSString *emoticonRegexStr = @"/.{2}\\\\n";             // 实际正则应为/.{2}\\n
        NSString *pictureRegexStr = @"/\\{\\{.+/\\}\\}";      // 实际正则应为/\{\{.+/\}\}
        NSString *fontRegexStr = @"/\\[\\[.+\\]\\]";            // 实际正则应为/\[\[.+\]\]
        
        NSString *msgContent = [messageDic objectForKey:IM_XML_BODY_SENDGMSG_CONTENT_ATTR];
        msgContent = [msgContent replace:RX(fontRegexStr) with:@""];
        
        BOOL isEmoticonMatch = [RX(emoticonRegexStr) isMatch:msgContent];
        BOOL isPictureMatch = [RX(pictureRegexStr) isMatch:msgContent];
        NSString *textContent = [[msgContent replace:RX(emoticonRegexStr) with:@""] replace:RX(pictureRegexStr) with:@""];
        
        XHMessage *message = [[XHMessage alloc] init];
        if ((isEmoticonMatch || isPictureMatch) && textContent.length) {
            message.messageMediaType = XHBubbleMessageMediaTypeMix;
            message.text = msgContent;
        } else if (isPictureMatch && !isEmoticonMatch && textContent.length == 0) {
            message.messageMediaType = XHBubbleMessageMediaTypePhoto;
            //TODO
        } else if (isEmoticonMatch && !isPictureMatch && textContent.length == 0) {
            message.messageMediaType = XHBubbleMessageMediaTypeEmotion;
            //TODO
        } else if (!isPictureMatch && !isEmoticonMatch && textContent.length) {
            message.messageMediaType = XHBubbleMessageMediaTypeText;
            message.text = msgContent;
        }
        
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        [_delegate addServerMessage:message];
    }
}

@end
