//
//  TcpReadPackage.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-29.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "TcpReadPackage.h"
#import "SKIMSocketConfig.h"
#import "SKIMXMLUtils.h"
#import "SKIMXMLConstants.h"
#import "SKIMStatus.h"
#import "SKIMMessageDataManager.h"
#import "SKIMServiceDefs.h"
#import "TcpSendPackage.h"
#import "SKIMTcpHelper.h"
#import "SKIMTcpRequestHelper.h"

@implementation TcpReadPackage

+ (void)readPackgeData:(NSData *)packData
{
    GDataXMLDocument *xml = [[SKIMXMLUtils sharedXMLUtils] parseData:packData];
    if (xml == nil) {
        return;
    }
    NSDictionary *headInfos = [[SKIMXMLUtils sharedXMLUtils] getHeadInfo:xml];
    NSString *businessCode = [headInfos objectForKey:IM_XML_HEAD_BUSINESS_ATTR];
    BOOL isServer = [[headInfos objectForKey:IM_XML_HEAD_SOURCE_ATTR] isEqualToString:IM_XML_HEAD_SOURCE_SERVER_VALUE];
    
    if (isServer) {
        NSDictionary *bodyDic = nil;
        if (businessCode == nil || [businessCode isEqualToString:@""]) {
            NSDictionary *bodySparam = [[SKIMXMLUtils sharedXMLUtils] getBodySParam:xml];
            NSString *resultCode = [bodySparam objectForKey:IM_XML_BODY_RESULTCODE_ATTR];
            if ([resultCode isEqualToString:RETURN_CODE_SESSIOND_ERROR]) {
                [[SKIMTcpRequestHelper shareTcpRequestHelper] sendLogingPackageCommandId:TCP_LOGIN_COMMAND_ID];
                NSLog(@"SESSIONID不对");
            }
            
        } else if ([businessCode isEqualToString:BUSINESS_SERVER_MLOGINRET]) {
            bodyDic = [[SKIMXMLUtils sharedXMLUtils] getLoginBody:xml];
            NSString *resultCode = [bodyDic objectForKey:IM_XML_BODY_RESULTCODE_ATTR];
            if ([resultCode isEqualToString:RETURN_CODE_SUCCESS]) {
                [SKIMStatus sharedStatus].isLogin = YES;
                [SKIMStatus sharedStatus].sessionId = [bodyDic objectForKey:IM_XML_BODY_SESSIONID_ATTR];
            }
     
        } else if ([businessCode isEqualToString:BUSINESS_SERVER_SENDMSG]) {
            bodyDic = [[SKIMXMLUtils sharedXMLUtils] getServerSendMsgBody:xml];
            [bodyDic setValue:[headInfos objectForKey:IM_XML_HEAD_USERID_ATTR] forKey:IM_XML_HEAD_USERID_ATTR];
            [[SKIMMessageDataManager sharedMessageDataManager] receiveAndSaveMessage:bodyDic];
            NSLog(@"%@\n,%@", headInfos, bodyDic);
            
        } else if ([businessCode isEqualToString:BUSINESS_SERVER_MSENDMSGRET]) {
            bodyDic = [[SKIMXMLUtils sharedXMLUtils] getServerSendMsgRetBody:xml];
            NSString *resultCode = [bodyDic objectForKey:IM_XML_BODY_RESULTCODE_ATTR];
            [bodyDic setValue:[headInfos objectForKey:IM_XML_HEAD_INDEX_ATTR] forKey:IM_XML_HEAD_INDEX_ATTR];
            
            if ([resultCode isEqualToString:RETURN_CODE_SUCCESS]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSendMessageSuccess object:bodyDic];
            } else if ([resultCode isEqualToString:RETURN_CODE_SESSIOND_ERROR]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSendMessageFailed object:bodyDic];
                [SKIMStatus sharedStatus].isLogin = NO;
                [[SKIMTcpRequestHelper shareTcpRequestHelper] sendLogingPackageCommandId:TCP_LOGIN_COMMAND_ID];
                NSLog(@"发送消息时SESSIONID不对");
            }
            
            [[SKIMMessageDataManager sharedMessageDataManager] receiveSendMessageRet:bodyDic];
            NSLog(@"%@\n,%@", headInfos, bodyDic);
            
        } else if ([businessCode isEqualToString:BUSINESS_SERVER_RELOGIN]) {
            [SKIMStatus sharedStatus].isLogin = NO;
            [SKIMStatus sharedStatus].isReLoginByOther = YES;
            [SKIMStatus sharedStatus].sessionId = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiReLoginByOther object:nil];
            NSLog(@"用户已在其它地方重新登录");
        }
    }
    

    const void * dataBytes = (const void *) [packData bytes];
    NSString *body = [[NSString alloc] initWithBytes:dataBytes length:packData.length encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"body=%@", body);
}

+ (NSString *)dataFilePath:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:[fileName stringByAppendingString:@".xml"]];
    if (fileName || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    }
    return nil;
}
@end

