//
//  AlertSetUpViewController.h
//  copooo
//
//  Created by 夏明江 on 2016/11/8.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertSetUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *alertBalance;
- (IBAction)alertBalanceBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
