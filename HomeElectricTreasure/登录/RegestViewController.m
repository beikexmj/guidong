//
//  RegestViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/14.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "RegestViewController.h"
#import "registDataModle.h"
#import "NewPaymentAccountTwoViewController.h"
#import "JPUSHService.h"
@interface RegestViewController ()

@end

@implementation RegestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_codeBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
//    self.phoneNumBackView.layer.cornerRadius = 5;
//    self.passwordBackView.layer.cornerRadius = 5;
    self.submitBtn.layer.cornerRadius = 5;
    self.password.secureTextEntry = !self.password.secureTextEntry;
    
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -20)*1/8.0;

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

- (IBAction)regestBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.password.text]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if ([self.password.text length]<6) {
        [MBProgressHUD showError:@"请输入6位或以上密码"];
        return;
    }
    if ([self.password.text length]>20) {
        [MBProgressHUD showError:@"密码长度超过20位"];
        return;
    }
    if (![StorageUserInfromation judgePassWordLegal:self.password.text]) {
        [MBProgressHUD showError:@"密码只能包含可见字符"];
        return;
    }
    
    for(int i=0; i< [self.password.text length];i++){
        int a = [self.password.text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            [MBProgressHUD showError:@"密码不能包含中文"];
            return;
        }

    }
    if ([JGIsBlankString isBlankString:self.code.text]) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.phoneNum.text forKey:@"username"];
    [defaults setObject:self.password.text forKey:@"password"];
    
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"username":self.phoneNum.text,@"password":self.password.text,@"device":@"1",@"smscode":self.code.text,@"invitationCode":_inviteCode.text?_inviteCode.text:@""};
    [ZTHttpTool postWithUrl:@"register" param:dict success:^(id responseObj) {
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
            [NSKeyedArchiver archiveRootObject:storage toFile:file];

            [self nextPage];
        }else{
            [MBProgressHUD showError:user.msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];

    }];
}

- (IBAction)sendCodeBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
        [MBProgressHUD showError:@"请输入注册手机号"];
        return;
    }
    if (![StorageUserInfromation valiMobile:self.phoneNum.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"username":self.phoneNum.text,@"device":@"1",@"aim":@"0"};
    [ZTHttpTool postWithUrl:@"getSmscode" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] ==0) {
            [self startTime];
            self.code.text = [DictToJson dictionaryWithJsonString:str][@"form"][@"smscode"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];

    }];
}
-(void)startTime{
    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
        return;
    }
    if (![StorageUserInfromation valiMobile:self.phoneNum.text]) {
        return;
    }
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _codeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)passwordVisualBtnClick:(id)sender {
    self.password.secureTextEntry = !self.password.secureTextEntry;
}

-(void)nextPage{
    //用于绑定Alias的  使用NSString 即可
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    [JPUSHService setAlias:storage.userId callbackSelector:nil object:nil];
    NSLog(@"%d %s",__LINE__,__PRETTY_FUNCTION__);

    NewPaymentAccountTwoViewController * page = [[NewPaymentAccountTwoViewController alloc]init];
    page.comfromFlag = 1;
    [self.navigationController pushViewController:page animated:YES];
    
}
@end
