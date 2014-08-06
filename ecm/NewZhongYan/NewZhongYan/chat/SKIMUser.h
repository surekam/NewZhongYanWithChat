//
//  SKIMUser.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-5.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKIMUser : NSObject
@property (nonatomic, copy) NSString *uid;   //UID
@property (nonatomic, copy) NSString *cname; //名字
@property (nonatomic, copy) NSString *pdpid; //部门id
@property (nonatomic, copy) NSString *pname; //部门名称
@property (nonatomic, copy) NSString *signature; //个性签名
@property (nonatomic, copy) NSString *avatarUri; //头像Uri
@end
