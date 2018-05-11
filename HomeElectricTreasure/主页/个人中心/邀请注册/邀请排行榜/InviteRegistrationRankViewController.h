//
//  InviteRegistrationRankViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/12/13.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteRegistrationRankViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *rankTime;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *inviteNum;
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
- (IBAction)rankRuleBtnClick:(id)sender;
@end
