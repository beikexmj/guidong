//
//  CopoooDBManager.h
//  copooo
//
//  Created by XiaMingjiang on 2018/6/26.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CopoooDBDataModel.h"
@interface CopoooDBManager : NSObject
+(void)initDB;//初始化db
/**
 *获取PDF信息
 */
+(NSArray<CopoooDBDataModel *>* )fetchDB:(NSInteger)type;
/**
 *查看单个数据是否存在于表中
 */
+(BOOL)searchDB:(NSString *)name type:(NSInteger)type;
/**
 *插入信息
 *@param data 信息data
 */
+(void)saveDB:(CopoooDBDataModel *)model;
/**
 *删除单条数据
 *@param name 名称
 *@param contactId 类型
 */
+(void)deleteDB:(NSString *)name contactId:(NSInteger)type;
/**
 *删除某种类型下所有数据
 *@param type 类型
 */
+(void)deleteDB:(NSInteger)type;
/**
 *删除所有数据
 */
+(void)deleteDB;
@end
