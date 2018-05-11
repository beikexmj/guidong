//
//  ElectricityCardTableViewCell.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricityCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userInfor;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delBtnWidth;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
