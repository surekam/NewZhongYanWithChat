//
//  SKIMStatus.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-9-2.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMStatus.h"

@implementation SKIMStatus

+ (SKIMStatus *)sharedStatus
{
    static SKIMStatus *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[SKIMStatus alloc] init];
        }
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLogin = NO;
        _isReLoginByOther = NO;
        _sessionId = nil;
    }
    return self;
}

@end
