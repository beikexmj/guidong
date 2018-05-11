//
//  IntegralRoleViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "IntegralRoleViewController.h"

@interface IntegralRoleViewController ()

@end

@implementation IntegralRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    self.howTogetLineView.hidden = YES;
    self.roleLineView.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClick:(id)sender {
    self.howToUseLineView.hidden = YES;
    self.howTogetLineView.hidden = YES;
    self.roleLineView.hidden = YES;
    [self.howToUseLabel setTextColor:RGBCOLOR(96, 96, 96)];
    [self.howTogetLabel setTextColor:RGBCOLOR(96, 96, 96)];
    [self.roleLabel setTextColor:RGBCOLOR(96, 96, 96)];
    
    UIButton *btn = sender;
    switch (btn.tag) {
        case 10:
        {
            [self.howToUseLabel setTextColor:RGBCOLOR(0, 167, 255)];
            self.howToUseLineView.hidden = NO;
        }
            break;
        case 20:
        {
            [self.howTogetLabel setTextColor:RGBCOLOR(0, 167, 255)];
            self.howTogetLineView.hidden = NO;

        }
            break;
        case 30:
        {
            [self.roleLabel setTextColor:RGBCOLOR(0, 167, 255)];
            self.roleLineView.hidden = NO;
        }
            break;
        default:
            break;
    }
}
@end
