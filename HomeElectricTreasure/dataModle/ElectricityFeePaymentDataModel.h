//
//  ElectricityFeePaymentDataModel.h
//  copooo
//
//  Created by 夏明江 on 16/9/19.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricityFeePaymentForm,ElectricityFeePaymentList,Electricinfolist,Electricstepinfo;
@interface ElectricityFeePaymentDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ElectricityFeePaymentForm *form;

@end
@interface ElectricityFeePaymentForm : NSObject

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, strong) NSArray<ElectricityFeePaymentList *> *list;

@end

@interface ElectricityFeePaymentList : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *departmentName;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) NSArray<NSNumber *> *elecSum;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, strong) NSArray<NSString *> *month;

@property (nonatomic, strong) NSArray<Electricinfolist *> *ElectricInfoList;

@property (nonatomic, copy) NSString *accountName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSArray<NSNumber *> *allAverage;

@property (nonatomic, assign) CGFloat max;

@property (nonatomic, assign) CGFloat min;

@end

@interface Electricinfolist : NSObject

@property (nonatomic, copy) NSString *month;

@property (nonatomic, strong) Electricstepinfo *ElectricStepInfo;

@property (nonatomic, assign) CGFloat totalFee;

@property (nonatomic, copy) NSString *arrear;

@property (nonatomic, copy) NSString *billId;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, assign) CGFloat yearElecSum;

@end

@interface Electricstepinfo : NSObject

@property (nonatomic, assign) CGFloat count;

@property (nonatomic, copy) NSString *stepName;

@end

