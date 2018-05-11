//
//  ElectricityFeePaymentLogModel.h
//  copooo
//
//  Created by 夏明江 on 16/9/21.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ElectricityFeePaymentLogForm;
@interface ElectricityFeePaymentLogModel : NSObject
@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong)  ElectricityFeePaymentLogForm *form;

@end
@interface ElectricityFeePaymentLogForm : NSObject
@property (nonatomic, copy) NSString *realName;//账户名称

@property (nonatomic, copy) NSString *accountNo;//账号ID

@property (nonatomic, assign) CGFloat appBalance;//app余额

@property (nonatomic, assign) CGFloat cardBalance;//电卡余额

@property (nonatomic, copy) NSString *sessionId; //电费

@property (nonatomic, assign) NSInteger isPayPasswordSet;//是否设置支付密码 0未设置 1已设置

@end
