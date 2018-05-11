//
//  PortalHomePageViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortalHomePageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *guidongNews;
@property (weak, nonatomic) IBOutlet UIButton *elecRules;
@property (weak, nonatomic) IBOutlet UIButton *pubicNews;
@property (weak, nonatomic) IBOutlet UIButton *helps;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@end
