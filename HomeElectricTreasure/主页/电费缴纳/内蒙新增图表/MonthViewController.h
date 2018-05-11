//
//  MonthViewController.h
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/3.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectricUserMonthTrendDataModel.h"

@interface MonthViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (nonatomic,strong)ElectricUserMonthTrendDataModel *electricUserMonthTrend;

@end
