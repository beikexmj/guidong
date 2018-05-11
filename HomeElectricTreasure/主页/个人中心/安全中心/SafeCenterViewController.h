//
//  SafeCenterViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@end
