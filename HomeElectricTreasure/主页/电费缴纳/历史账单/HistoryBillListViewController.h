//
//  HistoryBillListViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectricityCardHistoryListDataModel.h"
@class ElectricityCardHistoryListForm;
@interface HistoryBillListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerSubView;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong)NSString *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (nonatomic, strong) NSMutableArray<ElectricityCardHistoryListForm*> *eleFeePaymentArry;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)NextOrBeforeYearBtnClick:(id)sender;//tag = 10 上一年，tag =20 下一年
@end
