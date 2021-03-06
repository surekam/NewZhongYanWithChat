//
//  SKIMXMLUtils.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMXMLUtils.h"
#import "GDataXMLNode.h"
#import "SKIMXMLConstants.h"

SKIMXMLUtils *SharedInstance;

@implementation SKIMXMLUtils
+(SKIMXMLUtils *)sharedXMLUtils
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (SharedInstance == nil) {
            SharedInstance = [[SKIMXMLUtils alloc] init];
        }
    });
    
    return SharedInstance;
}

-(GDataXMLElement *)buildHeaderElement:(NSMutableDictionary *)params
{
    GDataXMLElement *headerElement = [GDataXMLNode elementWithName:IM_XML_HEAD_NODE_NAME];
    
    GDataXMLElement *sourceElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:IM_XML_HEAD_SOURCE_MOBILE_VALUE];
    GDataXMLElement *businessElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_HEAD_BUSINESS_ATTR]];
    GDataXMLElement *sessionidElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_HEAD_SESSIONID_ATTR]];
    GDataXMLElement *useridElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_HEAD_USERID_ATTR]];
    GDataXMLElement *indexElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_HEAD_INDEX_ATTR]];
    
    [sourceElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_HEAD_SOURCE_ATTR]];
    [businessElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_HEAD_BUSINESS_ATTR]];
    [sessionidElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_HEAD_SESSIONID_ATTR]];
    [useridElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_HEAD_USERID_ATTR]];
    [indexElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_HEAD_INDEX_ATTR]];
    
    [headerElement addChild:sourceElement];
    [headerElement addChild:businessElement];
    [headerElement addChild:sessionidElement];
    [headerElement addChild:useridElement];
    [headerElement addChild:indexElement];
    
    return headerElement;
}

-(GDataXMLDocument *)buildLoginXML:(NSMutableDictionary *)params
{
    [params setObject:IM_XML_HEAD_BUSINESS_LOGIN_VALUE forKey:IM_XML_HEAD_BUSINESS_ATTR];
    
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:IM_XML_ROOT_NODE_NAME];
    [rootElement addChild:[self buildHeaderElement:params]];
    
    GDataXMLElement *bodyElement = [GDataXMLNode elementWithName:IM_XML_BODY_NODE_NAME];
    GDataXMLElement *sparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_SINGLE_NODE_NAME];
    GDataXMLElement *mparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_MULTI_NODE_NAME];
    
    GDataXMLElement *versionElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:IM_XML_BODY_VERSION_VALUE];
    GDataXMLElement *useridElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_LOGIN_USERID_ATTR]];
    GDataXMLElement *userpswElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_LOGIN_USERPSW_ATTR]];
    
    [versionElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_VERSION_ATTR]];
    [useridElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_LOGIN_USERID_ATTR]];
    [userpswElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_LOGIN_USERPSW_ATTR]];
    
    [sparamElement addChild:versionElement];
    [sparamElement addChild:useridElement];
    [sparamElement addChild:userpswElement];
    
    [bodyElement addChild:sparamElement];
    [bodyElement addChild:mparamElement];
    
    [rootElement addChild:bodyElement];
    
    GDataXMLDocument *loginXml = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    [loginXml setCharacterEncoding:XML_ENCODING];
    return loginXml;
}

