//
//  SKIMXMLUtils.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface SKIMXMLUtils : NSObject
+ (SKIMXMLUtils *)sharedXMLUtils;

//构造xml头
- (GDataXMLElement *)buildHeaderElement:(NSMutableDictionary *)params;

//1.构造登录xml
- (GDataXMLDocument *)buildLoginXML:(NSMutableDictionary *)params;

//2.解析登录返回xml

//3.构造发送的消息xml
- (GDataXMLDocument *)buildSendMsgXML:(NSMutableDictionary *)params;

//4.解析发送消息之后返回的xml

//5.构造发送群消息的xml
- (GDataXMLDocument *)buildSendGMsgXML:(NSMutableDictionary *)params;

//6.解析发送群消息之后返回的xml

//7.构造获取用户消息条数的xml

//8.解析获取用户消息条数的返回的xml

//9.构造获取某对象消息的xml

//10.解析获取对象消息之后返回的xml

//11.构造用户个性签名xml

//12.解析用户个性签名返回的xml

//13.构造用户个性图标的xml

//14.解析用户个性图标返回的xml

//15.构造获取用户信息的xml

//16.解析返回的用户信息的xml

//解析数据包 返回xml
- (GDataXMLDocument *)parseData:(NSData *)data;

- (NSDictionary *)getHeadInfo:(GDataXMLDocument *)xml;

- (NSDictionary *)getLoginBody:(GDataXMLDocument *)xml;

- (NSDictionary *)getServerSendMsgBody:(GDataXMLDocument *)xml;
@end
