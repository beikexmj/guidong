//
//  ElectricityBuyRecordViewController.h
//  copooo
//
//  Created by 夏明江 on 2016/10/25.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricityBuyRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)backBtnClick:(id)sender;
@end
