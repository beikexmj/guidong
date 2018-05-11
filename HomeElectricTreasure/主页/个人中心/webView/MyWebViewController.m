//
//  MyWebViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/9/19.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "MyWebViewController.h"

@interface MyWebViewController ()

@end

@implementation MyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _myTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _myTitle.text = _titleStr;
    _myWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    NSURL* url = [NSURL URLWithString:_urlStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_myWebView loadRequest:request];//加载
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
