//
//  ElectricityCardDataModel.m
//  copooo
//
//  Created by 夏明江 on 16/9/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityCardDataModel.h"

@implementation ElectricityCardDataModel

@end
@implementation ElectricityCardForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ElectricityCardList class]};
}

@end


@implementation ElectricityCardList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end


