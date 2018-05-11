//
//  ElectricUserYearTrendDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectricUserPointTrendDataModel.h"
#import "ElectricUserQueryOtherByDataModel.h"
@interface ElectricUserYearTrendDataModel : NSObject

@property (nonatomic, strong) PointTrendYear *pointTrendYear;

@property (nonatomic, strong) HistoryContrastYear *year;

@end

