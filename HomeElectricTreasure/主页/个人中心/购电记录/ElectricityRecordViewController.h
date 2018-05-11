//
//  ElectricityRecordViewController.h
//  copooo
//
//  Created by 夏明江 on 2017/2/3.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricityRecordViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@end
