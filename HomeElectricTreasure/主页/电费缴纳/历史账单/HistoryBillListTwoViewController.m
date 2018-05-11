//
//  HistoryBillListTwoViewController.m
//  copooo
//
//  Created by 夏明江 on 2017/1/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "HistoryBillListTwoViewController.h"
#import "ElectricityUseDetailTableViewCell.h"
#import "ElectricityUseSearchModel.h"
#import "ElectricityCardHistoryListBillDataModel.h"
#import "UITableView+WFEmpty.h"

@interface HistoryBillListTwoViewController ()
{
    NSInteger year;

}
@property (nonatomic,strong)NSMutableArray <ElectricityCardHistoryListBillDataList *> *myArray;
@end

@implementation HistoryBillListTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _myArray = [NSMutableArray array];
    NSDate * date = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp1 = [myCal components:units fromDate:date];
    year = [comp1 year];
    self.yearLabel.text = [NSString stringWithFormat:@"%ld年",year];

    //    self.headerSubView.layer.cornerRadius = 5;
    //    [self initOtherData];
    
    [self fetchData:0];//0 不变 1 year-- 2 year++;

    // Do any additional setup after loading the view from its nib.
}
-(void)fetchData:(NSInteger)flag{
    
    
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"year":[NSString stringWithFormat:@"%ld",year],@"accountNo":self.accountNo};
    [MBProgressHUD showMessage:@""];
    [ZTHttpTool postWithUrl:@"postPayBill/queryHistoryBill" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityCardHistoryListBillDataModel *electricityCard = [ElectricityCardHistoryListBillDataModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {
            [_myArray removeAllObjects];
            [_myArray addObjectsFromArray:electricityCard.form.list];
            if (_myArray.count == 0) {
                //                //button事件year增减回去。
                //                if (flag == 1) {
                //                    year++;
                //                }else if (flag ==2){
                //                    year--;
                //                }
                [self.myTableView addEmptyViewWithImageName:@"历史账单" title:@"暂无历史账单"];
                self.myTableView.emptyView.hidden = NO;
                
            }else{
                self.myTableView.emptyView.hidden = YES;
            }
            [self resetData];
            [self.myTableView reloadData];
        }else{
            //button事件year增减回去。
            if (flag == 1) {
                year++;
            }else if (flag ==2){
                year--;
            }
            [self.myTableView addEmptyViewWithImageName:@"历史账单" title:@"暂无历史账单"];
            self.myTableView.emptyView.hidden = NO;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;

    }];
    
}
-(void)resetData{
    
    self.yearLabel.text = [NSString stringWithFormat:@"%ld年",year];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"ElectricityUseDetailTableViewCell";
    ElectricityUseDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    ElectricityCardHistoryListBillDataList * list = _myArray[indexPath.row];
    cell.day.text = [NSString stringWithFormat:@"%@月",list.month];
    cell.elecNum.text = [NSString stringWithFormat:@"%.1f",[list.electrictyAmount floatValue]];
    cell.elecPrice.text = [NSString stringWithFormat:@"%.2f",[list.electrictyFee floatValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _myArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)NextOrBeforeYearBtnClick:(id)sender{
    UIButton * button = sender;
    if (button.tag == 10) {
        year--;
        [self fetchData:1];//0 不变 1 year-- 2 year++;
    }else{
        year++;
        [self fetchData:2];//0 不变 1 year-- 2 year++;
    }

}
- (IBAction)backlBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
