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

- (XHMessage *)latestMessage
{
    if (_messages != nil) {
        return (XHMessage *)[_messages lastObject];
    }
    return nil;
}

- (NSMutableArray *)messages
{
    if (_messages == nil && self.rid != nil) {
        SKIMMessageDBModel *msgModel = [[SKIMMessageDBModel alloc] init];
        msgModel.where = [NSString stringWithFormat:@"CONVERSATIONID = %@", self.rid];
        msgModel.orderBy = @"SENDTIME";
        msgModel.limit = 20;
        NSArray *resultDics = [msgModel getList];
        
        [_messages addObjectsFromArray:[SKIMMessageDBModel getMessagesFromModelArray:resultDics]];
    }
    return _messages;
}

- (NSString *)conversationName
{
    NSString *conversationName = nil;
    if (_chatter) {
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
    if (_chatter) {
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
    msgModel.orderBy = @"RID";
    msgModel.limit = count;
    NSArray *resultDics = [msgModel getList];
    
    //TODO:这里还需要考虑排序的问题
    return [SKIMMessageDBModel getMessagesFromModelArray:resultDics];
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
        NSComparisonResult result = [m1.rid compare:m2.rid];
        return result;
    }];
    return sortedArray;
}
@end
