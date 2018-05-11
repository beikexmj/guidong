//
//  UseDeductionVoucherViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectricityBillPayInfoModel.h"
@interface UseDeductionVoucherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSString *voucherId;//优惠券ID;
@property (nonatomic,strong)NSArray <SpendableVoucher *>*dataArry;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)backBtnClick:(id)sender;
@end
