//
//  SafeCenterViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "SafeCenterViewController.h"
#import "SafeCenterTableViewCell.h"
#import "ModifyLoginPasswordFirstStepViewController.h"
#import "ModifyPaymentPasswordFirstStepViewController.h"
@interface SafeCenterViewController ()

@end

@implementation SafeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    // Do any additional setup after loading the view from its nib.
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
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"SafeCenterTableViewCell";
    SafeCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.typeLabel.text = @"修改登录密码";
        cell.icon.image = [UIImage imageNamed:@"per_safe_icon_login"];
        cell.viewToLeft.constant = 12;
    }else if(indexPath.row == 1){
        cell.typeLabel.text = @"修改支付密码";
        cell.viewToLeft.constant = 0;
        cell.icon.image = [UIImage imageNamed:@"per_safe_icon_pay"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
            ModifyLoginPasswordFirstStepViewController *page = [[ModifyLoginPasswordFirstStepViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.row == 1){
           ModifyPaymentPasswordFirstStepViewController *page = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
    }
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
