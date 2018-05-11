//
//  IntegralViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/2.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralTableViewCell.h"
#import "ChangeIntegralViewController.h"
#import "PointRuleListDataModel.h"
@interface IntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray <PointRuleListList *> *dataArry;
@end

@implementation IntegralViewController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArry = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(integralChangeSuccessNotification:) name:@"IntegralChangeSuccess" object:nil];
    
    SDWebImageDownloader *sdmanager = [SDWebImageManager sharedManager].imageDownloader;
    [sdmanager setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sdmanager setValue:@"zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4" forHTTPHeaderField:@"Accept-Language"];
    [self fetchData];

    // Do any additional setup after loading the view from its nib.
}
-(void)fetchData{
    [_dataArry removeAllObjects];
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"point/rule/list" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        PointRuleListDataModel *pointRuleList = [PointRuleListDataModel mj_objectWithKeyValues:str];
        if (pointRuleList.rcode == 0) {
            NSArray<PointRuleListList*> * myArray = pointRuleList.form.list;
            [_dataArry addObjectsFromArray:myArray];
            self.integralNum.text = pointRuleList.form.mypoint;
            StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
            storage.point = pointRuleList.form.mypoint;
            [self.myTabelView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"IntegralTableViewCell";
    IntegralTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (_dataArry.count>0) {
        PointRuleListList *list = _dataArry[indexPath.row];
        cell.integralDescription.text = [NSString stringWithFormat:@"%@积分兑换%@元电费",list.point,list.fee];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,list.image];
        [cell.integralImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
        
        if (self.integralNum.text.integerValue >= list.point.integerValue) {
            cell.lackOfIntegration.hidden = YES;
            cell.changeIntegralBtn.userInteractionEnabled = YES;
            cell.changeIntegralBtn.tag = indexPath.row;
            [cell.changeIntegralBtn addTarget:self action:@selector(changeInetegralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.lackOfIntegration.hidden = NO;
        [cell.changeIntegralBtn setBackgroundImage:[UIImage imageNamed:@"vouchers_button2"] forState:UIControlStateNormal];
            cell.changeIntegralBtn.userInteractionEnabled = NO;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArry.count;
}
- (void)changeInetegralBtnClick:(UIButton*)btn{
    ChangeIntegralViewController *page = [[ChangeIntegralViewController alloc]init];
    page.pointRuleListList = _dataArry[btn.tag];
    [self.navigationController pushViewController:page animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)integralChangeSuccessNotification:(NSNotification *)notification{
    [_dataArry removeAllObjects];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"point/rule/list" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        PointRuleListDataModel *pointRuleList = [PointRuleListDataModel mj_objectWithKeyValues:str];
        if (pointRuleList.rcode == 0) {
            NSArray<PointRuleListList*> * myArray = pointRuleList.form.list;
            [_dataArry addObjectsFromArray:myArray];
            self.integralNum.text = pointRuleList.form.mypoint;
            StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
            storage.point = pointRuleList.form.mypoint;
            [self.myTabelView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
