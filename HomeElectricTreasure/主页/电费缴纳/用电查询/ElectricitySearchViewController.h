//
//  ElectricitySearchViewController.h
//  copooo
//
//  Created by 夏明江 on 2016/10/27.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricitySearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UITextField *elecCardNo;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)startTimeBtnClick:(id)sender;
- (IBAction)endTimeBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)searchBtnClick:(id)sender;
- (IBAction)elecCardNoChoseBtnClick:(id)sender;
@property (nonatomic,copy)NSString *cardType;
@property (nonatomic,copy)NSString *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@end
