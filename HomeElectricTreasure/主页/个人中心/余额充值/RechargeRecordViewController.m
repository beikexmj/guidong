//
//  RechargeRecordViewController.m
//  copooo
//
//  Created by 夏明江 on 2016/12/15.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "RechargeRecordTableViewCell.h"
#import "RechargeRecordDataModel.h"
#import "UITableView+WFEmpty.h"

@interface RechargeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray <RechargeRecordList *>*myArray;
@end

@implementation RechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _myArray = [NSMutableArray array];
    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
-(void)fetchData{
    
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"page":@"0",@"pagesize":@"1000"};
    
    [ZTHttpTool postWithUrl:@"user/queryUserOrderHistory" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        RechargeRecordDataModel *rechargeRecord = [RechargeRecordDataModel mj_objectWithKeyValues:str];
        if (rechargeRecord.rcode == 0) {
            [_myArray addObjectsFromArray:rechargeRecord.form.list];
            if (_myArray.count ==0) {
//                [MBProgressHUD showError:@"没有数据"];
                [self.myTableView addEmptyViewWithImageName:@"购电记录-缴费记录" title:@"暂无充值记录"];
                [self.myTableView.emptyView setHidden:NO];
                
            }else{
                [self.myTableView.emptyView setHidden:YES];
                _totalMoney.text = rechargeRecord.form.sum;
                [self.myTableView reloadData];
            }
        }else{
            [self.myTableView addEmptyViewWithImageName:@"购电记录-缴费记录" title:@"暂无充值记录"];
            [self.myTableView.emptyView setHidden:NO];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        [self.myTableView.emptyView setHidden:NO];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"RechargeRecordTableViewCell";
    RechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    cell.time.text = _myArray[indexPath.row].paytime;
    cell.money.text =[NSString stringWithFormat:@"%@",_myArray[indexPath.row].amount];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
