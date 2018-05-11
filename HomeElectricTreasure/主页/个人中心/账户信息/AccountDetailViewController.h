//
//  AccountDetailViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/9.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *yearChoseBtn;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)yearChoseBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;
@end
