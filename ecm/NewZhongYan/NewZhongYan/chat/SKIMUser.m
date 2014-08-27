//
//  SKIMUser.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-5.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMUser.h"
#import "SKIMUserDBModel.h"

@implementation SKIMUser

+ (SKIMUser *)currentUser
{
   return [self getUserFromUid:[APPUtils loggedUser].uid];
}

+ (SKIMUser *)getUserFromUid:(NSString *)uid
{
    if (uid == nil || uid.length == 0) {
        return nil;
    }
    SKIMUserDBModel *userModel = [[SKIMUserDBModel alloc] init];
    if (![SKIMUser isUserExists:uid]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[uid] forKeys:@[@"UID"]];
        [userModel insertDB:params];
    }
    userModel.where = [NSString stringWithFormat:@"UID = '%@'", uid];
    NSArray *resultDics = [userModel getList];
    if (resultDics == nil || resultDics.count != 1) {
        return nil;
    }
    
    return [SKIMUserDBModel getUserFromModel:resultDics[0]];
}

//判断user是否存在
+ (BOOL)isUserExists:(NSString *)uid
{
    if (uid == nil || uid.length == 0) {
        return NO;
    }
    SKIMUserDBModel *userModel = [[SKIMUserDBModel alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT 1 FROM IM_USER WHERE UID = '%@'", uid];
    NSArray* result = [userModel querSelectSql:sql];
    if (result != nil && result.count >= 1) {
        return YES;
    }
    return NO;
}

@end
