//
//  RechargeRecordDataModel.h
//  autolayoutTest
//
//  Created by 刘欣 on 16/12/15.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RechargeRecordForm,RechargeRecordList;
@interface RechargeRecordDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) RechargeRecordForm *form;

@end
@interface RechargeRecordForm : NSObject

@property (nonatomic, copy) NSString *sum;

@property (nonatomic, strong) NSArray<RechargeRecordList *> *list;

@end

@interface RechargeRecordList : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *payway;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *paytime;
@end

