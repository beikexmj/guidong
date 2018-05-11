//
//  HistoryBillListTableViewCell.m
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "HistoryBillListTableViewCell.h"

@implementation HistoryBillListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
