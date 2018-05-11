//
//  PayElectricityFeeTwoViewController.m
//  copooo
//
//  Created by 夏明江 on 2017/1/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "PayElectricityFeeTwoViewController.h"
#import "JGPayPassWordView.h"
#import "JGPayPassWordView2.h"
#import "JGPayPassWordView3.h"
#import "ModifyPaymentPasswordFirstStepViewController.h"
#import "ElectricityBillPayInfoModel.h"
#import "BalanceRechargeViewController.h"
@interface PayElectricityFeeTwoViewController ()<JGPayPassWordViewDelegate,JGPayPassWordView2Delegate,JGPayPassWordView3Delegate,UIAlertViewDelegate>
@property (nonatomic,strong)ElectricityBillPayInfoForm *dict;

@property (strong,nonatomic)JGPayPassWordView *payView;
@property (strong,nonatomic)JGPayPassWordView2 *payView2;
@property (strong,nonatomic)JGPayPassWordView3 *payView3;
@end

@implementation PayElectricityFeeTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 网络数据请求
-(void)fetchData{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":self.accountNo};
    [MBProgressHUD showMessage:@"数据加载中..."];
    [ZTHttpTool postWithUrl:@"postPayBill/getElectricityBillPayInfo" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityBillPayInfoModel *electricityCard = [ElectricityBillPayInfoModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {
            self.dict = electricityCard.form;
            [self reloadData];
        }else{
            [MBProgressHUD showError:electricityCard.msg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];
    
}
#pragma mark - 重新加载界面显示
-(void)reloadData{
    self.electricityFee.text = [NSString stringWithFormat:@"%.2f元",_dict.fee];
    self.account.text = _dict.accountNo;
    self.name.text = _dict.electricityUsername;
    self.balance.text = [NSString stringWithFormat:@"%.2f元",_dict.appBalance];
    self.totalPayMoney.text = self.electricityFee.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  忘记密码
- (IBAction)forgetPassWordBtnClick:(id)sender {
    ModifyPaymentPasswordFirstStepViewController *page = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
#pragma mark - 支付点击事件
- (IBAction)payBtnClick:(id)sender {
//    if ([JGIsBlankString isBlankString:self.acount.text]) {
//        [MBProgressHUD showError:@"请输入购电金额"];
//        return;
//    }
    if (_dict.fee<=0) {
        [MBProgressHUD showError:@"无需缴纳电费"];
        return;
    }
    if (_dict) {
        
        if (_dict.appBalance*100>=_dict.fee*100) {
            if (_dict.isPayPasswordSet == 0) {
                [self setPassword];
            }else{
                [self payMoney];
            }
        }else{
            [[[UIAlertView alloc] initWithTitle:@"余额不足，将跳转第三方支付补足差额,系统自动完成购电操作。" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            
        }
    }
}
#pragma mark - 余额不足够跳转充值界面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self payMoneyToWallent];
    }
}
-(void)payMoneyToWallent{
    BalanceRechargeViewController *page = [[BalanceRechargeViewController alloc]init];
       
    page.otherMoney.text = [NSString stringWithFormat:@"%.2f",_dict.fee-_dict.appBalance];
    page.rechargeValue = _dict.fee-_dict.appBalance;
    page.comfromFlag = 2;
    page.accountNo = _dict.accountNo;
    [self.navigationController pushViewController:page animated:YES];
}
#pragma mark - 支付密码框口
-(void)payMoney{
    JGPayPassWordView *payWordView = [[[NSBundle mainBundle] loadNibNamed:@"JGPayPassWordView" owner:self options:nil] lastObject];
    payWordView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.payView = payWordView;
    payWordView.delegate = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            payWordView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    //支付的金额
    payWordView.moneyLabel.text = [NSString stringWithFormat:@"%.2f",_dict.fee];//[NSString stringWithFormat:@"¥%.2f",_dict.totalPay];
    payWordView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    payWordView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //取消支付
    [payWordView.cancelBtn addTarget:self action:@selector(removePayView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:payWordView];
}
#pragma mark - 设置支付密码窗口1
-(void)setPassword{
    JGPayPassWordView2 *payWordView = [[[NSBundle mainBundle] loadNibNamed:@"JGPayPassWordView2" owner:self options:nil] lastObject];
    payWordView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.payView2 = payWordView;
    payWordView.delegate = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            payWordView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    payWordView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    payWordView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //取消支付
    [payWordView.cancelBtn addTarget:self action:@selector(removePayView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:payWordView];
}
#pragma mark - 确认设置支付密码窗口
-(void)setPassword2{
    JGPayPassWordView3 *payWordView = [[[NSBundle mainBundle] loadNibNamed:@"JGPayPassWordView3" owner:self options:nil] lastObject];
    payWordView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.payView3 = payWordView;
    payWordView.delegate = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            payWordView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    payWordView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    payWordView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //取消支付
    [payWordView.cancelBtn addTarget:self action:@selector(removePayView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:payWordView];
}

#pragma mark - jGPayPasswordDelelegate
-(void)textFieldHaveSixNumberForView{
    [self.payView removeFromSuperview];
    [self payMoneyRequest:self.payView.actStr];
    
}
-(void)textFieldHaveSixNumberForView2{
    [self.payView2 removeFromSuperview];
    [self setPassword2];
    
}
-(void)textFieldHaveSixNumberForView3{
    
    if([self.payView2.actStr isEqualToString:self.payView3.actStr]){
        [self requestSetPassword];
        [self.payView3 removeFromSuperview];
    }else{
        [self.payView3 removeFromSuperview];
        [MBProgressHUD showError:@"两次密码输入不一致，请重新输入"];
        [self setPassword];
    }
    
}

- (void)removePayView{
    
    [self.payView removeFromSuperview];
    [self.payView2 removeFromSuperview];
    [self.payView3 removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 向后台发起请求，设置密码
-(void)requestSetPassword{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"payPassword":self.payView3.actStr};
    
    [ZTHttpTool postWithUrl:@"user/setPayPassword" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] ==0) {
            
            [self payMoneyRequest:self.payView3.actStr];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


#pragma mark - 余额付款
-(void)payMoneyRequest:(NSString*)actStr{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"payPassword":actStr,@"accountNo":_dict.accountNo,@"fee":[NSString stringWithFormat:@"%.2f",_dict.fee]};
    [MBProgressHUD showMessage:@"付款中..."];
    [ZTHttpTool postWithUrl:@"postPayBill/balancePayDirectly" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] ==0) {
            [StorageUserInfromation storageUserInformation].accountBalance = [NSString stringWithFormat:@"%@",[DictToJson dictionaryWithJsonString:str][@"form"][@"appBalance"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
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
