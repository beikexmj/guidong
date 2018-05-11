//
//  SignViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/9.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "SignViewController.h"
#import "SignView.h"
#import "SignDetailDataModel.h"
@interface SignViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong)SignView *signView;
@property (nonatomic,strong)SignDetailForm *myDict;
@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.myView addSubview:myScrollView];
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 750);
    _signView = [[[NSBundle mainBundle] loadNibNamed:@"SignView" owner:nil options:nil] lastObject];
    _signView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 750);
    [myScrollView addSubview:_signView];
    _signView.nickName.text = [StorageUserInfromation storageUserInformation].nickname;
    [_signView.signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_signView.sevenDayGiftBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_signView.fifteenGiftBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_signView.thirtyGiftBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self fetchImg];
    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
- (void)fetchImg{
    NSString * str = [NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"res/avatar?userId=",[StorageUserInfromation storageUserInformation].userId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str] options:NSDataReadingUncached error:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            _signView.headerImg.image = [UIImage imageWithData:data];
        });
    });
    
}

-(void)fetchData{
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"sign/detail" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        SignDetailDataModel *signDetail = [SignDetailDataModel mj_objectWithKeyValues:str];
        if (signDetail.rcode == 0) {
            _myDict = signDetail.form;
            [self dataWithSuface];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        
    }];
}


- (void)signBtnClick:(UIButton*)btn{
    switch (btn.tag) {
        case 10:
        {
            [self fetchSignData];
        }
            break;
        case 20:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"领取成功" message:@"恭喜您，你已成功领取\"7天礼包\"！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 200;
            [alert show];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:@"已领取" forState:UIControlStateNormal];
            [btn setTitleColor:RGBCOLOR(156, 156, 156) forState:UIControlStateNormal];
        }
            break;
            
        case 30:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"领取成功" message:@"恭喜您，你已成功领取\"15天礼包\"！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 300;
            [alert show];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:@"已领取" forState:UIControlStateNormal];
            [btn setTitleColor:RGBCOLOR(156, 156, 156) forState:UIControlStateNormal];
        }
            break;
            
        case 40:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"领取成功" message:@"恭喜您，你已成功领取\"满月礼包\"！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 400;
            [alert show];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:@"已领取" forState:UIControlStateNormal];
            [btn setTitleColor:RGBCOLOR(156, 156, 156) forState:UIControlStateNormal];
        }
            break;
            
    
        default:
            break;
    }
}
- (void)fetchSignData{
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"username":[StorageUserInfromation storageUserInformation].username};
    
    [ZTHttpTool postWithUrl:@"sign" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        [MBProgressHUD hideHUD];
        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        
        if ([onceDict[@"rcode"] integerValue] == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"签到成功" message:@"恭喜您，你已成功签到！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 10;
            [alert show];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"签到失败" message:@"抱歉，请重新签到！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            alert.tag = 20;
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
        
        
    }];
    

}
- (void)dataWithSuface{
    _signView.signDay.text = _myDict.continuity;
    [self button:_signView.sevenDayGiftBtn integer:_myDict.week];
    [self button:_signView.fifteenGiftBtn integer:_myDict.halfMonth];
    [self button:_signView.thirtyGiftBtn integer:_myDict.month];
    [_signView setDataArry:_myDict.list];
}

- (void)button:(UIButton *)btn integer:(NSInteger)integer{
    switch (integer) {
        case 0://不能领取
        {
            btn.backgroundColor = RGBCOLOR(96, 96, 96);
            [btn setTitle:@"点击领取" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
        }
            break;
        case 1://可以领取
        {
            btn.backgroundColor = RGBCOLOR(0, 167, 255);
            [btn setTitle:@"点击领取" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
        }
            break;
        case 2://已领取
        {
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:@"已领取" forState:UIControlStateNormal];
            [btn setTitleColor:RGBCOLOR(156, 156, 156) forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
        }
            break;
    
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            [_signView.signBtn setBackgroundColor:RGBCOLOR(156, 156, 156)];
            _signView.signBtn.userInteractionEnabled = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
            [self fetchData];
        }
    }else if (alertView.tag == 20){
        
    }
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
@end
