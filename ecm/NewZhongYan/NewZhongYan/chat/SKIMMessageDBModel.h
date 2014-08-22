//
//  SKIMMessageDBModel.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-14.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKIMBaseDBModel.h"

@interface SKIMMessageDBModel : SKIMBaseDBModel

//将查询的结果集转换为对象数组
+ (NSArray *)getMessagesFromModelArray:(NSArray *)modelArray;

@end
