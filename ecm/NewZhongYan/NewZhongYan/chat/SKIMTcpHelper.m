//
//  SKIMTcpHelper.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-28.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMTcpHelper.h"
#import "SKIMSocketConfig.h"
#import "SKIMTcpRequestHelper.h"
#import "TcpReadPackage.h"
#import "SKIMStatus.h"
#import "SKIMServiceDefs.h"
#import "SKIMMessageDataManager.h"

SKIMTcpHelper *TcpHelperSINGLE;

static BOOL isConnecting;

@implementation SKIMTcpHelper

+ (SKIMTcpHelper *)shareChatTcpHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (TcpHelperSINGLE == nil) {
            TcpHelperSINGLE = [[SKIMTcpHelper alloc] init];
        }
    });
    
    return TcpHelperSINGLE;
}

- (BOOL)isConnected {
    if (_serverSocket == nil) {
        return NO;
    }
    return [_serverSocket isConnected];
}

- (BOOL)connectToHost {
    if (isConnecting) {
        return NO;
    }
    if (allData != nil) {
        allData = nil;
    }
    allData = [[NSMutableData alloc] init];
    
    if (_serverSocket == nil) {
        _serverSocket =[[AsyncSocket alloc] initWithDelegate:self];
    }
    
    // 连接服务器
    if (![_serverSocket isConnected]) {
        isConnecting = YES;
        [_serverSocket disconnect];
        NSLog(@"=====Soket 正在连接服务器...:%@ %i",SOCKETIP,SOCKETPORT);
        return [_serverSocket connectToHost:SOCKETIP onPort:SOCKETPORT error:nil];
    }
    else{
        NSLog(@"已经和服务器连接");
        return YES;
    }
    
}

- (void)disConnectHost {
    [_serverSocket disconnect];
}

- (void)redirectConnectToHost:(NSString *)IPStr port:(int)portStr{
    
    if (isConnecting) {
        return;
    }
    [self disConnectHost];
    
    if (allData != nil) {
        allData = nil;
    }
    allData = [[NSMutableData alloc] init];
    
    if (_serverSocket == nil) {
        _serverSocket =[[AsyncSocket alloc] initWithDelegate:self];
    }
    
    // 连接服务器
    if (![_serverSocket isConnected]) {
        [_serverSocket disconnect];
        NSLog(@"=====Soket 正在重定向服务器...:%@ %i",IPStr,portStr);
        [_serverSocket connectToHost:IPStr onPort:portStr error:nil];
    }
    else{
        NSLog(@"重定向与服务器连接");
    }
}

- (void)sendMessage:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    
    [_serverSocket writeData:data withTimeout:timeout tag:tag];
    tcpCommandId = tag;
}

#pragma mark - AsyncSocketDelegate

// 成功连接后自动回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    isConnecting = NO;
    [sock readDataWithTimeout:-1 tag:tcpCommandId];
    NSLog(@"=====Soket 已经连接到服务器:%@ %hu",host,port);
    
    //如果未登录, 则执行登录;反之则获取历史消息记录信息
    if (![SKIMStatus sharedStatus].isLogin) {
        [[SKIMTcpRequestHelper shareTcpRequestHelper] sendLogingPackageCommand];
    } else {
        [[SKIMMessageDataManager sharedMessageDataManager] sendGetMessageCountData];
    }
}

// 接收到了一个新的socket连接 自动回调
// 接收到了新的连接  那么释放老的连接
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    NSLog(@"=====Socket DidacceptNewSocket %@",newSocket);
}

- (void)onSocketDidSecure:(AsyncSocket *)sock{
    NSLog(@"=====Socket Secure ");
}

// 写数据成功 自动回调
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"=====Socket 写数据成功 %ld",tag);
    // 继续监听
    [sock readDataWithTimeout:-1 tag:tcpCommandId];
}

//写入部分数据 回调
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    NSLog(@"=====Soket write partial data length %d",partialLength);
}

//写数据的过程中遇见 timeout
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    
    NSLog(@"=====Soket ShouldWrite tag%ld elapsed%f length%d",tag,elapsed,length);
    return -1;
}

// 客户端接收到了数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"=====Soket 收到消息");
    
    NSMutableArray *packgeArr = [[NSMutableArray alloc]init];
    // Incase the data is not complete so append data to insure it's completed
    [allData appendData:data];
    [self getComplateDataToArray:packgeArr];
    
    if (packgeArr.count > 0) {
        for (NSData * temp in packgeArr) {
            [TcpReadPackage readPackgeData:temp];
        }
    }
    // 继续监听
    [sock readDataWithTimeout:-1 tag:tag];
}

//读数据过程中遇见 timeout
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    NSLog(@"=====Soket read should time out elapsed %f doneByteLength %d",elapsed,length);
    return -1;
}

// 客户端读取数据
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"=====Socket did read partial length %d",partialLength);
}


- (void)getComplateDataToArray:(NSMutableArray *)arr
{
    const void * byte = (const void *) [allData bytes];
    if (allData.length >= HeadLen) {
        NSString *zyim = [[NSString alloc] initWithData:[NSData dataWithBytes:byte length:4] encoding:NSASCIIStringEncoding];
        if (![zyim isEqualToString:ZYIM]) {
            return;
        }
        NSString *msgLenStr = [[NSString alloc] initWithData:[NSData dataWithBytes:&byte[4] length:4] encoding:NSASCIIStringEncoding];
        NSUInteger msgLen = [[msgLenStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] longLongValue];
        if (allData.length < HeadLen + msgLen) {
            return;
        }else{
            NSData* packageData = [NSData dataWithData:[allData subdataWithRange:NSMakeRange(HeadLen, msgLen)]];
            [arr addObject:packageData];
            NSLog(@"%d",packageData.length);
            if (HeadLen + msgLen == allData.length) {
                allData = [[NSData data] mutableCopy];
            }else{
                NSLog(@"%d",allData.length);
                allData = [[NSData dataWithData:[allData subdataWithRange:NSMakeRange(HeadLen + msgLen, allData.length - HeadLen - msgLen)]] mutableCopy];
                NSLog(@"%d",allData.length);
                [self getComplateDataToArray:arr];
            }
//            NSLog(@"judgeData = %@",packageData);
//            NSLog(@"allData = %@",allData);
        }
    }else{
        return;
    }
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"======Socket Will disconnect with:%@",err);
    //    [Common checkProgressHUD:[NSString stringWithFormat:@"======Socket Will disconnect with %@",err ] andImage:nil showInView:APPD.keyWindow];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"======Socket DidDisconnected");
    isConnecting = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSocketDidDisconnected object:nil];
    });
}

@end
