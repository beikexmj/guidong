//
//  PointRuleListDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/11.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PointRuleListForm,PointRuleListList;

@interface PointRuleListDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) PointRuleListForm *form;

@end
@interface PointRuleListForm : NSObject

@property (nonatomic, copy) NSString *mypoint;

@property (nonatomic, strong) NSArray<PointRuleListList *> *list;

@end

@interface PointRuleListList : NSObject

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *point;

@property (nonatomic, copy) NSString *fee;

@property (nonatomic, assign)NSInteger invalid;

@property (nonatomic, copy) NSString *deadline;

@property (nonatomic, copy) NSString *illustrate;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *ids;
@end
