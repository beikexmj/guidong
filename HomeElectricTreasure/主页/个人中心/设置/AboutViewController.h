//
//  AboutViewController.h
//  copooo
//
//  Created by 夏明江 on 16/10/20.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet UILabel *version;
- (IBAction)backBtnClick:(id)sender;
@end
