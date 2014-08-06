//
//  SKIMTextMessageBody.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-6.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISKIMMessageBody.h"

@protocol ISKIMChatObject;
@class SKIMMessage;
@class SKIMChatText;

@interface SKIMTextMessageBody : NSObject<ISKIMMessageBody>

/*!
 @property
 @brief 消息体的类型
 */
@property (nonatomic, readonly) MessageBodyType messageBodyType;

/*!
 @property
 @brief 消息体的底层聊天对象
 */
@property (nonatomic, strong, readonly) id<ISKIMChatObject> chatObject;

/*!
 @property
 @brief 消息体所在的消息对象
 */
@property (nonatomic, weak) SKIMMessage *message;

/*!
 @property
 @brief 文本消息体的内部文本对象的文本
 */
@property (nonatomic, strong) NSString *text;

/*!
 @method
 @brief 以文本对象创建文本消息体实例
 @discussion
 @param aChatText 文本对象
 @result 文本消息体
 */
- (id)initWithChatObject:(SKIMChatText *)aChatText;


@end
