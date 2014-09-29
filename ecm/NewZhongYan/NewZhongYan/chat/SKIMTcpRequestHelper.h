//
//  SKIMTcpRequestHelper.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-28.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKIMTcpHelper.h"

@protocol SKIMTcpRequestHelperDelegate <NSObject>

- (void)didFinishedMessageSendWithDic:(NSDictionary *)retDic;

@end

@interface SKIMTcpRequestHelper : NSObject <SKIMTcpHelperDeletage>
{
    NSTimeInterval *_nextSendIntarvel;
}

@property (nonatomic, assign) id <SKIMTcpRequestHelperDelegate> delegate;

+ (SKIMTcpRequestHelper *)shareTcpRequestHelper;

- (void)sendLogingPackageCommand;

- (void)sendMessagePackageCommandWithMessageData:(NSData *)msgData withTimeout:(NSTimeInterval)timeout;

- (void)sendGetMessageCountPackageCommandWithGetMessageCountData:(NSData *)msgData withTimeout:(NSTimeInterval)timeout;
@end
