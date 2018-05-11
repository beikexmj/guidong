//
//  DataComparisonView.h
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLineChart.h"
@interface DataComparisonView : UIView
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIView *momView;
@property (weak, nonatomic) IBOutlet UILabel *anLabel;
@property (weak, nonatomic) IBOutlet UILabel *momLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UILabel *anData;
@property (weak, nonatomic) IBOutlet UILabel *monData;
@property (strong, nonatomic)JHLineChart *lineChart;
- (void)showAnimation;
-(void)reInit:(NSArray*)xLineDataArr Value:(NSArray*)valueArr;
- (void)hiddenAnViewAnMonView;
@end
