//
//  ServiceAndNoticeViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceAndNoticeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)deleteBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@end
