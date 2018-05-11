//
//  ElectricUserQueryOtherByDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ElectricUserQueryOtherByDataModel.h"

@implementation ElectricUserQueryOtherByDataModel

@end


@implementation ElectricUserQueryOtherByData
+ (NSDictionary *)objectClassInArray{
    return @{@"elecPrice" : [ElecPrice class]};
}

@end

@implementation HistoryContrastMonth
+ (NSDictionary *)objectClassInArray{
    return @{@"an" : [An class],@"mon":[Mon class]};
}

@end

@implementation HistoryContrastYear
+ (NSDictionary *)objectClassInArray{
    return @{@"an" : [An class],@"mon":[Mon class]};
}

@end

@implementation HistoryContrastQuarter

@end

@implementation HistoryContrastQuarterMon

@end

@implementation HistoryContrastQuarterAn

@end

@implementation HistoryContrast

@end

@implementation ElecPrice

+ (NSDictionary *)objectClassInArray{
    return @{@"type" : [ElecPriceTypeAndLadder class],@"ladder":[ElecPriceTypeAndLadder class]};
}

@end
@implementation An

@end

@implementation Mon

@end
@implementation ElecPriceTypeAndLadder

@end
