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
        SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
        msgModel.where = [NSString stringWithFormat:@"CONVERSATIONID = %@", self.rid];
        msgModel.orderBy = @"SENDTIME";
        msgModel.orderType = @"DESC";
        msgModel.limit = 20;
        NSArray *resultDics = [msgModel getList];
        
        NSArray *msgArray = [SKIMMessageDBModel getMessagesFromModelArray:resultDics];
        
        if (msgArray.count) {
            NSArray *sortedArray = [msgArray sortedArrayUsingComparator:^NSComparisonResult(XHMessage *c1, XHMessage *c2) {
                return [c1.timestamp compare:c2.timestamp];
            }];
            _messages = [NSMutableArray arrayWithArray:sortedArray];
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
    SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
    NSString *msgRid = @"0";
    if (_messages) {
        XHMessage *firstMsg = [_messages firstObject];
        msgRid = firstMsg.rid;
    }
    msgModel.where = [NSString stringWithFormat:@"CONVERSATIONID = %@ AND RID < %@", self.rid, msgRid];
    msgModel.orderBy = @"SENDTIME";
    msgModel.orderType = @"DESC";
    msgModel.limit = count;
    NSArray *resultDics = [msgModel getList];
    
    NSArray *msgArray = [SKIMMessageDBModel getMessagesFromModelArray:resultDics];
    
    if (msgArray.count) {
        NSArray *sortedArray = [msgArray sortedArrayUsingComparator:^NSComparisonResult(XHMessage *c1, XHMessage *c2) {
            return [c1.timestamp compare:c2.timestamp];
        }];
        return sortedArray;
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
        return [m2.timestamp compare:m1.timestamp];
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
@end
