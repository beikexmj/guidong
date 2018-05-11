//
//  HistoryBillListTableViewCell.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryBillListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *eletricityNum;
@property (weak, nonatomic) IBOutlet UILabel *electricityFee;

@end
