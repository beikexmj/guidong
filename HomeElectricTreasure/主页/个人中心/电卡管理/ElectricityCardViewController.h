//
//  ElectricityCardViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricityCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)delBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *addElectricityCardBtn;
- (IBAction)addElectricityCardBtnClick:(id)sender;
@property (nonatomic,assign)BOOL delFlag;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnToBottom;
@end
