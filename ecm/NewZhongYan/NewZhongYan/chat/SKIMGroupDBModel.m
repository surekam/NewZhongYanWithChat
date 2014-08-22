//
//  SKIMGroupDBModel.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-22.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMGroupDBModel.h"
#import "FileManager.h"
#import "SKIMDBTables.h"

@implementation SKIMGroupDBModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        dbFilePath=[FileManager getFileDBPath:IMDataBaseFileName];
        db = [FMDatabase databaseWithPath:dbFilePath];
        tableName = IM_GROUP;
        _limit = 0;
        
    }
    return self;
}

//将SKIMGroupDBModel转换为SKIMGroup
+ (SKIMGroup *)getGroupFromModel:(NSDictionary *)modelDic
{
    if (modelDic == nil) {
        return nil;
    }
    SKIMGroup *group = [[SKIMGroup alloc] init];
    group.rid = [modelDic objectForKey:@"RID"];
    group.groupId = [modelDic objectForKey:@"GROUPID"];
    group.groupName = [modelDic objectForKey:@"GROUPNAME"];
    group.groupAvatarUri = [modelDic objectForKey:@"AVATAR"];
    
    return group;
}

@end
