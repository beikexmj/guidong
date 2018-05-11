//
//  AlertSetUpViewController.m
//  copooo
//
//  Created by 夏明江 on 2016/11/8.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "AlertSetUpViewController.h"

@interface AlertSetUpViewController ()
{
    NSMutableArray *myArray;
}
@end

@implementation AlertSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    myArray  = [NSMutableArray array];
    UIColor *color = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.one.layer.cornerRadius = 3;
    self.one.layer.borderColor =color.CGColor;
    self.one.layer.borderWidth = 1;
    
    self.two.layer.cornerRadius = 3;
    self.two.layer.borderColor =color.CGColor;
    self.two.layer.borderWidth = 1;
    
    self.three.layer.cornerRadius = 3;
    self.three.layer.borderColor =color.CGColor;
    self.three.layer.borderWidth = 1;
    
    self.four.layer.cornerRadius = 3;
    self.four.layer.borderColor =color.CGColor;
    self.four.layer.borderWidth = 1;
    
    self.five.layer.cornerRadius = 3;
    self.five.layer.borderColor =color.CGColor;
    self.five.layer.borderWidth = 1;
    
    self.six.layer.cornerRadius = 3;
    self.six.layer.borderColor =color.CGColor;
    self.six.layer.borderWidth = 1;

    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
-(void)fetchData{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"user/electricUser/queryAlterThreshhold" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
            self.alertBalance.text = [NSString stringWithFormat:@"%.2f", [[NSString stringWithFormat:@"%@",[DictToJson dictionaryWithJsonString:str][@"form"][@"userAlterThreshhold"]] floatValue] ];
            if ([self.alertBalance.text integerValue]<0) {
                self.alertBalance.text = @"";
            }
            [myArray addObjectsFromArray: [DictToJson dictionaryWithJsonString:str][@"form"][@"alterThreshholds"]];
            [self reSetButtonValue];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)reSetButtonValue{
    if (myArray.count<6) {
        return;
    }
    self.one.tag = [myArray[0] integerValue];
    self.two.tag = [myArray[1] integerValue];
    self.three.tag = [myArray[2] integerValue];
    self.four.tag = [myArray[3] integerValue];
    self.five.tag = [myArray[4] integerValue];
    [self.one setTitle:[NSString stringWithFormat:@"%ld元",_one.tag] forState:UIControlStateNormal];
    [self.two setTitle:[NSString stringWithFormat:@"%ld元",_two.tag] forState:UIControlStateNormal];
    [self.three setTitle:[NSString stringWithFormat:@"%ld元",_three.tag] forState:UIControlStateNormal];
    [self.four setTitle:[NSString stringWithFormat:@"%ld元",_four.tag] forState:UIControlStateNormal];
    [self.five setTitle:[NSString stringWithFormat:@"%ld元",_five.tag] forState:UIControlStateNormal];
   
    UIColor *color = [UIColor colorWithRed:64/255.0 green:155/255.0 blue:216/255.0 alpha:1];
    if ([self.alertBalance.text isEqual:@""]) {
        _six.layer.borderColor = color.CGColor;
        [_six setTitleColor:color forState:UIControlStateNormal];
    }else if([self.alertBalance.text integerValue]==self.one.tag){
        _one.layer.borderColor = color.CGColor;
        [_one setTitleColor:color forState:UIControlStateNormal];
    }else if([self.alertBalance.text integerValue]==self.two.tag){
        _two.layer.borderColor = color.CGColor;
        [_two setTitleColor:color forState:UIControlStateNormal];
    }else if([self.alertBalance.text integerValue]==self.three.tag){
        _three.layer.borderColor = color.CGColor;
        [_three setTitleColor:color forState:UIControlStateNormal];
    }else if([self.alertBalance.text integerValue]==self.four.tag){
        _four.layer.borderColor = color.CGColor;
        [_four setTitleColor:color forState:UIControlStateNormal];
    }else if([self.alertBalance.text integerValue]==self.five.tag){
        _five.layer.borderColor = color.CGColor;
        [_five setTitleColor:color forState:UIControlStateNormal];
    }
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

- (IBAction)alertBalanceBtnClick:(id)sender {
    UIColor *color2 = [UIColor colorWithRed:64/255.0 green:155/255.0 blue:216/255.0 alpha:1];
    UIColor *color = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];

    self.one.layer.borderColor =color.CGColor;
    self.two.layer.borderColor =color.CGColor;
    self.three.layer.borderColor =color.CGColor;
    self.four.layer.borderColor =color.CGColor;
    self.five.layer.borderColor =color.CGColor;
    self.six.layer.borderColor =color.CGColor;
    [_one setTitleColor:color3 forState:UIControlStateNormal];
    [_two setTitleColor:color3 forState:UIControlStateNormal];
    [_three setTitleColor:color3 forState:UIControlStateNormal];
    [_four setTitleColor:color3 forState:UIControlStateNormal];
    [_five setTitleColor:color3 forState:UIControlStateNormal];
    [_six setTitleColor:color3 forState:UIControlStateNormal];
    if (sender) {
        UIButton *button = sender;
        button.layer.borderColor = color2.CGColor;
        [button setTitleColor:color2 forState:UIControlStateNormal];
        NSInteger m;
        if (button.tag == 0) {
            if (myArray.count!=0) {
                m = [myArray.lastObject integerValue];
            }else{
                m = -2147483648;
            }
        }else{
            m = button.tag;
        }
        [self setAlterThreshhold:m];
    }

}
- (void)setAlterThreshhold:(NSInteger)intm{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"alterThreshhold":[NSString stringWithFormat:@"%ld",intm]};
    [MBProgressHUD showMessage:@""];
    [ZTHttpTool postWithUrl:@"user/electricUser/setAlterThreshhold" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
            if (intm>0) {
                self.alertBalance.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%ld",intm] floatValue] ];
            }else{
                self.alertBalance.text = @"";
            }
        }else{
            [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];

}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
