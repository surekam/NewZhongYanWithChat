//
//  SKIMChatText.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-6.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISKIMChatObject.h"

@protocol ISKIMMessageBody;

@interface SKIMChatText : NSObject<ISKIMChatObject>

/*!
 @property
 @brief 文本对象的文本内容
 */
@property (nonatomic, strong) NSString *text;

/*!
 @property
 @brief
 聊天对象所在的消息体对象
 @discussion
 当消息体通过聊天对象创建完成后, messageBody为非nil, 当聊天对象并不属于任何消息体对象的时候, messageBody为nil
 */
@property (nonatomic, weak) id<ISKIMMessageBody> messageBody;

/*!
 @method
 @brief 以字符串构造文本对象
 @discussion
 @param text 文本内容
 @result 文本对象
 */
- (id)initWithText:(NSString *)text;

@end
