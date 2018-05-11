//
//  SetUpViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUpViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
- (IBAction)aboutBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *exit;
@property (weak, nonatomic) IBOutlet UIView *aboatView;
@property (weak, nonatomic) IBOutlet UIView *alertSetUpView;
- (IBAction)alertSetUpBtnClick:(id)sender;
- (IBAction)protocolAndPrivacy:(id)sender;

- (IBAction)exitBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
