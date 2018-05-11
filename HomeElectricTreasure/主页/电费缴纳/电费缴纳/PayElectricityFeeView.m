//
//  PayElectricityFeeView.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/7.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "PayElectricityFeeView.h"

@implementation PayElectricityFeeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -20)*1/8.0;

}
@end
