//
//  SKIMTcpHelper.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-28.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@protocol SKIMTcpHelperDeletage <NSObject>

@end

//tcp发送请求类
@interface SKIMTcpHelper : NSObject <AsyncSocketDelegate> {

    AsyncSocket *_serverSocket;
    int tcpCommandId;
    NSMutableData* allData;
    
}

//@property (nonatomic, assign) id <ChatTcpHelperDeletage> delegate;

+ (SKIMTcpHelper *)shareChatTcpHelper;

//是否连接
- (BOOL)isConnected;

//连接服务器
- (BOOL)connectToHost;

//断开服务器
- (void)disConnectHost;

//重定向连接
- (void)redirectConnectToHost:(NSString *)IPStr port:(int)portStr;

//发送消息
- (void)sendMessage:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;

@end
