//
//  SKIMGroup.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-15.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKIMChater.h"

@interface SKIMGroup : NSObject<SKIMChater>

/*!
 @property
 @brief 群组RID
 */
@property (nonatomic, copy) NSString *rid;

/*!
 @property
 @brief 群组ID
 */
@property (nonatomic, copy) NSString *groupId;

/*!
 @property
 @brief 群组名
 */
@property (nonatomic, copy) NSString *groupName;

/*!
 @property
 @brief 群头像
 */
@property (nonatomic, copy) NSString *groupAvatarUri;

+ (SKIMGroup *)getGroupFromRid:(NSString *)rid;

@end
