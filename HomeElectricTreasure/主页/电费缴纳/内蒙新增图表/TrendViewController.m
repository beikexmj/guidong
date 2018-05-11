//
//  TrendViewController.m
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/10.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "TrendViewController.h"
#import "MonthViewController.h"
#import "QuarterViewController.h"
#import "YearViewController.h"
#import "MyRankingViewController.h"
#import "ElectricUserPointTrendDataModel.h"
#import "ElectricUserQueryOtherByDataModel.h"
#import "ElectricUserMonthTrendDataModel.h"
#import "ElectricUserQuarterTrendDataModel.h"
#import "ElectricUserYearTrendDataModel.h"

@interface TrendViewController ()
{
    MonthViewController *monthViewController;
    QuarterViewController *quarterViewController;
    YearViewController *yearViewController;
}
@property (nonatomic,strong)ElectricUserPointTrendData *electricUserPointTrendData;
@property (nonatomic,strong)ElectricUserQueryOtherByData *electricUserQueryOtherByData;
@property (nonatomic,strong)ElectricUserMonthTrendDataModel *electricUserMonthTrend;
@property (nonatomic,strong)ElectricUserQuarterTrendDataModel *electricUserQuarterTrend;
@property (nonatomic,strong)ElectricUserYearTrendDataModel *electricUserYearTrend;

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
    }
    self.navigationController.navigationBar.hidden = YES;
    monthViewController = [[MonthViewController alloc]init];
    [self addChildViewController:monthViewController];
    
    quarterViewController = [[QuarterViewController alloc]init];
    [self addChildViewController:quarterViewController];
    
    yearViewController = [[YearViewController alloc]init];
    [self addChildViewController:yearViewController];
    
    _electricUserMonthTrend = [[ElectricUserMonthTrendDataModel alloc]init];
    _electricUserQuarterTrend = [[ElectricUserQuarterTrendDataModel alloc]init];
    _electricUserYearTrend = [[ElectricUserYearTrendDataModel alloc]init];
    if ([self.cardType integerValue] == 9) {
        self.monthFatherView.hidden = YES;
        self.trendChoseViewConstrant.constant  = 144;
    }else{
        
    }
    
    [self fetchData];
   
    // Do any additional setup after loading the view from its nib.
}
- (void)fetchData{
    [MBProgressHUD showMessage:@"数据加载中..."];
    [ZTHttpTool sendGroupPostRequest:^{
        NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":_accountNo,@"type":[self.cardType integerValue] == 9?@"2":@"1"};
        [ZTHttpTool postWithUrl:@"user/electricUser/pointTrend" param:dict success:^(id responseObj) {
            NSLog(@"%@",[responseObj mj_JSONObject]);
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSLog(@"%@",str);
            NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
            ElectricUserPointTrendDataModel * electricUserPointTrend = [ElectricUserPointTrendDataModel mj_objectWithKeyValues:str];
            if (electricUserPointTrend.rcode == 0) {
                _electricUserPointTrendData = electricUserPointTrend.form;
            }else{
                
            }
        } failure:^(NSError *error) {
            
        }];
//        [ZTHttpTool postWithUrl:@"user/electricUser/queryOtherByData" param:dict success:^(id responseObj) {
//            NSLog(@"%@",[responseObj mj_JSONObject]);
//            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
//            NSLog(@"%@",str);
//            NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
//            ElectricUserQueryOtherByDataModel * electricUserQueryOtherByData = [ElectricUserQueryOtherByDataModel mj_objectWithKeyValues:str];
//            if (electricUserQueryOtherByData.rcode == 0) {
//                _electricUserQueryOtherByData = electricUserQueryOtherByData.form;
//            }else{
//
//            }
//        } failure:^(NSError *error) {
//
//        }];
    } success:^{
        [MBProgressHUD hideHUD];
        [self reBuildData];

    } failure:^(NSArray *errorArray) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];

    }];
}

-(void)reBuildData{
    if (_electricUserPointTrendData) {
        _electricUserMonthTrend.pointTrendMonth = _electricUserPointTrendData.pointTrendMonth;
//        _electricUserMonthTrend.elecPrice = _electricUserQueryOtherByData.elecPrice;
//        _electricUserMonthTrend.month = _electricUserQueryOtherByData.historyContrast.month;
        
        _electricUserQuarterTrend.pointTrendQuarter = _electricUserPointTrendData.pointTrendQuarter;
//        _electricUserQuarterTrend.quarter = _electricUserQueryOtherByData.historyContrast.quarter;
        
        _electricUserYearTrend.pointTrendYear = _electricUserPointTrendData.pointTrendYear;
//        _electricUserYearTrend.year = _electricUserQueryOtherByData.historyContrast.year;
        monthViewController.electricUserMonthTrend = _electricUserMonthTrend;
        yearViewController.electricUserYearTrend = _electricUserYearTrend;
        quarterViewController.electricUserQuarterTrend = _electricUserQuarterTrend;
        if ([self.cardType integerValue] == 9) {
            [self trendBtnLick:_quarterBtn];
        }else{
            [self.contentSubView addSubview:monthViewController.view];

        }
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

- (IBAction)trendBtnLick:(id)sender {
    [self.contentSubView subviews];
    for (UIView *subView in self.contentSubView.subviews) {
        [subView removeFromSuperview];
    }
    UIColor *color1 = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    UIColor *color2 = [UIColor whiteColor];
    UIColor *color3 = [UIColor colorWithRed:0 green:167/255.0 blue:255/255.0 alpha:1];
    [self.monthBtn.titleLabel setTextColor:color1];
    [self.quarterBtn.titleLabel setTextColor:color1];
    [self.yearBtn.titleLabel setTextColor:color1];
    self.monthView.backgroundColor = color2;
    self.quarterView.backgroundColor = color2;
    self.yearView.backgroundColor = color2;
    UIButton *btn = sender;
    [btn setTitleColor:color3 forState:UIControlStateNormal];
    
    if (sender == _monthBtn) {
        if (_electricUserMonthTrend.pointTrendMonth) {
            [self.contentSubView addSubview:monthViewController.view];
            _monthView.backgroundColor = color3;
        }else{
            [MBProgressHUD showError:@"无网络连接"];
        }
    }else if (sender == _quarterBtn){
        [self.contentSubView addSubview:quarterViewController.view];
        _quarterView.backgroundColor = color3;
    }else if (sender == _yearBtn){
        [self.contentSubView addSubview:yearViewController.view];
        _yearView.backgroundColor = color3;
    }
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rankingListBtnClick:(id)sender {
    MyRankingViewController *page= [[MyRankingViewController alloc]init];
    page.accountNo = _accountNo;
    page.cardType = self.cardType;
    [self.navigationController pushViewController:page animated:YES];
}
@end
