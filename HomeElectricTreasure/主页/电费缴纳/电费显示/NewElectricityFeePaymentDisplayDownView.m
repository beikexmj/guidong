//
//  NewElectricityFeePaymentDisplayDownView.m
//  copooo
//
//  Created by 夏明江 on 2017/2/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "NewElectricityFeePaymentDisplayDownView.h"

@implementation NewElectricityFeePaymentDisplayDownView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.buttonView.layer.cornerRadius = 10;
    self.electricityFeePaymentBtn.layer.cornerRadius = 5;
    [self.electricityFeePaymentBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.electricityFeePaymentBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -60)*1/8.0;
}

-(void)fetcthData:(Data*)eleFeePaymentDict index:(NSInteger)index{
    if (index >= 0) {
        _yearTotalElectNum.text = [NSString stringWithFormat:@"%@年总电量:",eleFeePaymentDict.detail[index].index.currentYear];
        _electNum.text = [NSString stringWithFormat:@"%.1f",[eleFeePaymentDict.detail[index].index.totalYearElec floatValue]];
    }
    if ([eleFeePaymentDict.cardType integerValue]== 9) {
        _electBalanceOrUnPayElectFee.text = @"累计未缴纳电费(元):";
        [_electricityFeePaymentBtn setTitle:@"缴纳电费" forState:UIControlStateNormal];
    }else{
        _electBalanceOrUnPayElectFee.text = @"电卡余额(元):";
        [_electricityFeePaymentBtn setTitle:@"预购电费" forState:UIControlStateNormal];
        
    }
    _balance.text = eleFeePaymentDict.balance;
    
    _electNo.text = eleFeePaymentDict.accountNo;
    _adress.text =[NSString stringWithFormat:@"地址：%@",eleFeePaymentDict.address];
}
@end
