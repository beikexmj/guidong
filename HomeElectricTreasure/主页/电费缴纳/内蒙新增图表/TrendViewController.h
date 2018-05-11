//
//  TrendViewController.h
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/10.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *quarterBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
- (IBAction)trendBtnLick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UIView *quarterView;
@property (weak, nonatomic) IBOutlet UIView *yearView;
@property (nonatomic,strong)NSString *accountNo;
@property (nonatomic,strong)NSString *cardType;
@property (weak, nonatomic) IBOutlet UIView *contentSubView;
@property (weak, nonatomic) IBOutlet UIView *monthFatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trendChoseViewConstrant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)rankingListBtnClick:(id)sender;
@end
