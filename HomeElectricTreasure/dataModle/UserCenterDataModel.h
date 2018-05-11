//
//  UserCenterDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserCenterForm,UserCenterVoucherForm;

@interface UserCenterDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) UserCenterForm *form;

@end
@interface UserCenterForm : NSObject

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSString *accountBalance;

@property (nonatomic, copy)NSString *point;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) UserCenterVoucherForm *voucher;

@end

@interface UserCenterVoucherForm : NSObject

@property (nonatomic, copy) NSString *used;

@property (nonatomic, copy)NSString *available;

@property (nonatomic, copy)NSString *outofdate;

@end
