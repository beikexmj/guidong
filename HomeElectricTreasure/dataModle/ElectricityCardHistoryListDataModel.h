//
//  ElectricityCardHistoryListDataModel.h
//  copooo
//
//  Created by 夏明江 on 16/9/21.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ElectricityCardHistoryListForm,ElectricityCardHistoryList;
@interface ElectricityCardHistoryListDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<ElectricityCardHistoryListForm *> *form;


@end
@interface ElectricityCardHistoryListForm : NSObject

@property (nonatomic, copy) NSString *totalFee;

@property (nonatomic, copy) NSString *totalElecNumber;

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, strong) NSArray<ElectricityCardHistoryList *> *list;

@end

@interface ElectricityCardHistoryList : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *elecNumber;

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *fee;

@end

