//
//  SKIMGroupDBModel.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-22.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMBaseDBModel.h"
#import "SKIMGroup.h"

@interface SKIMGroupDBModel : SKIMBaseDBModel

//将SKIMGroupDBModel转换为SKIMGroup
+ (SKIMGroup *)getGroupFromModel:(NSDictionary *)modelDic;

@end
