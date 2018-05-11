//
//  ElectricityFeePaymentLogModel.m
//  copooo
//
//  Created by 夏明江 on 16/9/21.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityBillPayInfoModel.h"

@implementation ElectricityBillPayInfoModel

@end

@implementation ElectricityBillPayInfoForm
+ (NSDictionary *)objectClassInArray{
    return @{@"spendableVoucher" : [SpendableVoucher class]};
}

@end

@implementation SpendableVoucher
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
