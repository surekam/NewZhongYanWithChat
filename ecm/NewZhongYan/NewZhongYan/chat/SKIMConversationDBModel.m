//
//  SKIMConversationDBModel.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-11.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMConversationDBModel.h"
#import "SKIMDBTables.h"
#import "FileManager.h"
#import "SKIMConversation.h"
#import "SKIMUser.h"
#import "SKIMGroup.h"


@implementation SKIMConversationDBModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        dbFilePath=[FileManager getFileDBPath:IMDataBaseFileName];
        db = [FMDatabase databaseWithPath:dbFilePath];
        tableName = IM_CONVERSATION;
        _limit = 0;

    }
    return self;
}

+ (NSArray *)getConversationsFromModelArray:(NSArray *)modelArray
{
    if (modelArray == nil || modelArray.count == 0) {
        return nil;
    }
    NSMutableArray *conversationArray = [NSMutableArray array];
    for (NSDictionary *dic in modelArray) {
        SKIMConversation *conversation = [[SKIMConversation alloc] init];
        conversation.rid = [dic objectForKey:@"RID"];
        conversation.isGroup = (BOOL)[[dic objectForKey:@"ISGROUP"] integerValue];
        conversation.isReceiveMsg = (BOOL)[[dic objectForKey:@"ISRECEIVEMSG"] integerValue];
        conversation.isEnable = (BOOL)[[dic objectForKey:@"ISENABLE"] integerValue];
        
        if (conversation.isGroup) {
            SKIMGroup *group = [SKIMGroup getGroupFromRid:[dic objectForKey:@"CHATTERID"]];
            conversation.chatter = group;
        } else {
            SKIMUser *user = [SKIMUser getUserFromUid:[dic objectForKey:@"CHATTERID"]];
            conversation.chatter = user;
        }
        
        [conversationArray addObject:conversation];
    }
    return conversationArray;
}

@end
