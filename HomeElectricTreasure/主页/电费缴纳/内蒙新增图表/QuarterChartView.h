//
//  QuarterChartView.h
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/6.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuarterChartView : UIView
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *monthOne;
@property (weak, nonatomic) IBOutlet UILabel *monthTwo;
@property (weak, nonatomic) IBOutlet UILabel *monthThree;
@property (weak, nonatomic) IBOutlet UILabel *monthOneElecNum;
@property (weak, nonatomic) IBOutlet UILabel *monthOneElecFee;
@property (weak, nonatomic) IBOutlet UILabel *monthTwoElecNum;
@property (weak, nonatomic) IBOutlet UILabel *monthTwoElecFee;
@property (weak, nonatomic) IBOutlet UILabel *monthThreeElecNum;
@property (weak, nonatomic) IBOutlet UILabel *monthThreeElecFee;
@property (weak, nonatomic) IBOutlet UILabel *monthOneProportionlabel;
@property (weak, nonatomic) IBOutlet UILabel *monthTwoProportionLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthThreeProportionLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthOneProportion;
@property (weak, nonatomic) IBOutlet UILabel *monthTwoProportion;
@property (weak, nonatomic) IBOutlet UILabel *monthThreeProportion;

@end
