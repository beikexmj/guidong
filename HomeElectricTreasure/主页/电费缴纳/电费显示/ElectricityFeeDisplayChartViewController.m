//
//  ElectricityFeeDisplayChartViewController.m
//  copooo
//
//  Created by 夏明江 on 2017/2/23.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ElectricityFeeDisplayChartViewController.h"
#import "ElectricityFeeDisplayBackView.h"
@interface ElectricityFeeDisplayChartViewController ()

@end

@implementation ElectricityFeeDisplayChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  ElectricityFeeDisplayBackView *efdbview = [[[NSBundle mainBundle] loadNibNamed:@"ElectricityFeeDisplayBackView" owner:self options:nil] lastObject];
    [self.view addSubview:efdbview];
    [efdbview addData:_eleFeePaymentDict];
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
@end
