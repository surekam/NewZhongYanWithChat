//
//  SKIMUserDBModel.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-22.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMBaseDBModel.h"
@class SKIMUser;

@interface SKIMUserDBModel : SKIMBaseDBModel

//将SKIMBaseDBModel转换为SKIMUser
+ (SKIMUser *)getUserFromModel:(NSDictionary *)modelDic;

+ (SKIMUser *)getUserInfo:(SKIMUser *)user;

@end
