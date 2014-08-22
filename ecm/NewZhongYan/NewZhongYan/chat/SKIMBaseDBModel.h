//
//  SKIMBaseDBModel.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-11.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface SKIMBaseDBModel : NSObject
{
    
    FMDatabase *db;
    NSString *dbFilePath;
    NSString *tableName;
    NSString *_where;
    NSString *_orderBy;
    NSString *_orderType;
    int _limit;
    
}

@property (nonatomic, strong) NSString *where;
@property (nonatomic, strong) NSString *orderBy;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, assign) int limit;

+(BOOL)updateDataWithModel:(SKIMBaseDBModel *)listGeter withDic:(NSDictionary *)dic;

//获取列表 支持条件 条数 排序
-(NSMutableArray *)getList;

//插入数据 成功则返回插入ID 失败则返回 0
-(int)insertDB:(NSDictionary *)data;

//更新记录 支持条件更新
-(BOOL)updateDB:(NSDictionary *)data;

//删除记录 支持条件更新
-(BOOL)deleteDBdata;

//执行sql语句 用于查询
-(NSMutableArray *)querSelectSql:(NSString *)sql;

//执行sql语句 用于更新,删除
-(BOOL)queryUpdateSql:(NSString *)sql;

@end
