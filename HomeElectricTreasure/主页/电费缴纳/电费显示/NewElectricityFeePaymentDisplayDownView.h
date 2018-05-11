//
//  NewElectricityFeePaymentDisplayDownView.h
//  copooo
//
//  Created by 夏明江 on 2017/2/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyElectricityFeePaymentDataModel.h"
@interface NewElectricityFeePaymentDisplayDownView : UIView
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *electricityFeePaymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *electSearcth;
@property (weak, nonatomic) IBOutlet UIButton *electHistoryBillList;
@property (weak, nonatomic) IBOutlet UIButton *electUseChart;
@property (weak, nonatomic) IBOutlet UILabel *electBalanceOrUnPayElectFee;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *yearTotalElectNum;
@property (weak, nonatomic) IBOutlet UILabel *electNum;
@property (weak, nonatomic) IBOutlet UILabel *electNo;
@property (weak, nonatomic) IBOutlet UILabel *adress;

-(void)fetcthData:(Data*)eleFeePaymentDict index:(NSInteger)index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;

@end