-(GDataXMLDocument *)buildSendMsgXML:(NSMutableDictionary *)params
{
    [params setObject:IM_XML_HEAD_BUSINESS_SENDMSG_VALUE forKey:IM_XML_HEAD_BUSINESS_ATTR];
    
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:IM_XML_ROOT_NODE_NAME];
    [rootElement addChild:[self buildHeaderElement:params]];
    
    GDataXMLElement *bodyElement = [GDataXMLNode elementWithName:IM_XML_BODY_NODE_NAME];
    GDataXMLElement *sparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_SINGLE_NODE_NAME];
    GDataXMLElement *mparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_MULTI_NODE_NAME];
    
    GDataXMLElement *versionElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:IM_XML_BODY_VERSION_VALUE];
    GDataXMLElement *touserElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_SENDMSG_TOUSER_ATTR]];
    GDataXMLElement *contentElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_SENDMSG_CONTENT_ATTR]];
    
    [versionElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_VERSION_ATTR]];
    [touserElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_SENDMSG_TOUSER_ATTR]];
    [contentElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_SENDMSG_CONTENT_ATTR]];
    
    [sparamElement addChild:versionElement];
    [sparamElement addChild:touserElement];
    [sparamElement addChild:contentElement];
    
    [bodyElement addChild:sparamElement];
    [bodyElement addChild:mparamElement];
    
    [rootElement addChild:bodyElement];
    
    GDataXMLDocument *sendMsgXml = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    [sendMsgXml setCharacterEncoding:XML_ENCODING];
    
    return sendMsgXml;
}

-(GDataXMLDocument *)buildSendGMsgXML:(NSMutableDictionary *)params
{
    [params setObject:IM_XML_HEAD_BUSINESS_SENDGMSG_VALUE forKey:IM_XML_HEAD_BUSINESS_ATTR];
    
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:IM_XML_ROOT_NODE_NAME];
    [rootElement addChild:[self buildHeaderElement:params]];
    
    GDataXMLElement *bodyElement = [GDataXMLNode elementWithName:IM_XML_BODY_NODE_NAME];
    GDataXMLElement *sparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_SINGLE_NODE_NAME];
    GDataXMLElement *mparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_MULTI_NODE_NAME];
    
    GDataXMLElement *versionElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:IM_XML_BODY_VERSION_VALUE];
    GDataXMLElement *toclubElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_SENDGMSG_TOCLUB_ATTR]];
    GDataXMLElement *contentElement = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_SENDGMSG_CONTENT_ATTR]];
    
    [versionElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_VERSION_ATTR]];
    [toclubElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_SENDGMSG_TOCLUB_ATTR]];
    [contentElement addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_SENDGMSG_CONTENT_ATTR]];
    
    [sparamElement addChild:versionElement];
    [sparamElement addChild:toclubElement];
    [sparamElement addChild:contentElement];
    
    [bodyElement addChild:sparamElement];
    [bodyElement addChild:mparamElement];
    
    [rootElement addChild:bodyElement];
    
    GDataXMLDocument *sendGMsgXml = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    [sendGMsgXml setCharacterEncoding:XML_ENCODING];
    
    return sendGMsgXml;
}

- (GDataXMLDocument *)buildGetMsgCountXML:(NSMutableDictionary *)params {
    
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:IM_XML_ROOT_NODE_NAME];
    [rootElement addChild:[self buildHeaderElement:params]];
    
    GDataXMLElement *bodyElement = [GDataXMLNode elementWithName:IM_XML_BODY_NODE_NAME];
    GDataXMLElement *sparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_SINGLE_NODE_NAME];
    GDataXMLElement *mparamElement = [GDataXMLNode elementWithName:IM_XML_PARAM_MULTI_NODE_NAME];
    
    GDataXMLElement *messageId = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_GETMSGCOUNT_MESSAGEID_ATTR]];
    GDataXMLElement *clubMessageid = [GDataXMLNode elementWithName:IM_XML_BASE_NODE_NAME stringValue:params[IM_XML_BODY_GETMSGCOUNT_CLUBMESSAGEID_ATTR]];
    
    [messageId addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_GETMSGCOUNT_MESSAGEID_ATTR]];
    [clubMessageid addAttribute:[GDataXMLNode attributeWithName:IM_XML_BASE_ATTR_NAME stringValue:IM_XML_BODY_GETMSGCOUNT_CLUBMESSAGEID_ATTR]];
    
    [sparamElement addChild:messageId];
    [sparamElement addChild:clubMessageid];
    
    [bodyElement addChild:sparamElement];
    [bodyElement addChild:mparamElement];
    
    [rootElement addChild:bodyElement];
    
    GDataXMLDocument *getMsgCountXml = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    [getMsgCountXml setCharacterEncoding:XML_ENCODING];
    
    return getMsgCountXml;
}

