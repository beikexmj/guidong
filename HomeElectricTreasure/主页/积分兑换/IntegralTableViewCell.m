//
//  IntegralTableViewCell.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/2.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "IntegralTableViewCell.h"

@implementation IntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.changeIntegralBtn.layer.cornerRadius = 5;
    [self.changeIntegralBtn setBackgroundImage:[UIImage imageNamed:@"vouchers_button1_2"] forState:UIControlStateNormal];
    [self.changeIntegralBtn setBackgroundImage:[UIImage imageNamed:@"vouchers_button1_1"] forState:UIControlStateHighlighted];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
