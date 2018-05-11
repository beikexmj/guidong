//
//  ElectricUserQueryOtherByDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricUserQueryOtherByData,ElecPrice,HistoryContrast,HistoryContrastMonth,HistoryContrastYear,HistoryContrastQuarter,HistoryContrastQuarterMon,HistoryContrastQuarterAn,An,Mon,ElecPriceTypeAndLadder;

@interface ElectricUserQueryOtherByDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ElectricUserQueryOtherByData *form;

@end

@interface ElectricUserQueryOtherByData : NSObject

@property (nonatomic, strong) ElecPrice *elecPrice;
@property (nonatomic, strong) HistoryContrast *historyContrast;


@end

@interface HistoryContrast : NSObject

@property (nonatomic, strong) HistoryContrastMonth *month;

@property (nonatomic, strong) HistoryContrastYear *year;

@property (nonatomic, strong) HistoryContrastQuarter *quarter;

@end
@interface ElecPrice : NSObject

@property (nonatomic, strong) NSArray<ElecPriceTypeAndLadder *>*type;

@property (nonatomic, strong) NSArray<ElecPriceTypeAndLadder *>*ladder;

@end

@interface HistoryContrastMonth : NSObject

@property (nonatomic, copy) NSString *proposal;

@property (nonatomic, copy) NSArray <An *>*an;

@property (nonatomic, copy) NSArray <Mon *>*mon;

@end

@interface HistoryContrastYear : NSObject

@property (nonatomic, copy) NSString *proposal;

@property (nonatomic, copy) NSArray <An *>*an;

@property (nonatomic, copy) NSArray <Mon *>*mon;

@end

@interface HistoryContrastQuarter : NSObject

@property (nonatomic, copy) NSString *proposal;

@property (nonatomic, strong) HistoryContrastQuarterMon *mon;

@property (nonatomic, strong) HistoryContrastQuarterAn *an;

@end

@interface HistoryContrastQuarterMon : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *num;

@end

@interface HistoryContrastQuarterAn : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *num;

@end

@interface An : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *data;

@end

@interface Mon : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *data;

@end

@interface ElecPriceTypeAndLadder : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, assign) BOOL current;

@property (nonatomic, copy) NSString *price;

@end

