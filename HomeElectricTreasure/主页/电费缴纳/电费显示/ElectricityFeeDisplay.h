//
//  ElectricityFeeDisplay.h
//  copooo
//
//  Created by 夏明江 on 16/9/8.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectricityFeePaymentDataModel.h"

@interface ElectricityFeeDisplay : UIView
-(void)drawElectricityView;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic, strong) ElectricityFeePaymentList *eleFeePaymentDict;
@property (nonatomic,assign)NSInteger index;
-(instancetype)initWithFrame:(CGRect)frame data:(ElectricityFeePaymentList *)eleFeePaymentDict index:(NSInteger)index;
@end
