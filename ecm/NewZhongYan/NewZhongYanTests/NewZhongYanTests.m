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
@end
