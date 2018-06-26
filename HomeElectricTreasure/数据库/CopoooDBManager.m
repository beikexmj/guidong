//
//  CopoooDBManager.m
//  copooo
//
//  Created by XiaMingjiang on 2018/6/26.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import "CopoooDBManager.h"
#import "FMDatabase.h"
#import "CopoooDBDataModel.h"
static NSString *dbPath = nil;

@implementation CopoooDBManager

+ (void)initDB {
    //创建数据库
    NSArray *paths = nil;
    NSString *documentsDirectory = nil;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    [CopoooDBManager createDBByPath:[NSString stringWithFormat:@"%@/copooo.db", documentsDirectory]];
}
/**
 *  创建数据库
 *
 *  @param path db路径
 *
 */
+ (void)createDBByPath:(NSString *)path {
    dbPath = path;
    NSDictionary *attributes = @{NSFileProtectionKey: NSFileProtectionNone};
    NSError *error;
    [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:path error:&error];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        //创建表
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE  IF NOT EXISTS '%@' ('usreId' VARCHAR, 'name' VARCHAR, 'type' INTEGER, 'time' LONGLONG )", KCopoooDBTable];
        [db executeUpdate:createTable];
        [db close];
    }
}


/**
 *获取PDF信息
 */
+(NSArray<CopoooDBDataModel *>* )fetchDB:(NSInteger)type {
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE type = %ld ",KCopoooDBTable,type];
        FMResultSet *s = [db executeQuery:querySql];
        NSMutableArray *arr = [NSMutableArray array];
        while (s.next) {
            CopoooDBDataModel *model = [[CopoooDBDataModel alloc] init];
            model.usreId = [s stringForColumn:@"usreId"] ? [s stringForColumn:@"usreId"] : @"";
            model.name = [s stringForColumn:@"name"] ? [s stringForColumn:@"name"] : @"";
            model.time = [s longLongIntForColumn:@"time"];
            model.type = [s intForColumn:@"type"];
            [arr addObject:model];
        }
        [s close];
        [db close];
        return arr;
    }
    return nil;
}
/**
 *查看单个数据是否存在于表中
 */
+(BOOL)searchDB:(NSString *)name type:(NSInteger)type{//=YES有；== NO 无
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE type = %ld AND name = '%@' ",KCopoooDBTable,type,name];
        FMResultSet *s = [db executeQuery:querySql];
        if (s.next) {
            [s close];
            [db close];
            return YES;
        }
        return NO;
    }
    return NO;
}


/**
 *插入信息
 *@param data 信息data
 */
+(void)saveDB:(CopoooDBDataModel *)model{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('userId','name','time','type') VALUES (?,?,?,?)", KCopoooDBTable];
        [db executeUpdate:insertSql, model.usreId, model.name, @(model.time),@(model.type)];
        [db close];
    }
}
/**
 *删除单条数据
 *@param name 名称
 *@param contactId 类型
 */
+(void)deleteDB:(NSString *)name contactId:(NSInteger)type{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE  name = '%@' AND type = %ld", KCopoooDBTable,name,type];
        [db executeUpdate:deleteSql];
    }
    [db close];
}
/**
 *删除某种类型下所有数据
 *@param type 类型
 */
+(void)deleteDB:(NSInteger)type{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE type = %ld", KCopoooDBTable,type];
        [db executeUpdate:deleteSql];
    }
    [db close];
}
/**
 *删除所有数据
 */
+(void)deleteDB{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@'", KCopoooDBTable];
        [db executeUpdate:deleteSql];
    }
    [db close];
}
@end
