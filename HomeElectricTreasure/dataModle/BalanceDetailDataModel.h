//
//  BalanceDetailDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/15.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceDetailForm,BalanceDetailDataList,BalanceDetailDataListList;

@interface BalanceDetailDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) BalanceDetailForm *form;

@end
@interface BalanceDetailForm : NSObject

@property (nonatomic, copy) NSArray *years;

@property (nonatomic, copy) NSString *current;

@property (nonatomic, strong) NSArray<BalanceDetailDataList *> *list;

@end

@interface BalanceDetailDataList : NSObject

@property (nonatomic, copy) NSString *month;

@property (nonatomic, strong) NSArray<BalanceDetailDataListList *> *detail;


@end

@interface BalanceDetailDataListList : NSObject

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *amountStr;

@property (nonatomic, copy)NSString *year;

@property (nonatomic, copy)NSString *day;

@property (nonatomic, assign)NSInteger type;

@property (nonatomic, copy)NSString *month;

@property (nonatomic, copy)NSString *reason;

@end

