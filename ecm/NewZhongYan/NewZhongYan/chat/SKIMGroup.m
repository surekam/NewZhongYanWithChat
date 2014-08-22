//
//  SKIMGroup.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-15.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMGroup.h"
#import "SKIMGroupDBModel.h"

@implementation SKIMGroup

+ (SKIMGroup *)getGroupFromRid:(NSString *)rid
{
    if (rid == nil || rid.length == 0) {
        return nil;
    }
    SKIMGroupDBModel *groupModel = [[SKIMGroupDBModel alloc] init];
    groupModel.where = [NSString stringWithFormat:@"RID = %@", rid];
    NSArray *resultDics = [groupModel getList];
    if (resultDics == nil || resultDics.count != 1) {
        return nil;
    }
    
    return [SKIMGroupDBModel getGroupFromModel:resultDics[0]];
}

@end
