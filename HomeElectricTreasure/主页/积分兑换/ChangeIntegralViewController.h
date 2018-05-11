//
//  ChangeIntegralViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/2.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointRuleListDataModel.h"

@interface ChangeIntegralViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *integralImage;
@property (weak, nonatomic) IBOutlet UILabel *integralDescription;
@property (weak, nonatomic) IBOutlet UILabel *expiryDate;
@property (weak, nonatomic) IBOutlet UITextView *exchangeNote;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (nonatomic,strong) PointRuleListList *pointRuleListList;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)changeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;

@end
