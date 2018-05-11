//
//  qqqqq.h
//  Magic
//
//  Created by 夏明江 on 16/11/1.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data,Detail,Index,Year,MonthList,Month,DayList;
@interface MyElectricityFeePaymentDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<Data *> *form;


@end
@interface Data : NSObject

@property (nonatomic, strong) NSArray<Detail *> *detail;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *balance;

@property (nonatomic, copy) NSString *cardType;

@end

@interface Detail : NSObject

@property (nonatomic, strong) Index *index;

@property (nonatomic, strong) Year *year;

@property (nonatomic, strong) Month *month;

@end

@interface Index : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *currentYear;

@property (nonatomic, assign) NSString* totalYearElec;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, copy) NSString *currentElec;

@property (nonatomic, copy) NSString *currentFee;

@property (nonatomic, copy) NSString *currentMonth;

@property (nonatomic, copy) NSString *balance;

@property (nonatomic, copy) NSString *cardType; // ==9 后付费

@end

@interface Year : NSObject

@property (nonatomic, copy) NSString *totalYearElecNumber;

@property (nonatomic, strong) NSArray<MonthList *> *list;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *totalYearFee;

@end

@interface MonthList : NSObject

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, copy) NSString *fee;

@property (nonatomic, copy) NSString *elecNumber;

@end
@interface Month : NSObject

@property (nonatomic, copy) NSString *totalFee;

@property (nonatomic, copy) NSString *totalElecNumber;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, strong) NSArray<DayList *> *list;

@end

@interface DayList : NSObject

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, copy) NSString *fee;

@property (nonatomic, copy) NSString *elecNumber;

@end

