//
//  PointRuleListDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/11.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "PointRuleListDataModel.h"

@implementation PointRuleListDataModel
@end
@implementation PointRuleListForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [PointRuleListList class]};
}

@end


@implementation PointRuleListList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
