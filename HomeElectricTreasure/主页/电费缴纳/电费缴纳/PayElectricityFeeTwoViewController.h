//
//  PayElectricityFeeTwoViewController.h
//  copooo
//
//  Created by 夏明江 on 2017/1/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayElectricityFeeTwoViewController : UIViewController
- (IBAction)forgetPassWordBtnClick:(id)sender;
//支付
- (IBAction)payBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *electricityFee;
@property (weak, nonatomic) IBOutlet UILabel *elseFee;
@property (weak, nonatomic) IBOutlet UILabel *totalPayMoney;
@property(nonatomic,strong)NSString *accountNo;//电卡卡号
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;


@end
