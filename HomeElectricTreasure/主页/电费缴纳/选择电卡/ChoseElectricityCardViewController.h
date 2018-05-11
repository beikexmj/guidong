//
//  ChoseElectricityCardViewController.h
//  copooo
//
//  Created by 夏明江 on 2017/1/18.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseElectricityCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnToBottom;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)addElectricityCardBtnClick:(id)sender;
@end
