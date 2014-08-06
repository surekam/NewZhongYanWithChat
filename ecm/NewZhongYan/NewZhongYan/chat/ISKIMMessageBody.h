//
//  ISKIMMessageBody.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-6.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKIMServiceDefs.h"

@protocol ISKIMChatObject;
@class SKIMMessage;

/*!
 @class
 @brief 聊天的消息体基类对象协议
 */
@protocol ISKIMMessageBody <NSObject>

@required

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
 @method
 @brief 由聊天对象构造消息体对象
 @discussion 派生类需要改写此方法
 @param chatObject 聊天对象
 @result 消息体对象
 */
- (id)initWithChatObject:(id<ISKIMChatObject>)chatObject;

@end

