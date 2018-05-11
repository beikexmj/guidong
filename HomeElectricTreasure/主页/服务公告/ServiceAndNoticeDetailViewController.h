//
//  ServiceAndNoticeDetailViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/14.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceAndNoticeDataModle.h"
@interface ServiceAndNoticeDetailViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic,strong)List *myDict;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
