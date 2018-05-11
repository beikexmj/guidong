//
//  ServiceAndNoticeDataModle.h
//  copooo
//
//  Created by 夏明江 on 16/9/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ServiceAndNoticeForm,List;
@interface ServiceAndNoticeDataModle : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ServiceAndNoticeForm *form;

@end

@interface ServiceAndNoticeForm : NSObject
@property (nonatomic, assign) NSInteger unreadCount;

@property (nonatomic, strong) NSArray<List *> *list;

@end

@interface List : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *areaType;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *status;


@end

