//
//  ISKIMChatObject.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-6.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISKIMMessageBody;

/*!
 @class
 @brief 聊天对象基类对象协议
 */
@protocol ISKIMChatObject <NSObject>

@required

/*!
 @property
 @brief 聊天对象所在的消息体对象
 @discussion
 当消息体通过聊天对象创建完成后, messageBody为非nil, 当聊天对象并不属于任何消息体对象的时候, messageBody为nil
 */
@property (nonatomic, weak) id<ISKIMMessageBody> messageBody;

@end