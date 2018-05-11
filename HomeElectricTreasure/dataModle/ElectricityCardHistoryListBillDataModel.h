//
//  qqq.h
//  SubmitAPPStore
//
//  Created by 刘欣 on 16/11/3.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricityCardHistoryListBillDataForm,ElectricityCardHistoryListBillDataList;
@interface ElectricityCardHistoryListBillDataModel : NSObject


@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ElectricityCardHistoryListBillDataForm *form;


@end
@interface ElectricityCardHistoryListBillDataForm : NSObject

@property (nonatomic, strong) NSArray<ElectricityCardHistoryListBillDataList *> *list;

@end

@interface ElectricityCardHistoryListBillDataList : NSObject

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *electrictyAmount;

@property (nonatomic, copy) NSString *electrictyFee;

@end

