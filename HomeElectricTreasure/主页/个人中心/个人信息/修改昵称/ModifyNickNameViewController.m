//
//  ModifyNickNameViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ModifyNickNameViewController.h"

@interface ModifyNickNameViewController ()

@end

@implementation ModifyNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.nickName.leftView = view;
    self.nickName.leftViewMode = UITextFieldViewModeAlways;
    _nickName.clearButtonMode=UITextFieldViewModeWhileEditing;
//    self.nickName.layer.cornerRadius = 5;
    self.comfirmBtn.layer.cornerRadius = 5;
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -20)*1/8.0;
    self.nickName.text = self.myStr;
    // Do any additional setup after loading the view from its nib.
}
-(instancetype)init:(NSString*)str{
    self = [super init];
    if (self) {
        self.myStr = str;
    }
    return self;
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

- (IBAction)backBtnlick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)comfirmBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.nickName.text]) {
        [MBProgressHUD showError:@"请输入昵称"];
        return;
    }
    if ([self.nickName.text length]<2 || [self.nickName.text length]>20) {
        [MBProgressHUD showError:@"昵称长度应为2-20个字符"];
        return;
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"passwordType":@"1",@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"nickname":self.nickName.text};
    [ZTHttpTool postWithUrl:@"user/modify" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
            [StorageUserInfromation storageUserInformation].nickname = [DictToJson dictionaryWithJsonString:str][@"form"][@"nickname"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    

}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nickName) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    
    return YES;
}
@end
