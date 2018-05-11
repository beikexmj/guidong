//
//  ElectricityFeeDisplayChartViewController.h
//  copooo
//
//  Created by 夏明江 on 2017/2/23.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyElectricityFeePaymentDataModel.h"

@interface ElectricityFeeDisplayChartViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (nonatomic,strong)Detail *eleFeePaymentDict;

@end
