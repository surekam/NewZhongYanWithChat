//
//  SKIMMessageDataManager.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-9-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"

@interface SKIMMessageDataManager : NSObject

+ (SKIMMessageDataManager *)sharedMessageDataManager;

- (void)sendAndSaveMessage:(XHMessage *)message;

- (void)receiveAndSaveMessage:(NSDictionary *)messageDic;

- (void)receiveSendMessageRet:(NSDictionary *)messageRetDic;

- (void)deleteMessageFromDataBaseWithId:(NSString *)rid;

- (void)getHistoryMessageFromServer:(NSInteger)msgNumber;

- (void)sendGetMessageCountData;

- (void)getUserInfoFromServer;
@end
