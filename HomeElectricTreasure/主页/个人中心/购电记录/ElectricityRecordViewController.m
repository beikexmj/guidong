//
//  ElectricityRecordViewController.m
//  copooo
//
//  Created by 夏明江 on 2017/2/3.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ElectricityRecordViewController.h"
#import "SafeCenterTableViewCell.h"
#import "ElectricityBuyRecordTwoViewController.h"
#import "ElectricityBuyRecordViewController.h"

@interface ElectricityRecordViewController ()

@end

@implementation ElectricityRecordViewController

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
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"SafeCenterTableViewCell";
    SafeCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.typeLabel.text = @"购电记录";
        cell.icon.image = [UIImage imageNamed:@"per_record_icon1"];
        cell.viewToLeft.constant = 12;
        cell.typeSubLabel.text = @"预付费电卡查询通道";
    }else if(indexPath.row == 1){
        cell.typeLabel.text = @"缴费记录";
        cell.viewToLeft.constant = 0;
        cell.icon.image = [UIImage imageNamed:@"per_record_icon2"];
        cell.typeSubLabel.text = @"后付费电卡查询通道";
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
        ElectricityBuyRecordViewController *page = [[ElectricityBuyRecordViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.row == 1){
        ElectricityBuyRecordTwoViewController *page = [[ElectricityBuyRecordTwoViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
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
