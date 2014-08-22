//
//  SKIMConversationDBModel.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-11.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMBaseDBModel.h"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

@interface SKIMConversationDBModel : SKIMBaseDBModel

//将查询的结果集转换为对象数组
+ (NSArray *)getConversationsFromModelArray:(NSArray *)modelArray;

@end
