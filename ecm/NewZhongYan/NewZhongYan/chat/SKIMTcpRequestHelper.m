//
//  SKIMTcpRequestHelper.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-28.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMTcpRequestHelper.h"
#import "SKIMTcpHelper.h"
#import "TcpSendPackage.h"
#import "SKIMSocketConfig.h"

SKIMTcpRequestHelper *TcpRequestHelperSINGLE;

@implementation SKIMTcpRequestHelper
{
    NSMutableDictionary * _waitForStoreData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
         _waitForStoreData = [NSMutableDictionary new];
    }
    return self;
}

+ (SKIMTcpRequestHelper *)shareTcpRequestHelper {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (TcpRequestHelperSINGLE==nil) {
            TcpRequestHelperSINGLE = [[SKIMTcpRequestHelper alloc] init];
        }
    });
    
    return TcpRequestHelperSINGLE;
}

- (void)sendLogingPackageCommandId:(int)type {
    
    NSData *data = [TcpSendPackage createLoginPackage];
    [[SKIMTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
    
}

@end
