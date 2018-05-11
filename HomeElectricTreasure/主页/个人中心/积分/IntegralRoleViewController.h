//
//  IntegralRoleViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralRoleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *howToUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *howTogetLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UIView *howToUseLineView;
@property (weak, nonatomic) IBOutlet UIView *howTogetLineView;
@property (weak, nonatomic) IBOutlet UIView *roleLineView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)btnClick:(id)sender;
@end
