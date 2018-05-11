//
//  ElectricityCardHistoryListDataModel.m
//  copooo
//
//  Created by 夏明江 on 16/9/21.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityCardHistoryListDataModel.h"

@implementation ElectricityCardHistoryListDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [ElectricityCardHistoryListForm class]};
}
@end
@implementation ElectricityCardHistoryListForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ElectricityCardHistoryList class]};
}

@end


@implementation ElectricityCardHistoryList

@end


