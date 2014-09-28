//
//  SKIMConversation.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-5.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMConversation.h"
#import "SKIMUser.h"
#import "SKIMGroup.h"
#import "SKIMConversationDBModel.h"
#import "SKIMMessageDBModel.h"
#import "XHMessage.h"
#import "SKIMServiceDefs.h"
#import "SKIMSocketConfig.h"

@interface SKIMConversation ()

@end

@implementation SKIMConversation
@synthesize rid = _rid;
@synthesize chatter = _chatter;
@synthesize isGroup = _isGroup;
@synthesize messages = _messages;
@synthesize isEnable = _isEnable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messages = [NSMutableArray array];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _isEnable = enabled;
    SKIMConversationDBModel *conversationModel = [[SKIMConversationDBModel alloc] init];
    NSString *upateSql = [NSString stringWithFormat:@"UPDATE IM_CONVERSATION SET ISENABLE = %d WHERE RID = %@", _isEnable, _rid];
    [conversationModel queryUpdateSql:upateSql];
}

- (id<SKIMChater>)chatter
{
    if (!_chatter.isInitialized) {
        if (_isGroup) {
            _chatter = [SKIMGroup getGroupFromRid:_chatter.rid];
        } else {
            _chatter = [SKIMUser getUserFromUid:_chatter.rid];
        }
        _chatter.isInitialized = YES;
    }
    return _chatter;
}

- (XHMessage *)latestMessage
{
    return [[self messages] lastObject];
}

- (NSMutableArray *)messages
{
    if (_messages.count == 0 && self.rid != nil) {
        [self updateTimeoutDeliveringMessageWithConversationId:self.rid];
        
        SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM \
                              (SELECT * FROM IM_MESSAGE WHERE CONVERSATIONID = %@ ORDER BY SENDTIME DESC, (CASE WHEN DELIVERYSTATE = 2 THEN RID ELSE MSGID END) DESC LIMIT 0, %d) \
                              ORDER BY SENDTIME ASC, (CASE WHEN DELIVERYSTATE = 2 THEN RID ELSE MSGID END) ASC",
                              self.rid, DEFAULT_LOAD_MSG_NUM];
        NSArray *resultDics = [msgModel querSelectSql:selectSql];
        NSArray *msgArray = [SKIMMessageDBModel getMessagesFromModelArray:resultDics];
        
        if (msgArray.count) {
            _messages = [NSMutableArray arrayWithArray:msgArray];
        }
    }
    return _messages;
}

//获取聊天对象id
- (NSString *)chatterId
{
    if (_chatter) {
        return _chatter.rid;
    }
    return nil;
}

- (NSString *)conversationName
{
    NSString *conversationName = nil;
    if (self.chatter) {
        if (_isGroup) {
            SKIMGroup *chatGroup = (SKIMGroup *)_chatter;
            conversationName = chatGroup.groupName;
        } else {
            SKIMUser *chatUser = (SKIMUser *)_chatter;
            conversationName = chatUser.cname;
        }
    }
    return conversationName;
}

- (NSString *)conversationHeadImg
{
    NSString *conversationHeadImg = nil;
    if (self.chatter) {
        if (_isGroup) {
            SKIMGroup *chatGroup = (SKIMGroup *)_chatter;
            conversationHeadImg = chatGroup.groupAvatarUri;
        } else {
            SKIMUser *chatUser = (SKIMUser *)_chatter;
            conversationHeadImg = chatUser.avatarUri;
        }
    }
    return conversationHeadImg;
}

- (NSUInteger)unreadMessagesCount
{
    NSUInteger unreadCount = 0;
    if (self.rid) {
        SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
        NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(1) AS UNREADCOUNT FROM IM_MESSAGE WHERE ISREAD = 0 AND CONVERSATIONID = %@", self.rid];
        NSArray *resultDics = [msgModel querSelectSql:querySql];
        if (resultDics.count) {
            unreadCount = [[resultDics[0] objectForKey:@"UNREADCOUNT"] intValue];
        }
    }
    return unreadCount;
}

