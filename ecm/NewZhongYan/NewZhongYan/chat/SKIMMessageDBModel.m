//
//  SKIMMessageDBModel.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-14.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMMessageDBModel.h"
#import "FileManager.h"
#import "SKIMDBTables.h"
#import "XHMessage.h"

@implementation SKIMMessageDBModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        dbFilePath=[FileManager getFileDBPath:IMDataBaseFileName];
        db = [FMDatabase databaseWithPath:dbFilePath];
        tableName = IM_MESSAGE;
        _limit = 0;
        
    }
    return self;
}

+ (NSArray *)getMessagesFromModelArray:(NSArray *)modelArray
{
    if (modelArray == nil || modelArray.count == 0) {
        return nil;
    }
    NSMutableArray *msgArray = [NSMutableArray array];
    for (NSDictionary *dic in modelArray) {
        XHMessage *msg = [[XHMessage alloc] init];
        msg.rid = [dic objectForKey:@"RID"];
        msg.timestamp = [dic objectForKey:@"SENDTIME"];
        //TODO: 完善消息实体赋值
        [msgArray addObject:msg];
    }
    return msgArray;
}

@end
