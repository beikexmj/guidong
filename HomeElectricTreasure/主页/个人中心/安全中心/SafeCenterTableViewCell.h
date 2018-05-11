//
//  SafeCenterTableViewCell.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewToLeft;
@property (weak, nonatomic) IBOutlet UILabel *typeSubLabel;

@end
