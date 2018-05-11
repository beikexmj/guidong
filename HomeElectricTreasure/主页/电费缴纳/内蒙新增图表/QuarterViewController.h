//
//  QuarterViewController.h
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/3.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectricUserQuarterTrendDataModel.h"

@interface QuarterViewController : UIViewController
@property (nonatomic,strong)ElectricUserQuarterTrendDataModel *electricUserQuarterTrend;

- (IBAction)backBtnClick:(id)sender;
@end
