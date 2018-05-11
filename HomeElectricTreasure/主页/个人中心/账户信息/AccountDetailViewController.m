//
//  AccountDetailViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/9.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "IntegralDetailTableViewCell.h"
#import "HooDatePicker/HooDatePicker.h"
#import "BalanceDetailDataModel.h"
#import "UITableView+WFEmpty.h"
@interface AccountDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HooDatePickerDelegate>
@property (nonatomic, strong) HooDatePicker *datePicker;
@property (nonatomic,strong)NSMutableArray <BalanceDetailDataList*> *dataArry;

@end

@implementation AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [self datePickerInit];
    _dataArry = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *selectDate = [dateFormatter stringFromDate:[NSDate date]];
    [_yearChoseBtn setTitle:[NSString stringWithFormat:@"%@年",selectDate] forState:UIControlStateNormal];
    [self fetchData:selectDate];
    // Do any additional setup after loading the view from its nib.
}
-(void)datePickerInit{
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeYear;
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
    NSDate *maxDate = [dateFormatter dateFromString:@"2050-01-01"];
    NSDate *minDate = [dateFormatter dateFromString:@"2010-01-01"];
    
    [self.datePicker setDate:[NSDate date] animated:YES];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
}
-(void)fetchData:(NSString*)dateStr{

    [_dataArry removeAllObjects];
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"year":dateStr};
    
    [ZTHttpTool postWithUrl:@"balance/detail" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        BalanceDetailDataModel *balanceDetailData = [BalanceDetailDataModel mj_objectWithKeyValues:str];
        if (balanceDetailData.rcode == 0) {
            NSArray<BalanceDetailDataList*> * myArray = balanceDetailData.form.list;
            [_dataArry addObjectsFromArray:myArray];
//            for (UIView * myView in self.myTableView.subviews) {
//                if ([myView isEqual:self.myTableView.emptyView]) {
//                    [myView removeFromSuperview];
//                }
//            }
            if (_dataArry.count == 0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无账单" title:@"暂无账单"];
                self.myTableView.emptyView.hidden = NO;
            }else{
                self.myTableView.emptyView.hidden = YES;

            }
            [self.myTableView reloadData];

        }else{
            [self.myTableView addEmptyViewWithImageName:@"暂无账单" title:@"暂无账单"];
            self.myTableView.emptyView.hidden = NO;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"IntegralDetailTableViewCell";
    IntegralDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    if (_dataArry.count>0) {
        BalanceDetailDataList *list = _dataArry[indexPath.section];
        BalanceDetailDataListList* detail = list.detail[indexPath.row];
        cell.type.text = detail.reason;
        cell.time.text = [NSString stringWithFormat:@"%@/%@/%@",detail.year,detail.month,detail.day];
        cell.num.text = detail.amountStr;
        if (detail.type == 1) {
            cell.symbol.text = @"+";
            [cell.symbol setTextColor:RGBCOLOR(0, 167, 255)];
            [cell.num setTextColor:RGBCOLOR(0, 167, 255)];
        }else{
            cell.symbol.text = @"-";
            [cell.symbol setTextColor:RGBCOLOR(48, 48, 48)];
            [cell.num setTextColor:RGBCOLOR(48, 48, 48)];

        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numWidth.constant = [cell.num sizeThatFits:CGSizeMake(SCREEN_WIDTH, 25)].width;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BalanceDetailDataList *list = _dataArry[section];
    return  list.detail.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArry.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 100, 30)];
    [myLabel setTextColor:RGBCOLOR(156, 156, 156)];
    myLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:myLabel];
    if (_dataArry.count>0) {
        BalanceDetailDataList *list = _dataArry[section];
        myLabel.text = [NSString stringWithFormat:@"%@月",list.month];
    }

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, SCREEN_WIDTH-15, 1)];
    lineView.backgroundColor = RGBCOLOR(221, 221, 221);
    [view addSubview:lineView];
    return view;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    UITableView *tableview = (UITableView *)scrollView;
    CGFloat sectionHeaderHeight = 60;
    CGFloat sectionFooterHeight = 60;
    CGFloat offsetY = tableview.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight) {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight) {
        tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height) {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
    }
    
}
- (IBAction)yearChoseBtnClick:(id)sender {
    
    [self.datePicker setDate:[NSDate date] animated:YES];
    [self.datePicker show];
}
- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    
    [dateFormatter setDateFormat:@"yyyy年"];
    
    NSString *selectDate = [dateFormatter stringFromDate:date];
    NSLog(@"selectDate:%@",selectDate);
    [_yearChoseBtn setTitle:selectDate forState:UIControlStateNormal];
    
    [self fetchData:[selectDate substringToIndex:[selectDate length]-1]];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
