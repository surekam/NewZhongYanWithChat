//
//  TcpSendPackage.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-28.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

//发送的包的基类
@interface TcpSendPackage : NSObject

@property (nonatomic, retain) id head;

//登录包
+ (NSData *)createLoginPackage;

+ (NSData *)createMessagePackageWithMsg:(NSString *)message toUser:(NSString*)toUser msgType:(NSString *)msgType bySendIndex:(NSString **)sendIndex;

//注销包
+ (id)createLogoutPackage;

//消息包

@end
