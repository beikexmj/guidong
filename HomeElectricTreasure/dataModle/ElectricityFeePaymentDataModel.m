//
//  ElectricityFeePaymentDataModel.m
//  copooo
//
//  Created by 夏明江 on 16/9/19.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityFeePaymentDataModel.h"

@implementation ElectricityFeePaymentDataModel

@end


@implementation ElectricityFeePaymentForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ElectricityFeePaymentList class]};
}

@end


@implementation ElectricityFeePaymentList

+ (NSDictionary *)objectClassInArray{
    return @{@"ElectricInfoList" : [Electricinfolist class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end


@implementation Electricinfolist

@end


@implementation Electricstepinfo

@end


