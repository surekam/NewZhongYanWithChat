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
        [self sendMessageQueue:^{
            NSData *msgData = nil;
            switch (messageType) {
                case XHBubbleMessageMediaTypeText:
                    msgData = [TcpSendPackage createMessagePackageWithMsg:message.text toUser:chatterId msgType:nil];
                    [[SKIMTcpHelper shareChatTcpHelper] sendMessage:msgData withTimeout:-1 tag:TCP_SEND_COMMAND_ID];
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

- (void)addMessage:(NSDictionary *)messageDic
{
    if (_delegate && messageDic) {
        
        XHMessage *message = [[XHMessage alloc] init];
        message.text = [messageDic objectForKey:IM_XML_BODY_SENDGMSG_CONTENT_ATTR];
        message.messageMediaType = XHBubbleMessageMediaTypeText;
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        [_delegate addServerMessage:message];
    }
}

@end
