//
//  PayElectricityFeeView.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/7.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayElectricityFeeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *eleFee;
@property (weak, nonatomic) IBOutlet UILabel *elseFee;
@property (weak, nonatomic) IBOutlet UIButton *couponBtn;
@property (weak, nonatomic) IBOutlet UILabel *couponNum;
@property (weak, nonatomic) IBOutlet UIButton *balancePayChoseBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoPayChoseBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiChatPayChoseBtn;

@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIImageView *balancePayImg;
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoPayImg;
@property (weak, nonatomic) IBOutlet UIImageView *weiChatPayImg;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassWord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;

@end
