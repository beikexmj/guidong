//
//  SetUpViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "SetUpViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JPUSHService.h"
#import "AboutViewController.h"
#import "AlertSetUpViewController.h"
#import "MyWebViewController.h"
@interface SetUpViewController ()

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    self.exit.layer.cornerRadius = 5;
    [self.exit setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.exit setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -20)*1/8.0;

//    self.aboatView.layer.cornerRadius = 5;
//    self.alertSetUpView.layer.cornerRadius = 5;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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

- (IBAction)aboutBtnClick:(id)sender {
    AboutViewController * page = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)alertSetUpBtnClick:(id)sender {
    AlertSetUpViewController *page = [[AlertSetUpViewController alloc]init];
    [self.navigationController pushViewController:page
                                         animated:YES];
}

- (IBAction)protocolAndPrivacy:(id)sender {
    MyWebViewController *page = [[MyWebViewController alloc]init];
    page.titleStr = @"隐私及协议";
    page.urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL2,@"/jujiahe/privacy.html"];
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)exitBtnClick:(id)sender {
    [self login];
}
-(void)login{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定退出？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:@"" forKey:@"username"];
//        [defaults setObject:@"" forKey:@"password"];
        [defaults setValue:nil forKey:@"accountNo"];

        //没有值就代表去除
        [JPUSHService setTags:[NSSet set]callbackSelector:nil object:nil];
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        NSLog(@"%d %s",__LINE__,__PRETTY_FUNCTION__);
//        [JPUSHService removeNotification:nil];
        
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        [NSKeyedArchiver archiveRootObject:[NSNull null] toFile:file];

        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.comeFromFlag = 4;
        delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    }
    
}

@end
