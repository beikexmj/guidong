//
//  ElectricityUseDetailViewController.m
//  copooo
//
//  Created by 夏明江 on 2016/10/27.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityUseDetailViewController.h"
#import "ElectricityUseDetailTableViewCell.h"
#import "ElectricityUseSearchModel.h"
#import "ElectricityUseSearchTwoModel.h"
#import "UITableView+WFEmpty.h"

@interface ElectricityUseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray <ElectricityUseSearchForm *>* myArray;
@property (nonatomic,strong)NSMutableArray <ElectricityUseSearchTwoList *>* myArrayTwo;

@end

@implementation ElectricityUseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _myArray = [NSMutableArray array];
    _myArrayTwo = [NSMutableArray array];

    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
-(void)fetchData{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":self.elecCardNo,@"beginDate":self.startTime,@"endDate":self.endTime,@"page":@"0",@"pagesize":@"1200"};
    NSString * strUrl;
    if ([self.cardTpye integerValue] == 9) {
        strUrl = @"postPayBill/queryElectricityConsumeDetail";
    }else{
        strUrl = @"user/electricUser/electroDetail";
    }
    [MBProgressHUD showMessage:@""];
    [ZTHttpTool postWithUrl:strUrl param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        
        if ([self.cardTpye integerValue] == 9) {
            ElectricityUseSearchTwoModel *electricityCard = [ElectricityUseSearchTwoModel mj_objectWithKeyValues:str];
            if (electricityCard.rcode == 0) {
                [_myArrayTwo addObjectsFromArray:electricityCard.form.list];
                if (_myArrayTwo.count ==0) {
//                    [MBProgressHUD showError:@"没有数据"];
                    [self.myTableView addEmptyViewWithImageName:@"该时段暂无用电记录" title:@"该时段暂无用电记录"];
                    self.myTableView.emptyView.hidden = NO;

                }else{
                    self.myTableView.emptyView.hidden = YES;
                    [self.myTableView reloadData];
                }
            }else{
                [self.myTableView addEmptyViewWithImageName:@"该时段暂无用电记录" title:@"该时段暂无用电记录"];
                self.myTableView.emptyView.hidden = NO;
            }
        }else{
            ElectricityUseSearchModel *electricityCard = [ElectricityUseSearchModel mj_objectWithKeyValues:str];
            if (electricityCard.rcode == 0) {
                [_myArray addObjectsFromArray:electricityCard.form];
                if (_myArray.count ==0) {
                    [self.myTableView addEmptyViewWithImageName:@"该时段暂无用电记录" title:@"该时段暂无用电记录"];
                    self.myTableView.emptyView.hidden = NO;
                    
                }else{
                    self.myTableView.emptyView.hidden = YES;
                    [self.myTableView reloadData];
                }
            }else{
                [self.myTableView addEmptyViewWithImageName:@"该时段暂无用电记录" title:@"该时段暂无用电记录"];
                self.myTableView.emptyView.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;
    }];
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
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"ElectricityUseDetailTableViewCell";
    ElectricityUseDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    if ([self.cardTpye integerValue] == 9) {
        ElectricityUseSearchTwoDetail * list = _myArrayTwo[indexPath.section].detail[indexPath.row];
        cell.day.text = [NSString stringWithFormat:@"%@月",list.month];
        cell.elecNum.text = [NSString stringWithFormat:@"%.1f",[list.electrictyAmount floatValue]];
        cell.elecPrice.text = [NSString stringWithFormat:@"%.2f",[list.electrictyFee floatValue] ];

    }else{
        ElectricityUseSearchList * list = _myArray[indexPath.section].list[indexPath.row];
        cell.day.text = [NSString stringWithFormat:@"%@日",list.day];
        cell.elecNum.text = [NSString stringWithFormat:@"%.1f",[list.elecNumber floatValue]];
        cell.elecPrice.text = [NSString stringWithFormat:@"%.2f",[list.fee floatValue] ];

    }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.cardTpye integerValue] == 9) {
        return _myArrayTwo[section].detail.count;
    }else{
        return _myArray[section].list.count;

    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.cardTpye integerValue] == 9) {
        return _myArrayTwo.count;
    }else{
        return _myArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * fatherView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
    fatherView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 41)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 41)];
    if ([self.cardTpye integerValue] == 9) {
        timeLabel.text = [NSString stringWithFormat:@"%@年",_myArrayTwo[section].year ];
    }else{
        timeLabel.text = _myArray[section].date;
    }
    timeLabel.textColor = [UIColor colorWithRed:0/255.0 green:167/255.0 blue:255/255.0 alpha:1];
    timeLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:timeLabel];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [view addSubview:lineView];
    [fatherView addSubview:view];
    return fatherView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 51;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
