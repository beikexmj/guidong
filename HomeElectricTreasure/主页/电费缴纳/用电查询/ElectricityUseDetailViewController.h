//
//  ElectricityUseDetailViewController.h
//  copooo
//
//  Created by 夏明江 on 2016/10/27.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricityUseDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)backBtnClick:(id)sender;
@property (strong, nonatomic)  NSString *startTime;
@property (strong, nonatomic)  NSString *endTime;
@property (strong, nonatomic)  NSString *elecCardNo;
@property (strong, nonatomic)  NSString *cardTpye;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
