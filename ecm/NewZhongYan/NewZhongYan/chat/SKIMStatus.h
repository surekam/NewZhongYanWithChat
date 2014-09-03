//
//  SKIMStatus.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-9-2.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKIMStatus : NSObject

+ (SKIMStatus *)sharedStatus;

@property (nonatomic, assign)BOOL isLogin;

@property (nonatomic, copy)NSString *sessionId;

@end
