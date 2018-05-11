//
//  IntegrationDetailsViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegrationDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *integralRoleBtn;
@property (weak, nonatomic) IBOutlet UILabel *integralNum;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHight;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)integralRoleBtnClick:(id)sender;

@end
