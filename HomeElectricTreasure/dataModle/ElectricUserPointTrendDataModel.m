//
//  ElectricUserPointTrendDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ElectricUserPointTrendDataModel.h"

@implementation ElectricUserPointTrendDataModel

@end

@implementation ElectricUserPointTrendData

@end

@implementation PointTrendMonth
+ (NSDictionary *)objectClassInArray{
    return @{@"realData" : [RealData class],@"predictionData":[PredictionData class]};
}

@end

@implementation PointTrendQuarter
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [QuarterData class]};
}


@end

@implementation PointTrendYear
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [YearData
 class]};
}

@end

@implementation RealData

@end

@implementation PredictionData

@end

@implementation QuarterData

@end

@implementation YearData

@end
