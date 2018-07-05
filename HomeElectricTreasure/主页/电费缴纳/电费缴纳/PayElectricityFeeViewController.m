//
//  PayElectricityFeeViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "PayElectricityFeeViewController.h"
#import "JGPayPassWordView.h"
#import "JGPayPassWordView2.h"
#import "JGPayPassWordView3.h"
#import "ElectricityFeePaymentLogModel.h"
#import "ElectricityBillPayInfoModel.h"
#import "BalanceRechargeViewController.h"
#import "ModifyPaymentPasswordFirstStepViewController.h"
#import "PayElectricityFeeView.h"
#import "UseDeductionVoucherViewController.h"
#import "VoucherListDataModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Replace.h"
#import "WXApi.h"

@interface PayElectricityFeeViewController ()<JGPayPassWordViewDelegate,JGPayPassWordView2Delegate,JGPayPassWordView3Delegate>
{
    BOOL isHaveDian;
    BOOL isZero;
    NSInteger payType; //0未选择，1 余额支付，2 支付宝支付；3微信支付
    NSString *voucherId;//优惠券ID
    NSString *value;//优惠券面额
    NSString *payLogId;//支付宝订单id
}
@property (nonatomic,strong)PayElectricityFeeView *payElectricityFeeView;

@property (nonatomic,strong)ElectricityFeePaymentLogForm *dict;
@property (nonatomic,strong)ElectricityBillPayInfoForm *dict2;

@property (strong,nonatomic)JGPayPassWordView *payView;
@property (strong,nonatomic)JGPayPassWordView2 *payView2;
@property (strong,nonatomic)JGPayPassWordView3 *payView3;

@end

