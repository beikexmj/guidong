//
//  ewew.h
//  SubmitAPPStore
//
//  Created by 刘欣 on 16/11/3.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricityBuyRecordForm,ElectricityBuyRecordList;
@interface ElectricityBuyRecordDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ElectricityBuyRecordForm *form;

@end
@interface ElectricityBuyRecordForm : NSObject

@property (nonatomic, copy) NSString *countMoney;

@property (nonatomic, strong) NSArray<ElectricityBuyRecordList *> *list;

@end

@interface ElectricityBuyRecordList : NSObject

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *accountNo;

@end

