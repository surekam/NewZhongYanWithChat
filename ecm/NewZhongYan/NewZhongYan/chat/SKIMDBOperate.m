//
//  SKIMDBOperate.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-22.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKIMDBOperate.h"
#import "FileManager.h"
#import "SKIMDBConfig.h"

@implementation SKIMDBOperate

//创建表
+(BOOL)createTable
{
    //获取所有的表字典
    NSDictionary *tableDic = [SKIMDBConfig getDBTablesDic];
    
	NSString *dbFilePath=[FileManager getFileDBPath:IMDataBaseFileName];
	NSLog(@"dbFilePath:---------------- %@",dbFilePath);
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		for (id key in [tableDic allKeys])
        {
			NSString *checkTableSQL = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",key];
			FMResultSet *rs = [db executeQuery:checkTableSQL];
			if (![rs next]) {
				[db executeUpdate:[tableDic objectForKey:key]];
			}
		}
		
	}
	[db close];
	return YES;
}

@end
