//
//  ElectricityBuyRecordViewController.m
//  copooo
//
//  Created by 夏明江 on 2016/10/25.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityBuyRecordViewController.h"
#import "ElectricityBuyRecordTableViewCell.h"
#import "ElectricityBuyRecordDataModel.h"
#import "UITableView+WFEmpty.h"

@interface ElectricityBuyRecordViewController ()
@property (nonatomic,strong)NSMutableArray *myArray;
@end

@implementation ElectricityBuyRecordViewController

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
    
    NSDate * date = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp1 = [myCal components:units fromDate:date];
    NSInteger month = [comp1 month];
    NSInteger year = [comp1 year];
    NSInteger day = [comp1 day];

    NSString *startTime = [NSString stringWithFormat:@"%ld-%ld-%ld",year-3,month,day];
    NSString *endTime = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];

    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"beginDate":startTime,@"endDate":endTime,@"page":@"0",@"pagesize":@"1000"};
    
    [ZTHttpTool postWithUrl:@"user/electricPayLog/payLog" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityBuyRecordDataModel *electricityCard = [ElectricityBuyRecordDataModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {
            [_myArray addObjectsFromArray:electricityCard.form.list];
            if (_myArray.count ==0) {
//                [MBProgressHUD showError:@"没有数据"];
                [self.myTableView addEmptyViewWithImageName:@"购电记录-缴费记录" title:@"暂无购电记录"];
                [self.myTableView.emptyView setHidden:NO];
            }else{
                _totalMoney.text = electricityCard.form.countMoney;
                if ([_totalMoney.text isEqualToString:@"null"]) {
                    _totalMoney.text = @"0.00";
                }
                [self.myTableView.emptyView setHidden:YES];

                [self.myTableView reloadData];
            }
        }else{
            [self.myTableView addEmptyViewWithImageName:@"购电记录-缴费记录" title:@"暂无购电记录"];
            [self.myTableView.emptyView setHidden:NO];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        [self.myTableView.emptyView setHidden:NO];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"ElectricityBuyRecordTableViewCell";
    ElectricityBuyRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    ElectricityBuyRecordList * list  = _myArray[indexPath.row];
    cell.money.text = [NSString stringWithFormat:@"购电 %@ 元",list.money];
    cell.time.text = list.time;
    cell.ElecCardNo.text = [NSString stringWithFormat:@"购电账户编号:%@",list.accountNo];
    NSMutableAttributedString * moneyAttriStr = [[NSMutableAttributedString alloc] initWithString:cell.money.text];
    cell.money.tintColor = [UIColor colorWithRed:96.0/255 green:96.0/255 blue:96.0/255 alpha:1];
    //设置字号
    [moneyAttriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(3, [moneyAttriStr length]-5)];
    //设置文字颜色
    [moneyAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:167.0/255  blue:255.0/255 alpha:1] range:NSMakeRange(3, [moneyAttriStr length]-5)];
    cell.money.attributedText = moneyAttriStr;
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
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
