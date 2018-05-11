//
//  ElectricityFeeDisplayFrontView.m
//  copooo
//
//  Created by 夏明江 on 16/9/7.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityFeeDisplayFrontView.h"

@implementation ElectricityFeeDisplayFrontView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
//    self.frame = CGRectMake(0, 0,  SCREEN_WIDTH-60, SCREEN_HEIGHT-113-60);
    [super awakeFromNib];
    self.viewsHeigthConstraint.constant = SCREEN_HEIGHT-113-60;
    self.payFeeBtn.layer.cornerRadius = 5;
    if (SCREEN_WIDTH>320) {
        self.withButtonFatherViewHeight.constant = 70;
    }else{
        self.withButtonFatherViewHeight.constant = 70;

    }
    
}
-(void)addData:(Data *)eleFeePaymentDict index:(NSInteger)index{
    Index *list = eleFeePaymentDict.detail[index].index;
    _electricityFee.text = [NSString stringWithFormat:@"%.2f", [list.currentFee floatValue]];
    _electricityNum.text = list.currentElec;
    _adress.text =[NSString stringWithFormat:@"%@",eleFeePaymentDict.address];
    _electricityCardNo.text = list.accountNo;
    _monthFee.text = [NSString stringWithFormat:@"%@月电费(元)",list.currentMonth];
    _yearElecNum.text = [NSString stringWithFormat:@"%@年度总电量(度):",list.currentYear];
    _elctNum.text = [NSString stringWithFormat:@"%.2f",[list.totalYearElec floatValue]];
    _cardBalance.text = [NSString stringWithFormat:@"%.2f",[eleFeePaymentDict.balance floatValue]];
    _payFeeBtn.tag = index;
    if ([list.cardType integerValue] == 9) {
        _elecCardFeeOrNoPayElecFee.text = @"未缴纳电费(元)";
    }else{
        _elecCardFeeOrNoPayElecFee.text = @"电卡余额(元)";

    }

}
- (IBAction)historyBillList:(id)sender {
    if ([self.delegate respondsToSelector:@selector(historyBillList )]) {
        [self.delegate historyBillList];
    }
}

- (IBAction)payFeeBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(payFeeBtnClickIndex:)]) {
        UIButton * button = sender;
        [self.delegate payFeeBtnClickIndex:button.tag];
    }
}
@end
