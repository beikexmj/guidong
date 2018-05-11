//
//  ElectricityFeeDisplayFrontView.h
//  copooo
//
//  Created by 夏明江 on 16/9/7.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyElectricityFeePaymentDataModel.h"

@protocol ElectricityFeeDisplayFrontViewDelegate<NSObject>
-(void)historyBillList;
-(void)payFeeBtnClickIndex:(NSInteger)index;
@end
@interface ElectricityFeeDisplayFrontView : UIView
@property (weak, nonatomic) IBOutlet UILabel *electricityComply;

@property (weak, nonatomic) IBOutlet UILabel *electricityFee;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *electricityNum;
@property (weak, nonatomic) IBOutlet UILabel *elctricityStep;
@property (weak, nonatomic) IBOutlet UILabel *electricityCardNo;
@property (weak, nonatomic) IBOutlet UILabel *monthFee;
@property (weak, nonatomic) IBOutlet UILabel *cardBalance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withButtonFatherViewHeight;

- (IBAction)historyBillList:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *payFeeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTobottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *views;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewsHeigthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *yearElecNum;
@property (weak, nonatomic) IBOutlet UILabel *elctNum;
@property (weak, nonatomic) IBOutlet UIButton *elecSearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *elecCardManagement;
@property (weak, nonatomic) IBOutlet UILabel *elecCardFeeOrNoPayElecFee;


- (IBAction)payFeeBtnClick:(id)sender;

@property(nonatomic,assign)id<ElectricityFeeDisplayFrontViewDelegate>delegate;
-(void)addData:(Data *)eleFeePaymentDict index:(NSInteger)index;
@end
