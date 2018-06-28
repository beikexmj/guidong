//
//  ProtalHomePageClassDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/6/28.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProtalHomePageClassForm,ProtalHomePageClassFormList;
@interface ProtalHomePageClassDataModel : NSObject
@property (nonatomic, assign) NSInteger rcode;
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ProtalHomePageClassForm *form;

@end
@interface ProtalHomePageClassForm :NSObject

@property (nonatomic, strong) NSArray<ProtalHomePageClassFormList *> *list;

@end

@interface ProtalHomePageClassFormList :NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *priority;
@end
