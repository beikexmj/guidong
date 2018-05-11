//
//  NewElectricityFeePaymentDisplayUpCollectionViewCell.m
//  copooo
//
//  Created by 夏明江 on 2017/2/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "NewElectricityFeePaymentDisplayUpCollectionViewCell.h"

@implementation NewElectricityFeePaymentDisplayUpCollectionViewCell

- (void)awakeFromNib {
    _noBillView.hidden = YES;
    [super awakeFromNib];
    if (SCREEN_WIDTH == 414) {
        _elecFee.font = [UIFont systemFontOfSize:36];
        _elecNum.font = [UIFont systemFontOfSize:36];
        _monthElecFee.font = [UIFont systemFontOfSize:18];
        _monthElecNum.font = [UIFont systemFontOfSize:18];
        _electFeeToTop.constant = 15;
        _electNumToTop.constant= 15;
    }
    // Initialization code
}

@end
