//
//  ElectricUserMonthTrendDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ElectricUserMonthTrendDataModel.h"
@implementation ElectricUserMonthTrendDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"elecPrice" : [ElecPrice class]};
}
@end
