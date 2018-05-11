//
//  NewPaymentAccountTwoViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "NewPaymentAccountTwoViewController.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
@interface NewPaymentAccountTwoViewController ()<UITextFieldDelegate>

@end

@implementation NewPaymentAccountTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
//    self.elelFeeView.layer.cornerRadius = 5;
//    self.acountView.layer.cornerRadius = 5;
    self.addBtn.layer.cornerRadius = 5;
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -20)*1/8.0;
    if (_comfromFlag != 1) {
        self.skipBtn.hidden = YES;
    }
    _payFeeUnit.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (([textField.text length] + [string length] == 0)||([string length] ==0 && range.location == 0&& range.length == 1)) {
        _payFeeUnit.hidden = YES;
    }else{
        if (textField.text.length>0 ) {
            if ([[textField.text substringToIndex:1] isEqualToString:@"1"]) {
                _payFeeUnit.text = @"桂东电力";
            }else{
                _payFeeUnit.text = @"桂源水利电业有限公司";
            }
        }else if ([string isEqualToString:@"1"]){
            _payFeeUnit.text = @"桂东电力";
        }else if ([string isEqualToString:@"2"]|[string isEqualToString:@"3"]){
            _payFeeUnit.text = @"桂源水利电业有限公司";
        }
        _payFeeUnit.hidden = NO;

    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addBtnClick:(id)sender {
    
    if ([JGIsBlankString isBlankString:self.acountTextField.text]) {
        [MBProgressHUD showError:@"请输入账户编号"];
        return;
    }
    [MBProgressHUD showMessage:@"电卡绑定中..."];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"city":@"桂东",@"accountNo":self.acountTextField.text,@"departmentName":@"广西桂东电力",@"username":[StorageUserInfromation storageUserInformation].username,@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    [ZTHttpTool postWithUrl:@"user/electricUser/addElectricCard" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
//        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]==0) {
            [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
            if (_comfromFlag == 1) {
                [self login];
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"elecCardChange" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
           [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"电卡绑定失败"];
    }];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)skipBtnClick:(id)sender {
    [self login];
}
-(void)login{
    //用于绑定Tag的 根据自己想要的Tag加入，值得注意的是这里Tag需要用到NSSet
    [JPUSHService setTags:[NSSet setWithObject:self.acountTextField.text] callbackSelector:nil object:self];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = mainStoryboard.instantiateInitialViewController;
}

@end