@implementation PayElectricityFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _headerHight.constant = 192+22;
        _headerTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [self setHeaderBackView];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREEN_WIDTH -20)*1/8.0;

    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    label.text = @"元";
    [label setTextColor:RGBCOLOR(48, 48, 48)];
    label.font = [UIFont systemFontOfSize:15];
    [rightView addSubview:label];
    _acount.rightView = rightView;
    _acount.rightViewMode = UITextFieldViewModeAlways;
    _acount.layer.cornerRadius = 5;
    _acount.backgroundColor = RGBCOLOR(243, 243, 248);
    _acount.layer.borderColor = RGBCOLOR(221, 221, 221).CGColor;
    _acount.layer.borderWidth = 1.0;
    self.moneyView.layer.cornerRadius = 5;
    self.moneyView.layer.borderWidth = 1;
    self.moneyView.layer.borderColor = RGBCOLOR(192, 192, 192).CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voucherNotification:) name:@"voucher" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPaySuccess) name:@"weixinPaySuccess" object:nil];

    
    payType = 3;
    if (_comfromFlag == 1) {//预付费
       self.headerTitle.text = @"预购电费";
        self.cardBalanceOrFee.text = @"电卡余额";
    }else{//后付费
        self.headerTitle.text = @"缴纳电费";
        self.cardBalanceOrFee.text = @"本月电费";
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64*3)];
        [_bottomView addSubview:_myScrollView];
        _bottomSubView.hidden = YES;
        _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 539+31.5-60);
        _myScrollView.showsVerticalScrollIndicator = NO;
        _payElectricityFeeView = [[[NSBundle mainBundle] loadNibNamed:@"PayElectricityFeeView" owner:nil options:nil] lastObject];
        _payElectricityFeeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 539+31.5-60);
        [self.myScrollView addSubview:_payElectricityFeeView];
        [_payElectricityFeeView.balancePayChoseBtn addTarget:self action:@selector(payChoseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_payElectricityFeeView.zhifubaoPayChoseBtn addTarget:self action:@selector(payChoseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_payElectricityFeeView.weiChatPayChoseBtn addTarget:self action:@selector(payChoseBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [_payElectricityFeeView.payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_payElectricityFeeView.forgetPassWord addTarget:self action:@selector(forgetPassWordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_payElectricityFeeView.couponBtn addTarget:self
                                             action:@selector(couponBtnClick:) forControlEvents:UIControlEventTouchUpInside];    }
    
    if (_comfromFlag == 1) {//预付费
        [self fetchData];
    }else{
        [self fetchData2];

    }
    // Do any additional setup after loading the view from its nib.
}
- (void)setHeaderBackView{
    self.headerBackView.layer.cornerRadius = 3;
    self.headerBackView.layer.masksToBounds = YES;
}
#pragma mark - 网络数据请求
-(void)fetchData{//预付费
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":self.accountNo};
    [MBProgressHUD showMessage:@"数据加载中..."];
    [ZTHttpTool postWithUrl:@"user/electricPayLog/getPurchaseInfo" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityFeePaymentLogModel *electricityCard = [ElectricityFeePaymentLogModel mj_objectWithKeyValues:str];
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
-(void)fetchData2{//后付费
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
            self.dict2 = electricityCard.form;
            [self reloadData2];
        }else{
            [MBProgressHUD showError:electricityCard.msg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];
    
    
}

#pragma mark - 重新加载界面显示
-(void)reloadData{//预付费
    self.appBalance.text = [NSString stringWithFormat:@"%.2f元",_dict.appBalance];
    self.costomNum.text = _dict.accountNo;
    if (self.costomName.text.length == 2) {
        self.costomName.text = [self.costomName.text replaceStringWithAsterisk:1 length: self.costomName.text.length-1];
    }else if (self.costomName.text.length > 2){
        self.costomName.text = [self.costomName.text replaceStringWithAsterisk:1 length: self.costomName.text.length-2];
    }
    self.cardBalance.text = [NSString stringWithFormat:@"%.2f元",_dict.cardBalance];
    if (_dict.cardBalance<0) {
        self.acount.text = [NSString stringWithFormat:@"%.2f",(0 - _dict.cardBalance)];
    }
}
-(void)reloadData2{//后付费
//    self.appBalance.text = [NSString stringWithFormat:@"%.2f元",_dict2.appBalance];
    self.costomNum.text = _dict2.accountNo;
    self.costomName.text = _dict2.electricityUsername;
    if (self.costomName.text.length == 2) {
        self.costomName.text = [self.costomName.text replaceStringWithAsterisk:1 length: self.costomName.text.length-1];
    }else if (self.costomName.text.length > 2){
        self.costomName.text = [self.costomName.text replaceStringWithAsterisk:1 length: self.costomName.text.length-2];
    }
    self.cardBalance.text = [NSString stringWithFormat:@"%.2f元", _dict2.lastMonthFee];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.cardBalance.text];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:RGBCOLOR(0, 167, 255)
                    range:NSMakeRange(0, self.cardBalance.text.length-1)];
    self.cardBalance.attributedText = attrStr;
    
    self.acount.text = [NSString stringWithFormat:@"%.2f", _dict2.fee + _dict2.punish];
    
    _payElectricityFeeView.eleFee.text = [NSString stringWithFormat:@"%.2f元", _dict2.fee];
    _payElectricityFeeView.elseFee.text = [NSString stringWithFormat:@"%.2f元", _dict2.punish];
    _payElectricityFeeView.balance.text = [NSString stringWithFormat:@"账户余额支付(余额%.2f元)",_dict2.appBalance];
    _payElectricityFeeView.payMoney.text = [NSString stringWithFormat:@"%.2f", _dict2.fee + _dict2.punish];
    _payElectricityFeeView.couponNum.text = [NSString stringWithFormat:@"%ld张优惠券",_dict2.spendableVoucher.count];
    if (_dict2.appBalance*100>= (_dict2.fee + _dict2.punish)*100) {
        [_payElectricityFeeView.balance setTextColor:RGBCOLOR(48, 48, 48)];
        [self payChoseBtnClick:_payElectricityFeeView.balancePayChoseBtn];
    }else{
        payType = 0;
        [_payElectricityFeeView.balance setTextColor:RGBCOLOR(156, 156, 156)];
    }
    payType = 3;
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
#pragma mark -  忘记密码
- (IBAction)forgetPassWordBtnClick:(id)sender {
    ModifyPaymentPasswordFirstStepViewController *page = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
#pragma mark - 支付点击事件
- (IBAction)payBtnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 10) {//预付费
        [self.acount resignFirstResponder];
        if ([JGIsBlankString isBlankString:self.acount.text]) {
            [MBProgressHUD showError:@"请输入购电金额"];
            return;
        }
        if ([self.acount.text doubleValue]<=0) {
            [MBProgressHUD showError:@"购电金额不能是0元"];
            return;
        }
        if (_dict) {
            if (_dict.cardBalance+[self.acount.text doubleValue]<-0.009) {
                [MBProgressHUD showError:@"购电金额不足"];
                return;
            }
            if ([self.acount.text doubleValue]*100>=10000000000) {
                [MBProgressHUD showError:@"购电金额过大"];
                return;
            }
            if (_dict.appBalance*100>=[self.acount.text doubleValue]*100) {
                if (_dict.isPayPasswordSet == 0) {
                    [self setPassword];
                }else{
                    [self payMoney];
                }
            }else{
                
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"余额不足，将跳转第三方支付补足差额,系统自动完成购电操作。" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 10;
                [alert show];

            }
        }

    }else if(btn.tag == 20){
        
        if (_dict2.fee + _dict2.punish <=0) {
            [MBProgressHUD showError:@"无需缴纳电费"];
            return;
        }
        if (payType == 2) {
            [self payMoneyWithAliPay];
        }else if (payType == 3){
            [self payMoneyWithWeixin];
        }
        else if( payType == 1){
            if (_dict2) {
                if (value) {
                    if ((_dict2.appBalance +value.floatValue)*100>= (_dict2.fee + _dict2.punish)*100) {
                        if (_dict2.isPayPasswordSet == 0) {
                            [self setPassword];
                        }else{
                            [self payMoney];
                        }
                    }else{
                      UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"余额不足，将跳转第三方支付补足差额,系统自动完成购电操作。" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.tag = 10;
                        [alert show];
                        
                    }
                }else{
                    if (_dict2.appBalance*100>= (_dict2.fee + _dict2.punish)*100) {
                        if (_dict2.isPayPasswordSet == 0) {
                            [self setPassword];
                        }else{
                            [self payMoney];
                        }
                    }else{
                        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"余额不足，将跳转第三方支付补足差额,系统自动完成购电操作。" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.tag = 10;
                        [alert show];
                        
                    }
                }
                
            }
        }else if (payType == 0){
            [MBProgressHUD showError:@"请选择支付方式"];
        }
    }
   
}
#pragma mark - 余额不足够跳转充值界面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==10) {
        if (buttonIndex == 1) {
            [self payMoneyToWallent];
        }
  
    }else if (alertView.tag == 20){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
        if (_comfromFlag == 1) {//预付费
            [self fetchData];
        }else{
            [self fetchData2];
            
        }
    }else if (alertView.tag == 30){
        NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"payLogId":payLogId};
        [ZTHttpTool postWithUrl:@"postPayBill/cancelPay" param:dict success:^(id responseObj) {
            NSLog(@"%@",[responseObj mj_JSONObject]);
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSLog(@"%@",str);
            NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
            if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] != 0) {
                [MBProgressHUD showError:@"订单取消失败"];
            }else{
                if (buttonIndex == 1) {
                    [self payMoneyWithAliPay];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"订单取消失败"];
        }];
        
        
    }
    
}
-(void)payMoneyToWallent{
    BalanceRechargeViewController *page = [[BalanceRechargeViewController alloc]init];
    if ([JGIsBlankString isBlankString:self.acount.text]) {
        [MBProgressHUD showError:@"请输入购电金额"];
        return;
    }
    if ([self.acount.text doubleValue]<0.009) {
        [MBProgressHUD showError:@"购电金额不能小于0.01元"];
        return;
    }
    if (_dict) {
        page.otherMoney.text = [NSString stringWithFormat:@"%.2f",[self.acount.text doubleValue]-_dict.appBalance];
        
        page.rechargeValue = [self.acount.text doubleValue]-_dict.appBalance;
        page.comfromFlag = 1;
        page.accountNo = _dict.accountNo;
    }else if (_dict2){
        page.otherMoney.text = [NSString stringWithFormat:@"%.2f",[self.acount.text doubleValue]-_dict2.appBalance];
        
        page.rechargeValue = [[NSString stringWithFormat:@"%0.2f",[self.acount.text doubleValue]-_dict2.appBalance] floatValue];
        page.comfromFlag = 1;
        page.accountNo = _dict2.accountNo;
    }
   
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
    if (value) {
        payWordView.moneyLabel.text = _payElectricityFeeView.payMoney.text;
    }else{
        payWordView.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.acount.text floatValue]];//[NSString stringWithFormat:@"¥%.2f",_dict.totalPay];
    }
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
- (void)removePayView{
    
    [self.payView removeFromSuperview];
    [self.payView2 removeFromSuperview];
    [self.payView3 removeFromSuperview];
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        [self.payView3 removeFromSuperview];
        [self requestSetPassword];
    }else{
        [self.payView3 removeFromSuperview];
        [MBProgressHUD showError:@"两次密码输入不一致，请重新输入"];
        [self setPassword];
    }

}
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
    NSDictionary *dict;
    NSString *url;
    if (_comfromFlag == 1) {//预付费
         dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"payPassword":actStr,@"accountNo":_dict.accountNo,@"payAmount":self.acount.text};
        url = @"user/electricPayLog/startPay";
    }else{//后付费
        url = @"postPayBill/balancePayDirectly";
        if (voucherId) {
            dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"payPassword":actStr,@"accountNo":_dict2.accountNo,@"fee":self.acount.text,@"voucherId":voucherId};
        }else{
            dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"payPassword":actStr,@"accountNo":_dict2.accountNo,@"fee":self.acount.text};
        }
        
    }
   
    [MBProgressHUD showMessage:@"付款中..."];
    [ZTHttpTool postWithUrl:url param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] ==0) {
            [StorageUserInfromation storageUserInformation].accountBalance = [NSString stringWithFormat:@"%@",[DictToJson dictionaryWithJsonString:str][@"form"][@"appBalance"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];

}

//带小数点的金额数字键盘输入判定
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    isZero = YES;
                }else{
                    isZero = NO;
                }
            }
            if ([textField.text length] == 1) {//首字母为零时第二个必须是小数点
                if (single != '.') {
                    if (isZero) {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)payChoseBtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 10://余额支付
        {
            if (value) {
                if ((_dict2.appBalance +value.floatValue)*100>= _dict2.fee*100) {
                    
                }else{
                    [MBProgressHUD showError:@"余额+优惠券不足以支付缴费金额"];
                    return;
                }
            }else{
                if (_dict2.appBalance*100>= _dict2.fee*100) {
                    
                }else{
                    [MBProgressHUD showError:@"余额不足以支付缴费金额"];
                    return;
                }
            }

            
            
            _payElectricityFeeView.balancePayImg.image = [UIImage imageNamed:@"ser_icon_choice"];
            _payElectricityFeeView.zhifubaoPayImg.image = [UIImage imageNamed:@"形状-120-副本-3"];
            _payElectricityFeeView.weiChatPayImg.image = [UIImage imageNamed:@"形状-120-副本-3"];

            payType = 1;
        }

            break;
        case 20://支付宝支付
        {
            _payElectricityFeeView.zhifubaoPayImg.image = [UIImage imageNamed:@"ser_icon_choice"];
            _payElectricityFeeView.balancePayImg.image = [UIImage imageNamed:@"形状-120-副本-3"];
            _payElectricityFeeView.weiChatPayImg.image = [UIImage imageNamed:@"形状-120-副本-3"];

            payType = 2;

        }
            break;
        case 30://微信支付
        {
            _payElectricityFeeView.weiChatPayImg.image = [UIImage imageNamed:@"ser_icon_choice"];
            _payElectricityFeeView.balancePayImg.image = [UIImage imageNamed:@"形状-120-副本-3"];
            _payElectricityFeeView.zhifubaoPayImg.image = [UIImage imageNamed:@"形状-120-副本-3"];
            
            payType = 3;
            
        }
            break;
        default:
            break;
    }
}
- (void)couponBtnClick:(UIButton *)btn{
    UseDeductionVoucherViewController *page = [[UseDeductionVoucherViewController alloc]init];
    if (voucherId) {
        page.voucherId = voucherId;
    }
    if (_dict2) {
        page.dataArry = _dict2.spendableVoucher;
    }
    [self.navigationController pushViewController:page animated:YES];
}
- (void)voucherNotification:(NSNotification *)notifi{
    VoucherListList *oncedict =(VoucherListList *) notifi.userInfo;
    voucherId = oncedict.ids;
    _payElectricityFeeView.couponNum.text = [NSString stringWithFormat:@"抵扣%@元",oncedict.value];//oncedict.describe;
    [_payElectricityFeeView.couponNum setTextColor:RGBCOLOR(0, 167, 255)];
    value = oncedict.value;
    if ((_dict2.appBalance +value.floatValue)*100>= _dict2.fee*100) {
        [_payElectricityFeeView.balance setTextColor:RGBCOLOR(48, 48, 48)];
    }else{
        [_payElectricityFeeView.balance setTextColor:RGBCOLOR(156, 156, 156)];
//        [MBProgressHUD showError:@"余额+优惠券不足以支付交费金额"];
    }
    _payElectricityFeeView.payMoney.text = [NSString stringWithFormat:@"%.2f", _dict2.fee - [value floatValue]];

}
- (void)payMoneyWithWeixin{
    [MBProgressHUD showMessage:@"充值中..."];
    NSDictionary *dict;
    NSString *urlStr;
    if (voucherId) {
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":_dict2.accountNo,@"fee":self.acount.text,@"voucherId":voucherId,@"payway":@"3"};
    }else{
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":_dict2.accountNo,@"fee":self.acount.text,@"payway":@"3"};
    }
    
    urlStr = @"postPayBill/applyPayInfo";
    [ZTHttpTool postWithUrl:urlStr param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]== 0) {
            [MBProgressHUD hideHUD];
            [self weixinPay:[DictToJson dictionaryWithJsonString:str][@"form"][@"payInfoWx"]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[DictToJson dictionaryWithJsonString:str][@"form"][@"payLogId"] forKey:@"payLogId"];
//            payLogId = [DictToJson dictionaryWithJsonString:str][@"form"][@"payLogId"];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
}
- (IBAction)payMoneyWithAliPay{
    
    [MBProgressHUD showMessage:@"充值中..."];
    NSDictionary *dict;
    NSString *urlStr;
    if (voucherId) {
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":_dict2.accountNo,@"fee":self.acount.text,@"voucherId":voucherId};
    }else{
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":_dict2.accountNo,@"fee":self.acount.text};
    }

    urlStr = @"postPayBill/applyPayInfo";
    [ZTHttpTool postWithUrl:urlStr param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]== 0) {
            [MBProgressHUD hideHUD];
            [self aliPay:[DictToJson dictionaryWithJsonString:str][@"form"][@"payInfo"]];
            payLogId = [DictToJson dictionaryWithJsonString:str][@"form"][@"payLogId"];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
    
}
-(void)aliPay:(NSString *)payInfo{
   
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:payInfo fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"你已成功完成缴费操作！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 20;
            [alert show];
        }else{
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"未成功缴费，请选择重新支付" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 30;
            [alert show];
        }
        NSLog(@"reslut = %@",resultDic);
    }];
}
- (void)weixinPay:(NSDictionary *)dict{
    
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showError:@"您的手机未安装微信"];
        return;
    }
    
    [WXApi registerApp:dict[@"appid"]];
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = dict[@"appid"];
    
    // 商家id，在注册的时候给的
    req.partnerId = dict[@"partnerid"];
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = dict[@"prepayid"];
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = dict[@"package"];
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = dict[@"noncestr"];
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = dict[@"timestamp"];
    req.timeStamp = (UInt32)stamp.integerValue;
    
    // 这个签名也是后台做的
    req.sign = dict[@"sign"];
    
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
}
- (void)weixinPaySuccess{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
