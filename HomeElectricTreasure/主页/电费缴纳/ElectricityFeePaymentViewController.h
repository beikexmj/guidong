//
//  ElectricityFeePaymentViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/17.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef WeakSelf
#define WeakSelf(self) __weak typeof(self) weakSelf = self;
#endif
#import "JSBadgeView.h"
@interface ElectricityFeePaymentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;//电量显示情况
/**
 *  @author 夏明江, 16-08-29 16:08:36
 *
 *  菜单点击选择
 *
 *  @param sender
 */
- (IBAction)rightBtnClick:(id)sender;
/**
 *  @author 夏明江, 16-08-29 16:08:41
 *
 *  广告点击
 *
 *  @param sender
 */
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;

@property (nonatomic,strong)JSBadgeView *badgeView;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)noticeBtnClick:(id)sender;


@end
