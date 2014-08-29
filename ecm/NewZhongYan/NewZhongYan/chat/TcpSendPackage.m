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

static unsigned long long sendIndex = 0;

@implementation TcpSendPackage

+ (NSString *)sendIndex
{
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
    UInt32 bodyLength = 0;

    //|UTF8String|返回是包含\0的  |lengthOfBytesUsingEncoding|计算不包括\0
    memcpy(buffer, [ZYIM UTF8String], [ZYIM lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    if (packageBody) {
        bodyLength = packageBody.length;
    }
    UInt32 *pkgLen =(UInt32 *) &buffer[4];
    *pkgLen = htonl(bodyLength);
    
    memcpy(&buffer[8], [EncryptFlag UTF8String], [EncryptFlag lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    memcpy(&buffer[12], [ReservedField UTF8String], [ReservedField lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    for (int i = 0; i < HeadLen; i ++) {
        if (buffer[i] == '\0') {
            buffer[i] = 32;
        }
    }
    
    NSData *headData = [NSData dataWithBytes:buffer length:16];
    NSMutableData *pkgData = [NSMutableData data];
    [pkgData appendData:headData];
    [pkgData appendData:packageBody];
    return  pkgData;
    
//    void *headBytes = malloc(sizeof(Byte)* HeadLen);
//    UInt32 bodyLength = 0;
//    memcpy(headBytes, [ZYIM UTF8String], [ZYIM lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
//    
//    if (packageBody) {
//        bodyLength = packageBody.length;
//    }
//    void *pkgLenBytes = malloc(sizeof(Byte)* 4);
//    UInt32 *pkgLen =(UInt32 *) &pkgLenBytes[4];
//    *pkgLen = htonl(bodyLength);
//    
//    memcpy(&headBytes[4], pkgLenBytes, 4);
//    
//    memcpy(&headBytes[8], [EncryptFlag UTF8String], [EncryptFlag lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
//    
//    memcpy(&headBytes[12], [ReservedField UTF8String], [ReservedField lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
//    
//    NSData *headData = [NSData dataWithBytes:headBytes length:HeadLen];
//    NSMutableData *pkgData = [NSMutableData data];
//    [pkgData appendData:headData];
//    [pkgData appendData:packageBody];
//    free(pkgLenBytes);
//    free(headBytes);
//    return  pkgData;

}
@end