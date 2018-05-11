//
//  ElectricUserPointTrendDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricUserPointTrendData,PointTrendMonth,PointTrendQuarter,PointTrendYear,RealData,PredictionData,QuarterData,YearData;

@interface ElectricUserPointTrendDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ElectricUserPointTrendData *form;

@end

@interface ElectricUserPointTrendData : NSObject

@property (nonatomic, strong) PointTrendMonth *pointTrendMonth;
@property (nonatomic, strong) PointTrendQuarter *pointTrendQuarter;
@property (nonatomic, strong) PointTrendYear *pointTrendYear;


@end

@interface PointTrendMonth : NSObject

@property (nonatomic, copy) NSString *totalElecSum;

@property (nonatomic, copy) NSString *totalElecPrice;

@property (nonatomic, copy) NSArray<RealData *> *realData;
@property (nonatomic, copy) NSArray<PredictionData *> *predictionData;
@property (nonatomic, copy) NSString *currentDate;

@end
@interface RealData : NSObject

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *data;

@end

@interface PredictionData : NSObject

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *data;

@end

@interface PointTrendQuarter : NSObject

@property (nonatomic, copy) NSString *totalElecSum;

@property (nonatomic, copy) NSString *totalElecPrice;

@property (nonatomic, copy) NSArray<QuarterData *> *data;

@property (nonatomic, copy) NSString *currentDate;

@property (nonatomic, copy) NSString *an;

@property (nonatomic, copy) NSString *anDate;

@property (nonatomic, copy) NSString *mom;

@property (nonatomic, copy) NSString *momDate;

@end

@interface QuarterData : NSObject

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *elecSum;

@property (nonatomic, copy) NSString *elecFree;

@property (nonatomic, copy) NSString *quarter;

@property (nonatomic, copy) NSString *year;


@end

@interface PointTrendYear : NSObject

@property (nonatomic, copy) NSString *totalElecSum;

@property (nonatomic, copy) NSString *totalElecPrice;

@property (nonatomic, copy) NSArray<YearData *> *data;

@property (nonatomic, copy) NSString *currentDate;

@end

@interface YearData : NSObject

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *data;

@property (nonatomic, copy) NSString *an;

@property (nonatomic, copy) NSString *anDate;

@property (nonatomic, copy) NSString *mom;

@property (nonatomic, copy) NSString *momDate;


@end
