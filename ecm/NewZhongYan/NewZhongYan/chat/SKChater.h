//
//  SKChater.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-18.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKChater : NSObject

@property (nonatomic, copy) NSString *uid;   //UID
@property (nonatomic, copy) NSString *cname; //名字
@property (nonatomic, copy) NSString *pdpid; //部门id
@property (nonatomic, copy) NSString *pname; //部门名称
@property (nonatomic, assign) BOOL disabled; //是否不让选择
@property (nonatomic, assign) BOOL selected; //是否已经被选择

@end
