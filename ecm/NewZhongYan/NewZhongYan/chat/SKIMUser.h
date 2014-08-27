//
//  SKIMUser.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-5.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKIMChater.h"

@interface SKIMUser : NSObject<SKIMChater>

@property (nonatomic, copy) NSString *rid;   //UID
@property (nonatomic, copy) NSString *cname; //名字
@property (nonatomic, copy) NSString *pdpid; //部门id
@property (nonatomic, copy) NSString *pname; //部门名称
@property (nonatomic, copy) NSString *signature; //个性签名
@property (nonatomic, copy) NSString *avatarUri; //头像Uri
@property (nonatomic, assign) BOOL isInitialized;

+ (SKIMUser *)currentUser;

+ (SKIMUser *)getUserFromUid:(NSString *)uid;

//判断user是否存在
+ (BOOL)isUserExists:(NSString *)uid;
@end
