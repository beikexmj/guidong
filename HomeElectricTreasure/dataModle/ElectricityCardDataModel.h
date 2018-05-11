//
//  ElectricityCardDataModel.h
//  copooo
//
//  Created by 夏明江 on 16/9/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricityCardForm,ElectricityCardList;
@interface ElectricityCardDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ElectricityCardForm *form;

@end
@interface ElectricityCardForm : NSObject

@property (nonatomic, strong) NSArray<ElectricityCardList *> *list;

@end

@interface ElectricityCardList : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *departmentName;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *accountName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger eleType;

@end

