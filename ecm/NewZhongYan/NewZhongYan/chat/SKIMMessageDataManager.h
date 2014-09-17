//
//  SKIMMessageDataManager.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-9-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"

@protocol SKIMMessageDataManagerDelegate <NSObject>

- (void)addServerMessage:(XHMessage *)message;

@end

@interface SKIMMessageDataManager : NSObject

@property (nonatomic, assign) id <SKIMMessageDataManagerDelegate> delegate;

+ (SKIMMessageDataManager *)sharedMessageDataManager;

- (void)sendAndSaveMessage:(XHMessage *)message;

- (void)addMessage:(NSDictionary *)messageDic;

@end
