//
//  ElectricUserMonthTrendDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectricUserPointTrendDataModel.h"
#import "ElectricUserQueryOtherByDataModel.h"
@interface ElectricUserMonthTrendDataModel : NSObject

@property (nonatomic, strong) PointTrendMonth *pointTrendMonth;

@property (nonatomic, strong) ElecPrice *elecPrice;

@property (nonatomic, strong) HistoryContrastMonth *month;

@end

