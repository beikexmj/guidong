//
//  ElectricityFeeDisplayBackView.h
//  copooo
//
//  Created by 夏明江 on 16/9/7.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyElectricityFeePaymentDataModel.h"
#import "CFLineChartView.h"

@interface ElectricityFeeDisplayBackView : UIView

@property (weak, nonatomic) IBOutlet UIView *electSubView;

@property (weak, nonatomic) IBOutlet UILabel *myElectricityFee;

@property (weak, nonatomic) IBOutlet UIView *electricityFeeView;
@property (nonatomic, strong) CFLineChartView *LCView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
@property (weak, nonatomic) IBOutlet UILabel *yearOrMonthElectNum;

- (IBAction)mySegment:(id)sender;
@property (nonatomic,strong)Detail *eleFeePaymentDict;
-(void)addData:(Detail *)eleFeePaymentDict;
@end
