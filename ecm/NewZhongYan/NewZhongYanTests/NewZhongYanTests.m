//
//  NewZhongYanTests.m
//  NewZhongYanTests
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "NewZhongYanTests.h"
#import "SKIMTcpHelper.h"
#import "SKIMTcpRequestHelper.h"
#import "DDXMLNode.h"
#import "RegExCategories.h"

@interface NewZhongYanTests () 
{
    SKIMTcpHelper *tcpHelper;
    SKIMTcpRequestHelper *tcpRequestHelper;
}
@end


@implementation NewZhongYanTests

- (void)setUp
{
    [super setUp];
    tcpHelper = [SKIMTcpHelper shareChatTcpHelper];
    tcpRequestHelper = [SKIMTcpRequestHelper shareTcpRequestHelper];
    
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in NewZhongYanTests");
}


- (void)testLogin
{
    if ([tcpHelper connectToHost]) {
        [tcpRequestHelper sendLogingPackageCommandId:0];
    }
}

- (void)test_datetime {
    
    NSString *dateTime = @"2014-09-18 16:40:04";
    NSDate *date = [DateUtils stringToDate:dateTime DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"date=%@", date);
}

- (void)test_regx {
    
    NSString *regx = @"/\\{\\{.+/\\}\\}";
    NSString *str = @"FHA/{{adfads.png/}}asdfa";
    NSArray *matchs = [str matchesWithDetails:RX(regx)];
    for (RxMatch *match in matchs) {
        NSLog(@"matched value = (%@), matched range = (%d, %d)", match.value, match.range.location, match.range.length);
    }
}

@end
