//
//  MyPointDetailDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyPointDetailForm,MyPointDetailList;

@interface MyPointDetailDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MyPointDetailForm *form;

@end
@interface MyPointDetailForm : NSObject

//@property (nonatomic, copy) NSString *mypoint;

@property (nonatomic, strong) NSArray<MyPointDetailList *> *list;

@end

@interface MyPointDetailList : NSObject

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *point;

@property (nonatomic, assign)NSInteger changeAmount;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *ids;

@end
