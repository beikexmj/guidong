//
//  UseDeductionVoucherViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "UseDeductionVoucherViewController.h"
#import "UseDeductionVoucherTableViewCell.h"
#import "UITableView+WFEmpty.h"
@interface UseDeductionVoucherViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation UseDeductionVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
//    _dataArry = [NSMutableArray array];
//   NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"status":@"0"};
//    [self fetchData:dict];
   
    // Do any additional setup after loading the view from its nib.
}
//-(void)fetchData:(NSDictionary *)dict{
//    [_dataArry removeAllObjects];
//    [MBProgressHUD showMessage:@""];
//    [ZTHttpTool postWithUrl:@"voucher/list" param:dict success:^(id responseObj) {
//        NSLog(@"%@",[responseObj mj_JSONObject]);
//        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
//        NSLog(@"%@",str);
//        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
//        [MBProgressHUD hideHUD];
//        VoucherListDataModel *voucherList = [VoucherListDataModel mj_objectWithKeyValues:str];
//        for (UIView * myView in self.myTableView.subviews) {
//            if ([myView isEqual:self.myTableView.emptyView]) {
//                [myView removeFromSuperview];
//            }
//        }
//        if (voucherList.rcode == 0) {
//            NSArray<VoucherListList*> * myArray = voucherList.form.list;
//            [_dataArry addObjectsFromArray:myArray];
//            if (_dataArry.count == 0) {
//                [self.myTableView addEmptyViewWithImageName:@"vouchers_icon_none" title1:@"很遗憾" title2:@"你暂无可以使用的优惠券"];
//            }else{
//                [self.myTableView reloadData];
//            }
//        }else{
//            [MBProgressHUD showError:@"数据加载异常"];
//        };
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"数据加载异常"];
//
//    }];
//}

- (void)viewWillAppear:(BOOL)animated{
    if (_dataArry.count == 0) {
        [self.myTableView addEmptyViewWithImageName:@"暂无抵扣券" title1:@"很遗憾" title2:@"你暂无可以使用的抵扣券"];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *mycell = @"UseDeductionVoucherTableViewCell";
    
    UseDeductionVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:mycell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArry.count > 0) {
        SpendableVoucher *list = _dataArry[indexPath.row];
        cell.integralTitle.text = list.describe;
        cell.periodOfValidity.text = list.deadline;
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,list.image];
        [cell.integralImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
        if (_voucherId) {
            if ([_voucherId isEqualToString:list.ids]) {
                cell.choseImg.image = [UIImage imageNamed:@"ser_icon_choice"];
            }else{
                cell.choseImg.image = [UIImage imageNamed:@"ser_icon_un_choice"];
            }
        }
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SpendableVoucher *list = _dataArry[indexPath.row];
    _voucherId = list.ids;
    [self.myTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"voucher" object:self userInfo:(NSDictionary *)list];
    [self.navigationController popViewControllerAnimated:YES];
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