-(GDataXMLDocument *)parseData:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
    
    return xml;
}

-(NSDictionary *)getHeadInfo:(GDataXMLDocument *)xml
{
    NSMutableDictionary *headInfo = [NSMutableDictionary dictionary];
    if (xml) {
        GDataXMLElement *rootElement = [xml rootElement];
        GDataXMLElement *headElement = [rootElement elementsForName:IM_XML_HEAD_NODE_NAME][0];
        NSArray *headInfos = [headElement elementsForName:IM_XML_BASE_NODE_NAME];
        for (GDataXMLElement *info in headInfos) {
            [headInfo setObject:[info stringValue] forKey:[[info attributeForName:IM_XML_BASE_ATTR_NAME] stringValue]];
        }
    }
    return headInfo;
}

-(NSDictionary *)getLoginBody:(GDataXMLDocument *)xml
{
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
    if (xml) {
        [bodyDic setDictionary:[self getBodySParam:xml]];
    }
    return [bodyDic copy];
}

- (NSDictionary *)getServerSendMsgBody:(GDataXMLDocument *)xml
{
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
    if (xml) {
        [bodyDic setDictionary:[self getBodySParam:xml]];
    }
    return [bodyDic copy];
}

- (NSDictionary *)getServerSendMsgRetBody:(GDataXMLDocument *)xml
{
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
    if (xml) {
        [bodyDic setDictionary:[self getBodySParam:xml]];
    }
    return [bodyDic copy];
}

- (NSDictionary *)getServerGetMsgCountRetBody:(GDataXMLDocument *)xml
{
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
    if (xml) {
        [bodyDic setDictionary:[self getBodySParam:xml]];
        [bodyDic setObject:[self getBodyMParam:xml] forKey:BUSINESS_SERVER_MGETMSGCOUNTRET];
    }
    return [bodyDic copy];

}

- (NSDictionary *)getBodySParam:(GDataXMLDocument *)xml
{
    NSMutableDictionary *bodySParamDic = [NSMutableDictionary dictionary];
    if (xml) {
        GDataXMLElement *rootElement = [xml rootElement];
        GDataXMLElement *bodyElement = [rootElement elementsForName:IM_XML_BODY_NODE_NAME][0];
        GDataXMLElement *bodySparamElement = [bodyElement elementsForName:IM_XML_PARAM_SINGLE_NODE_NAME][0];
        NSArray *bodyInfos = [bodySparamElement elementsForName:IM_XML_BASE_NODE_NAME];
        for (GDataXMLElement *bodyInfo in bodyInfos) {
            [bodySParamDic setObject:[bodyInfo stringValue] forKey:[[bodyInfo attributeForName:IM_XML_BASE_ATTR_NAME] stringValue]];
        }
    }
    return [bodySParamDic copy];
}

- (NSArray *)getBodyMParam:(GDataXMLDocument *)xml
{
    NSMutableArray *bodyMParams = [NSMutableArray array];
    if (xml) {
        GDataXMLElement *rootElement = [xml rootElement];
        GDataXMLElement *bodyElement = [rootElement elementsForName:IM_XML_BODY_NODE_NAME][0];
        GDataXMLElement *bodyMparamElement = [bodyElement elementsForName:IM_XML_PARAM_MULTI_NODE_NAME][0];
        NSArray *multiLines = [bodyMparamElement elementsForName:IM_XML_PARAM_MULIT_LINE_NODE_NAME];
        for (GDataXMLElement *line in multiLines) {
            NSArray *lineInfos = [line elementsForName:IM_XML_BASE_NODE_NAME];
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            for (GDataXMLElement *lineInfo in lineInfos) {
                [paramDic setObject:[lineInfo stringValue] forKey:[[lineInfo attributeForName:IM_XML_BASE_ATTR_NAME] stringValue]];
            }
            [bodyMParams addObject:paramDic];
        }
    }
    return [bodyMParams copy];
}
@end
