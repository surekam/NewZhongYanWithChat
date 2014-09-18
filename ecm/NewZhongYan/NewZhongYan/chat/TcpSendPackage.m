//
//  TcpSendPackage.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-28.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "TcpSendPackage.h"
#import "SKIMXMLUtils.h"
#import "SKIMSocketConfig.h"
#import "SKIMXMLConstants.h"
#import "SKIMStatus.h"

static unsigned long long sendIndex = 0;

@implementation TcpSendPackage

+ (NSString *)sendIndex
{
    if (sendIndex > 99999) {
        sendIndex = 0;
    }
    return [NSString stringWithFormat:@"%llu", sendIndex++];
}

// 创建登录对象
+ (NSData *)createLoginPackage{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  IM_XML_HEAD_SOURCE_MOBILE_VALUE,  IM_XML_HEAD_SOURCE_ATTR,
                                  IM_XML_HEAD_BUSINESS_LOGIN_VALUE, IM_XML_HEAD_BUSINESS_ATTR,
                                  @"",                              IM_XML_HEAD_SESSIONID_ATTR,
                                  @"",                              IM_XML_HEAD_USERID_ATTR,
                                  [self sendIndex],                 IM_XML_HEAD_INDEX_ATTR,
                                   
                                  [APPUtils loggedUser].uid,        IM_XML_BODY_LOGIN_USERID_ATTR,
                                  [APPUtils loggedUser].password,   IM_XML_BODY_LOGIN_USERPSW_ATTR, nil];
    
//    GDataXMLDocument *loginXml = [[SKIMXMLUtils sharedXMLUtils] buildLoginXML:params];
//    NSString *filePath = [self dataFilePath:@"login"];
//    NSLog(@"Saving xml data to %@...", filePath);
//    [[loginXml XMLData] writeToFile:filePath atomically:YES];
    NSData *packageBody = [[[SKIMXMLUtils sharedXMLUtils] buildLoginXML:params] XMLData];
    NSData *packageData = [self createPackageWithBody:packageBody];
    return packageData;
}

+ (NSData *)createMessagePackageWithMsg:(NSString *)message toUser:(NSString*)toUser msgType:(NSString *)msgType bySendIndex:(NSString **)sendIndex
{
    *sendIndex = [self sendIndex];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   IM_XML_HEAD_SOURCE_MOBILE_VALUE,     IM_XML_HEAD_SOURCE_ATTR,
                                   IM_XML_HEAD_BUSINESS_SENDMSG_VALUE,  IM_XML_HEAD_BUSINESS_ATTR,
                                   [SKIMStatus sharedStatus].sessionId, IM_XML_HEAD_SESSIONID_ATTR,
                                   *sendIndex,                          IM_XML_HEAD_INDEX_ATTR,
                                   [APPUtils loggedUser].uid,           IM_XML_BODY_LOGIN_USERID_ATTR,
                                   
                                   toUser,                              IM_XML_BODY_SENDMSG_TOUSER_ATTR,
                                   msgType,                             IM_XML_BODY_SENDMSG_MSGTYPE_ATTR,
                                   message,                             IM_XML_BODY_SENDMSG_CONTENT_ATTR, nil];
    
    NSData *packageBody = [[[SKIMXMLUtils sharedXMLUtils] buildSendMsgXML:params] XMLData];
    NSLog(@"sendMessage=%@", [NSString stringWithUTF8String:[packageBody bytes]]);
    NSData *packageData = [self createPackageWithBody:packageBody];
    return packageData;
}

// 创建注销包对象
+(id) createLogoutPackage{
    return nil;
}
// 创建消息对象


+ (NSString *)dataFilePath:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:[fileName stringByAppendingString:@".xml"]];
    if (fileName || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    }
    return nil;
}

+ (NSData *)createPackageWithBody:(NSData *)packageBody
{
    UInt8 buffer[HeadLen];
    NSUInteger bodyLength = 0;

    //|UTF8String|返回是包含\0的  |lengthOfBytesUsingEncoding|计算不包括\0
    memcpy(buffer, [ZYIM UTF8String], [ZYIM lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    if (packageBody) {
        bodyLength = packageBody.length;
    }

    NSString *pkgLen = [NSString stringWithFormat:@"%4lu", (unsigned long)bodyLength];
    
    memcpy(&buffer[4], [pkgLen UTF8String], [pkgLen lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    memcpy(&buffer[8], [EncryptFlag UTF8String], [EncryptFlag lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    memcpy(&buffer[12], [ReservedField UTF8String], [ReservedField lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    NSData *headData = [NSData dataWithBytes:buffer length:16];
    NSMutableData *pkgData = [NSMutableData data];
    [pkgData appendData:headData];
    [pkgData appendData:packageBody];
    return pkgData;
}
@end
