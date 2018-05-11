//
//  qqq.h
//  SubmitAPPStore
//
//  Created by 刘欣 on 16/11/3.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricityUseSearchTwoForm,ElectricityUseSearchTwoDetail,ElectricityUseSearchTwoList;
@interface ElectricityUseSearchTwoModel : NSObject


@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ElectricityUseSearchTwoForm *form;


@end
@interface ElectricityUseSearchTwoForm : NSObject


@property (nonatomic, strong) NSArray<ElectricityUseSearchTwoList*> *list;

@end

@interface ElectricityUseSearchTwoList : NSObject
@property (nonatomic, copy) NSString *year;
@property (nonatomic, strong)NSArray<ElectricityUseSearchTwoDetail*> *detail;
@end

@interface ElectricityUseSearchTwoDetail : NSObject

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *electrictyAmount;

@property (nonatomic, copy) NSString *electrictyFee;

@end

