//
//  RechargeRecordDataModel.m
//  autolayoutTest
//
//  Created by 刘欣 on 16/12/15.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import "RechargeRecordDataModel.h"

@implementation RechargeRecordDataModel

@end
@implementation RechargeRecordForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [RechargeRecordList class]};
}

@end


@implementation RechargeRecordList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end


