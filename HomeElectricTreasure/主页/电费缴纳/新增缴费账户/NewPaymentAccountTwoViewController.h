//
//  NewPaymentAccountTwoViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPaymentAccountTwoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *elelFeeView;
@property (weak, nonatomic) IBOutlet UIView *acountView;
@property (weak, nonatomic) IBOutlet UITextField *acountTextField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@property (nonatomic,assign)NSInteger comfromFlag;//1表示来自注册
@property (weak, nonatomic) IBOutlet UILabel *payFeeUnit;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
- (IBAction)skipBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
