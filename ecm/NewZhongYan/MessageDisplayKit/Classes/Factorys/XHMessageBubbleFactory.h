//
//  XHMessageBubbleFactory.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XHBubbleMessageType) {
    XHBubbleMessageTypeSending = 0,
    XHBubbleMessageTypeReceiving
};

typedef NS_ENUM(NSUInteger, XHBubbleImageViewStyle) {
    XHBubbleImageViewStyleWeChat = 0
};

typedef NS_ENUM(NSInteger, XHBubbleMessageMediaType) {
    XHBubbleMessageMediaTypeText = 0,
    XHBubbleMessageMediaTypePhoto = 1,
    XHBubbleMessageMediaTypeVideo = 2,
    XHBubbleMessageMediaTypeVoice = 3,
    XHBubbleMessageMediaTypeEmotion = 4,
    XHBubbleMessageMediaTypeLocalPosition = 5,
    XHBubbleMessageMediaTypeMix = 6,
};

typedef NS_ENUM(NSInteger, XHBubbleMessageMenuSelecteType) {
    XHBubbleMessageMenuSelecteTypeCopy = 0,
    XHBubbleMessageMenuSelecteTypeTranspond = 1,
    XHBubbleMessageMenuSelecteTypeFavorites = 2,
    XHBubbleMessageMenuSelecteTypeMore = 3,
    XHBubbleMessageMenuSelecteTypeResend = 4,
    XHBubbleMessageMenuSelecteTypeDelete = 5,
};

/*!
 @enum
 @brief 聊天消息发送状态
 @constant MessageDeliveryState_Pending 待发送
 @constant MessageDeliveryState_Delivering 正在发送
 @constant MessageDeliveryState_Delivered 已发送, 成功
 @constant MessageDeliveryState_Failure 已发送, 失败
 */
typedef NS_ENUM(NSInteger, MessageDeliveryState){
    MessageDeliveryState_Delivering = 0,
    MessageDeliveryState_Delivered = 1,
    MessageDeliveryState_Failure = 2,
};


@interface XHMessageBubbleFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(XHBubbleMessageType)type
                                  style:(XHBubbleImageViewStyle)style
                              meidaType:(XHBubbleMessageMediaType)mediaType;


@end
