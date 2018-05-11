//
//  BalanceDetailDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/15.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "BalanceDetailDataModel.h"

@implementation BalanceDetailDataModel

@end

@implementation BalanceDetailForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [BalanceDetailDataList class],@"year":[NSArray class]};
}

@end


@implementation BalanceDetailDataList
+ (NSDictionary *)objectClassInArray{
    return @{@"detail" : [BalanceDetailDataListList class]};
}

@end
@implementation BalanceDetailDataListList

@end
