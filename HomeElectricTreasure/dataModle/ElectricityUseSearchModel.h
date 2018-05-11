//
//  qqq.h
//  SubmitAPPStore
//
//  Created by 刘欣 on 16/11/3.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricityUseSearchForm,ElectricityUseSearchList;
@interface ElectricityUseSearchModel : NSObject


@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<ElectricityUseSearchForm *> *form;


@end
@interface ElectricityUseSearchForm : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<ElectricityUseSearchList *> *list;

@end

@interface ElectricityUseSearchList : NSObject

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *elecNumber;

@property (nonatomic, copy) NSString *fee;

@end

