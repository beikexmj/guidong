//
//  LoginViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "registDataModle.h"
#import "AppDelegate.h"
#import "RegestViewController.h"
#import "ResetPasswordViewController.h"
#import "JPUSHService.h"
@interface LoginViewController ()
{
    BOOL flag;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _backBtnToTop.constant = 17+22;
    }
    self.navigationController.navigationBarHidden = YES;
//    self.backView.layer.cornerRadius = 5;
//    self.backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
//    self.backView.layer.borderWidth = 2;
    self.loginBtn.layer.cornerRadius = 5;
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -40)*1/8.0;
    UIView *userNameLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView *usewrNameLeftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 20, 22)];
    usewrNameLeftImgView.image = [UIImage imageNamed:@"name"];
    [userNameLeftView addSubview:usewrNameLeftImgView];
    self.userName.leftView = userNameLeftView;//[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView *passwordLeftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 14, 16, 22)];
    passwordLeftImgView.image = [UIImage imageNamed:@"secret"];
    [passwordLeftView addSubview:passwordLeftImgView];
    self.password.leftView = passwordLeftView;//[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.secureTextEntry = YES;
    
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -40)*1/8.0;
    
    self.gap.constant = SCREEN_HEIGHT/2.0 - 264;
    
    if (_comeFromFlag == 4) {
        _backBtn.hidden = YES;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userName.text = [defaults valueForKey:@"username"]?[defaults valueForKey:@"username"]:@"";
    self.password.text = [defaults valueForKey:@"password"]?[defaults valueForKey:@"password"]:@"";
    flag = YES;
    if (!([self.userName.text isEqual:@""]|[self.password.text isEqual:@""])&&![StorageUserInfromation storageUserInformation].token) {
 //       [self homePageBtnClick:nil];
    }
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

- (IBAction)homePageBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.userName.text]) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    if (![StorageUserInfromation valiMobile:self.userName.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.password.text]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if ([self.password.text length]<6) {
        [MBProgressHUD showError:@"密码长度不足6位"];
        return;
    }
    if ([self.password.text length]>20) {
        [MBProgressHUD showError:@"请输入20位或以下密码"];
        return;
    }
    if (![StorageUserInfromation judgePassWordLegal:self.password.text]) {
        [MBProgressHUD showError:@"密码只能包含可见字符"];
        return;
    }
       [MBProgressHUD showMessage:@"登录中..."];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"username":self.userName.text,@"password":self.password.text,@"device":@"1"};
    [ZTHttpTool postWithUrl:@"login" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        registDataModle *user = [registDataModle yy_modelWithJSON:str];
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        
        if (user.rcode == 0) {
            storage.email = user.form.email;
            storage.nickname = user.form.nickname;
            storage.token = user.form.token;
            storage.userId = user.form.userId;
            storage.username = user.form.username;
            storage.sessionId = user.form.sessionId;
            storage.accountBalance = user.form.accountBalance;
            storage.point = user.form.point;
            storage.sex = user.form.sex;
            storage.invitationCode = user.form.invitationCode;
            storage.invitationLink = user.form.invitationLink;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.userName.text forKey:@"username"];
            if (flag) {
                [defaults setObject:self.password.text forKey:@"password"];

            }else{
                [defaults setObject:@"" forKey:@"password"];

            }
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            [self login];
        }else{
            
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:user.msg];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];

    }];

}

- (IBAction)regestBtnClick:(id)sender {
    RegestViewController * page = [[RegestViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)forgetPassword:(id)sender {
    ResetPasswordViewController * page = [[ResetPasswordViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
-(void)login{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.comfromFlag = _comeFromFlag;
    delegate.window.rootViewController = mainStoryboard.instantiateInitialViewController;
//    HomePageViewController * page = mainStoryboard.instantiateInitialViewController.childViewControllers.firstObject;
//    page.selectedIndex = 1;
//    page.myTabBar.selectedItem = page.myTabBar.items[1];
    //用于绑定Alias的  使用NSString 即可
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    [JPUSHService setAlias:storage.userId callbackSelector:nil object:self];
    NSLog(@"%d %s",__LINE__,__PRETTY_FUNCTION__);
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (IBAction)rememberPassword:(id)sender {
    
    if (flag) {
        [self.rememberPassword setImage:[UIImage imageNamed:@"login_unchoice"] forState:UIControlStateNormal];
    }else{
        [self.rememberPassword setImage:[UIImage imageNamed:@"login_choice"] forState:UIControlStateNormal];
    }
    flag = !flag;
}
- (IBAction)thridPartBtnClcik:(id)sender {
}

- (IBAction)backBtnClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.comfromFlag = 0;
    delegate.window.rootViewController =  mainStoryboard.instantiateInitialViewController;
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
