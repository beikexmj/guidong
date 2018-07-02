//
//  FileBrowserViewController.m
//  copooo
//
//  Created by kerwin on 2018/7/2.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import "FileBrowserViewController.h"
#import <WebKit/WebKit.h>

@interface FileBrowserViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationHeightConstraint;

@end

@implementation FileBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationNavigation];
 
    if (self.fileURL) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.fileURL]];
    }
}

- (void)configurationNavigation
{
    if (kDevice_Is_iPhoneX) {
        self.navigationHeightConstraint.constant = 86;
    }
}

- (IBAction)onBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
