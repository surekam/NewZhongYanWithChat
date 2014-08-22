//
//  SKIMConversation.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-5.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHMessage;
@protocol SKIMChater;

@interface SKIMConversation : NSObject

//会话id
@property (nonatomic, copy) NSString *rid;

//会话对方的Id,为个人或群组id
@property (nonatomic, strong) id<SKIMChater> chatter;

//是否为群组会话
@property (nonatomic, assign) BOOL isGroup;

//此会话中的消息列表
@property (nonatomic, strong) NSMutableArray *messages;

//是否接收关于此会话的消息
@property (nonatomic, assign) BOOL isReceiveMsg;

//此会话是否被移除
@property (nonatomic, assign) BOOL isEnable;

#pragma mark - message
/*!
 @method
 @brief 根据消息ID从数据库中加载消息
 @discussion 如果数据库中没有这条消息, 方法返回nil
 @param messageId 消息ID
 @result 加载的消息
 */
- (XHMessage *)loadMessage:(NSString *)messageId;


/*!
 @method
 @brief 根据消息ID列表从数据库中加载消息
 @discussion 如果数据库中没有某条消息对应的ID, 则不加载这条消息
 @param messageIds 消息ID列表
 @result 加载的消息列表
 */
- (NSArray *)loadMessages:(NSArray *)messageIds;


/*!
 @method
 @brief 根据消息ID列表从数据库中加载消息
 @discussion 如果数据库中没有某条消息对应的ID, 则不加载这条消息
 @result 加载的消息列表
 */
- (NSArray *)loadAllMessages;

/*!
 @method
 @brief 根据时间加载指定条数的消息
 @param count 要加载的消息条数
 @param timestamp 时间点, UTC时间, 以毫秒为单位
 @discussion
 1. 加载后的消息按照升序排列;
 2. NSDate返回的timeInterval是以秒为单位的, 如果使用NSDate, 比如 timeIntervalSince1970 方法，需要将 timeInterval 乘以1000
 @result 加载的消息列表
 */
- (NSArray *)loadNumbersOfMessages:(NSUInteger)count before:(long long)timestamp;

/*!
 @method
 @brief 获取conversation最新一条消息
 @result SKIMMessage最新一条消息
 */
- (XHMessage *)latestMessage;

/*!
 @method
 @brief 获取conversation从对方发过来的最新一条消息
 @result SKIMMessage最新一条消息
 */
- (XHMessage *)latestMessageFromOthers;

#pragma mark - mark conversation

/*!
 @method
 @brief 把本对话里的所有消息标记为已读/未读
 @discussion
 @param isRead 已读或未读
 @result 成功标记的消息条数
 */
- (NSUInteger)markMessagesAsRead:(BOOL)isRead;

/*!
 @method
 @brief 把本条消息标记为已读/未读
 @discussion 非此conversation的消息不会被标记
 @param messageId 需要被标记的消息ID
 @param isRead 已读或未读
 @result 是否成功标记此条消息
 */
- (BOOL)markMessage:(NSString *)messageId asRead:(BOOL)isRead;

#pragma mark - statistics

/*!
 @method
 @brief 获取此对话中所有未读消息的条数
 @discussion
 @result 此对话中所有未读消息的条数
 */
- (NSUInteger)unreadMessagesCount;

//获取聊天对话名
- (NSString *)conversationName;

//获取聊天对象头像Uri
- (NSString *)conversationHeadImg;

//获取聊天对象id
- (NSString *)chatterId;

//加载指定条数的消息
- (NSArray *)loadNumbersOfMessages:(NSUInteger)count;

//加载所有已经存在的会话
+ (NSArray *)loadAllExistConversation;

@end