//加载指定条数的消息
- (NSArray *)loadNumbersOfMessages:(NSUInteger)count
{
    if (count <= 0 || self.rid == nil) {
        return nil;
    }
    [self updateTimeoutDeliveringMessageWithConversationId:self.rid];
    
    SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
    NSString *firstMsgRid = @"0";
    NSString *firstMsgMsgId = @"0";
    NSString *firstMsgSendTime = @"1970-01-01 00:00:00";
    if (_messages) {
        XHMessage *firstMsg = [_messages firstObject];
        firstMsgRid = firstMsg.rid;
        firstMsgMsgId = firstMsg.msgId;
        firstMsgSendTime = [DateUtils dateToString:firstMsg.timestamp DateFormat:displayDateTimeFormat];
    }
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM \
                           (SELECT * FROM IM_MESSAGE WHERE CONVERSATIONID = %@ AND SENDTIME <= '%@' \
                           AND (CASE WHEN SENDTIME = '%@' AND DELIVERYSTATE <> 2 THEN (CASE WHEN MSGID < '%@' THEN 1 ELSE 0 END) \
                           WHEN SENDTIME = '%@' AND DELIVERYSTATE = 2 THEN (CASE WHEN RID < %@ THEN 1 ELSE 0 END) \
                           ELSE 1 END) = 1 ORDER BY SENDTIME DESC, (CASE WHEN DELIVERYSTATE = 2 THEN RID ELSE MSGID END) DESC LIMIT 0, %d) \
                           ORDER BY SENDTIME ASC, (CASE WHEN DELIVERYSTATE = 2 THEN RID ELSE MSGID END) ASC",
                           self.rid, firstMsgSendTime, firstMsgSendTime, firstMsgMsgId, firstMsgSendTime, firstMsgRid, DEFAULT_LOAD_MSG_NUM];
    
    NSArray *resultDics = [msgModel querSelectSql:selectSql];
    
    NSArray *msgArray = [SKIMMessageDBModel getMessagesFromModelArray:resultDics];
    
    if (msgArray.count) {
        return msgArray;
    }
    return nil;
}

//加载所有已经存在的会话
+ (NSArray *)loadAllExistConversation
{
    SKIMConversationDBModel *conversationModel = [[SKIMConversationDBModel alloc] init];
    conversationModel.where = @"ISENABLE = 1";
    NSArray *resultDics = [conversationModel getList];
    NSArray *sortedArray = [[SKIMConversationDBModel getConversationsFromModelArray:resultDics] sortedArrayUsingComparator:^NSComparisonResult(SKIMConversation *c1, SKIMConversation *c2) {
        XHMessage *m1 = [c1 latestMessage];
        XHMessage *m2 = [c2 latestMessage];
        NSComparisonResult comparisonResult = [m2.timestamp compare:m1.timestamp];
        if (comparisonResult != NSOrderedSame) {
            return comparisonResult;
        } else {
            comparisonResult = [m2.msgId compare:m1.msgId];
            if (comparisonResult != NSOrderedSame) {
                return comparisonResult;
            } else {
                comparisonResult = [m2.rid compare:m1.rid];
                return comparisonResult;
            }
        }
    }];
    return sortedArray;
}

//根据聊天对象id获取conversation,若不存在，则创建一个新的返回,但未启用。
+ (SKIMConversation *)getConversationWithChatterId:(NSString *)chatterId isGroup:(BOOL)isGroup
{
    if (chatterId == nil || chatterId.length == 0) {
        return nil;
    }
    SKIMConversationDBModel *conversationModel = [[SKIMConversationDBModel alloc] init];
    if (![SKIMConversation isConversationExists:chatterId isGroup:isGroup]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[chatterId, [NSNumber numberWithBool:isGroup], @1, @0] forKeys:@[@"CHATTERID", @"ISGROUP", @"ISRECEIVEMSG", @"ISENABLE"]];
        [conversationModel insertDB:params];
    }
    conversationModel.where = [NSString stringWithFormat:@"CHATTERID = '%@' AND ISGROUP = %i", chatterId, isGroup];
    NSArray *conversationArray = [SKIMConversationDBModel getConversationsFromModelArray:[conversationModel getList]];
    if (conversationArray != nil && conversationArray.count > 0) {
        return conversationArray[0];
    }
    return nil;
}

//判断conversation是否存在
+ (BOOL)isConversationExists:(NSString *)chatterId isGroup:(BOOL)isGroup
{
    if (chatterId == nil || chatterId.length == 0) {
        return NO;
    }
    SKIMConversationDBModel *conversationModel = [[SKIMConversationDBModel alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT 1 FROM IM_CONVERSATION WHERE CHATTERID = '%@' AND ISGROUP = %i", chatterId, isGroup];
    NSArray* result = [conversationModel querSelectSql:sql];
    if (result != nil && result.count >= 1) {
        return YES;
    }
    return NO;
}

//加载消息时，更新已经超过默认超时时间的正在发送的消息为发送失败
- (void)updateTimeoutDeliveringMessageWithConversationId:(NSString *)rid {
    if (rid) {
        SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE IM_MESSAGE SET MSGID = '%@', DELIVERYSTATE = 2 WHERE MSGSENDTYPE = 0 AND DELIVERYSTATE = 0 AND CONVERSATIONID = %@ AND SENDTIME < datetime('now','Localtime', '-%d second')", SENDFAILED_MSGID, rid, DEFAULT_TIMEOUT];
        [msgModel queryUpdateSql:updateSql];
    }
}
@end
