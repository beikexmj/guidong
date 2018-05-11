//
//  SignDeailDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/15.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SignDetailForm;

@interface SignDetailDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) SignDetailForm *form;

@end

@interface SignDetailForm : NSObject

@property (nonatomic, copy)NSString *cnt;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, copy)NSString *continuity;

@property (nonatomic, assign) NSInteger halfMonth;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger week;

@end


