//
//  ChangeIntegralViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/2.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ChangeIntegralViewController.h"
@interface ChangeIntegralViewController ()<UIAlertViewDelegate>

@end

@implementation ChangeIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.changeBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.changeBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -40)*1/8.0;

    self.integralDescription.text = [NSString stringWithFormat:@"%@积分兑换%@元电费",_pointRuleListList.point,_pointRuleListList.fee];
    self.expiryDate.text = [NSString stringWithFormat:@"有效期至:%@",_pointRuleListList.deadline];
    self.exchangeNote.text = _pointRuleListList.illustrate;
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,_pointRuleListList.image];
    [self.integralImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
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

- (IBAction)changeBtnClick:(id)sender {
    [self voucherExchange];//积分兑换代金券
    
   
}

- (void)voucherExchange{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"ruleId":_pointRuleListList.ids};
    [MBProgressHUD showMessage:@"兑换中..."];
    [ZTHttpTool postWithUrl:@"voucher/exchange" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        [MBProgressHUD hideHUD];
        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([[onceDict valueForKey:@"rcode"] integerValue] == 0) {
            UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"兑换成功" message:@"可在我的\"票券中心\"中查看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10;
            [alert show];
            
        }else{
            UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"兑换失败" message:@"操作失败，请重新兑换商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 20;
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"兑换失败" message:@"操作失败，请重新兑换商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 20;
        [alert show];
    }];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else{
        if (buttonIndex == 0) {
            
        }else{
             [self voucherExchange];//积分兑换代金券
        }
    }
    
}
@end
