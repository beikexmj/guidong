//
//  LoginViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic,assign)NSInteger comeFromFlag;// ==1退出登录 ==2 其他；
- (IBAction)rememberPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rememberPassword;
- (IBAction)homePageBtnClick:(id)sender;
- (IBAction)regestBtnClick:(id)sender;
- (IBAction)forgetPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;
- (IBAction)thridPartBtnClcik:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnToTop;
@end
