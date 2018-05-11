//
//  ElectricityBuyRecordViewController.h
//  copooo
//
//  Created by 夏明江 on 2016/10/25.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricityBuyRecordTwoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@end
