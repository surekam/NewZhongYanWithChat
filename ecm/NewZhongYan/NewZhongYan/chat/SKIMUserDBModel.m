//
//  SKIMUserDBModel.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-22.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMUserDBModel.h"
#import "FileManager.h"
#import "SKIMDBTables.h"
#import "SKIMUser.h"

@implementation SKIMUserDBModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        dbFilePath=[FileManager getFileDBPath:IMDataBaseFileName];
        db = [FMDatabase databaseWithPath:dbFilePath];
        tableName = IM_USER;
        _limit = 0;
        
    }
    return self;
}

//将SKIMBaseDBModel转换为SKIMUser
+ (SKIMUser *)getUserFromModel:(NSDictionary *)modelDic
{
    if (modelDic == nil) {
        return nil;
    }
    SKIMUser *user = [[SKIMUser alloc] init];
    user.uid = [modelDic objectForKey:@"UID"];
    user.signature = [modelDic objectForKey:@"SIGNATURE"];
    user.avatarUri = [modelDic objectForKey:@"AVATAR"];
    user = [self getUserInfo:user];
    
    return user;
}

+ (SKIMUser *)getUserInfo:(SKIMUser *)user
{
    if (user == nil || user.uid == nil || user.uid.length == 0) {
        return nil;
    }

    NSString* sql =[NSString stringWithFormat:
                    @"SELECT E.CNAME,E.MOBILE,E.EMAIL,E.MOBILE,E.SHORTPHONE,E.TELEPHONE,E.TNAME,E.OFFICEADDRESS,U.CNAME UCNAME,U.PNAME,U.DPID \
                    FROM T_UNIT U LEFT JOIN T_EMPLOYEE E \
                    ON U.DPID = E.DPID \
                    WHERE E.UID = '%@';",
                    user.uid];
    NSDictionary *userInfoDic = [[NSDictionary alloc] initWithDictionary:[[[DBQueue sharedbQueue] recordFromTableBySQL:sql] objectAtIndex:0]];
    user.cname = [userInfoDic objectForKey:@"CNAME"];
    user.pdpid = [userInfoDic objectForKey:@"DPID"];
    user.pname = [userInfoDic objectForKey:@"PNAME"];
    
    return user;
}

@end
