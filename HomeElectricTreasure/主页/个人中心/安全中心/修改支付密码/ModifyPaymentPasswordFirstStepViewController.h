//
//  ModifyPaymentPasswordFirstStepViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/5.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPaymentPasswordFirstStepViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
- (IBAction)getIdentifyingCodeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCode;
@property (weak, nonatomic) IBOutlet UIButton *identifyingCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)comfirmBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
