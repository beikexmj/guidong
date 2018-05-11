//
//  ElectricityFeePaymentLogModel.h
//  copooo
//
//  Created by 夏明江 on 16/9/21.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ElectricityBillPayInfoForm,SpendableVoucher;
@interface ElectricityBillPayInfoModel : NSObject
@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong)  ElectricityBillPayInfoForm *form;

@end
@interface ElectricityBillPayInfoForm : NSObject
@property (nonatomic, copy) NSString *electricityUsername;//账户名称

@property (nonatomic, copy) NSString *accountNo;//账号ID

@property (nonatomic, assign) CGFloat appBalance;//app余额

@property (nonatomic, assign) CGFloat fee;//电费

@property (nonatomic, assign) CGFloat punish;//滞纳金

@property (nonatomic, copy) NSString *payway; //支付方式

@property (nonatomic, assign) NSInteger isPayPasswordSet;//是否设置支付密码 0未设置 1已设置

@property (nonatomic, assign) NSInteger voucherCnt;//优惠券张数

@property (nonatomic, assign) CGFloat lastMonthFee;//当月未缴纳电费

@property (nonatomic, strong) NSArray<SpendableVoucher *> *spendableVoucher;//优惠卷

@end

@interface SpendableVoucher : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy)NSString *describe;

@property (nonatomic, copy)NSString *source;

@property (nonatomic, assign)NSInteger use;

@property (nonatomic, assign)NSInteger status;

@property (nonatomic, copy)NSString *deadline;

@property (nonatomic, copy)NSString *createTime;

@property (nonatomic, copy)NSString *useTime;

@property (nonatomic, copy)NSString *ids;

@property (nonatomic, copy)NSString *image;


@end
