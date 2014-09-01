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

@implementation TcpReadPackage

+ (void)readPackgeData:(NSData *)packData
{
    GDataXMLDocument *xml = [[SKIMXMLUtils sharedXMLUtils] parseData:packData];
    if (xml == nil) {
        return;
    }
    NSDictionary *headInfos = [[SKIMXMLUtils sharedXMLUtils] getHeadInfo:xml];
    NSString *businessCode = [headInfos objectForKey:IM_XML_HEAD_BUSINESS_ATTR];
    
    if (businessCode) {
        if ([businessCode isEqualToString:BUSINESS_MLOGINRET]) {
            
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

