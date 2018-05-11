//
//  MyWebViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/9/19.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *urlStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)backBtnClick:(id)sender;
@end
