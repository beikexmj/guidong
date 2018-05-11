//
//  PersonalCenterTableViewCell.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *backguandView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewToLeft;

@end
