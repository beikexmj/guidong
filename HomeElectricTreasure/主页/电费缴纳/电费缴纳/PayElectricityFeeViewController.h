//
//  PayElectricityFeeViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayElectricityFeeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *costomNum;//客户编号
@property (weak, nonatomic) IBOutlet UILabel *costomName;//客户名称
@property (weak, nonatomic) IBOutlet UILabel *cardBalance;//电卡余额
@property (strong, nonatomic) UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomSubView;
@property (weak, nonatomic) IBOutlet UILabel *appBalance;//app余额
@property (weak, nonatomic) IBOutlet UITextField *acount;//输入金额
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHight;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;//支付点击按钮
//忘记密码
- (IBAction)forgetPassWordBtnClick:(id)sender;
//支付
- (IBAction)payBtnClick:(id)sender;
//返回
- (IBAction)backBtnClick:(id)sender;
@property(nonatomic,strong)NSString *accountNo;//电卡卡号
@property (weak, nonatomic) IBOutlet UIView *backView;//背景视图
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (nonatomic,assign)NSInteger comfromFlag;// 1预付费 2后付费
@property (weak, nonatomic) IBOutlet UILabel *cardBalanceOrFee;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@end
