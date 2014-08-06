//
//  SKIMMessage.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-5.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMMessage.h"
@protocol ISKIMMessageBody;

@implementation SKIMMessage

- (id)initWithReceiver:(NSString *)receiver
                bodies:(NSArray *)bodies
{
    return nil;
}

- (NSArray *)addMessageBody:(id<ISKIMMessageBody>)body
{
    return nil;
}

- (NSArray *)removeMessageBody:(id<ISKIMMessageBody>)body
{
    return nil;
}
@end
