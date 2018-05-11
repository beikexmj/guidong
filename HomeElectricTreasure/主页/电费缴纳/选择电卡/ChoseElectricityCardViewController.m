//
//  ChoseElectricityCardViewController.m
//  copooo
//
//  Created by 夏明江 on 2017/1/18.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ChoseElectricityCardViewController.h"
#import "ChoseElectricityCardTableViewCell.h"
#import "ElectricityCardDataModel.h"
#import "NewPaymentAccountTwoViewController.h"
#import "JPUSHService.h"
#import "NSString+Replace.h"

@interface ChoseElectricityCardViewController ()
{
    NSMutableArray *deleteArr;
}
@property (nonatomic,strong)NSMutableArray<ElectricityCardList *> *myArray;
@end

@implementation ChoseElectricityCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
        _btnToBottom.constant = 34;
    }
    deleteArr = [NSMutableArray array];
    _myArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}
-(void)fetchData{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    [MBProgressHUD showMessage:@"加载中..."];
    [ZTHttpTool postWithUrl:@"user/electricUser/getElectricCardsInfo" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityCardDataModel *electricityCard = [ElectricityCardDataModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {
            [_myArray removeAllObjects];
            [_myArray addObjectsFromArray:electricityCard.form.list];
//            if (_myArray.count ==0) {
//                self.myTableView.hidden = YES;
//            }else{
//                self.myTableView.hidden = NO;
//            }
            [self.myTableView reloadData];
        }else{
//            self.myTableView.hidden = YES;
            [MBProgressHUD showError:electricityCard.msg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"ChoseElectricityCardTableViewCell";
    ChoseElectricityCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    ElectricityCardList* list = _myArray[indexPath.row];
    NSString *accountName = list.accountName;
    if (accountName.length == 2) {
        accountName = [accountName replaceStringWithAsterisk:1 length: accountName.length-1];
    }else if (accountName.length > 2){
        accountName = [accountName replaceStringWithAsterisk:1 length: accountName.length-2];
    }
    cell.userInfor.text = [NSString stringWithFormat:@"%@|%@",list.accountNo,accountName];
    cell.adress.text = list.address;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([_myArray[indexPath.row].accountNo isEqual:[userDefault valueForKey:@"accountNo"]]) {
        cell.choseState.image = [UIImage imageNamed:@"ser_icon_choice"];
    }else{
        cell.choseState.image = [UIImage imageNamed:@"ser_icon_un_choice"];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_myArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:_myArray[indexPath.row].accountNo forKey:@"accountNo"];
    [self.myTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [deleteArr addObject:_myArray[indexPath.row]];
        // Delete the row from the data source.
        [self deleteCards:indexPath];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)deleteCards:(NSIndexPath*)indexPath{
    NSMutableArray * onceArray = [NSMutableArray array];
    for (ElectricityCardList * list in deleteArr) {
        [onceArray addObject:list.ids];
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"id":onceArray,@"device":@"1"};
    [MBProgressHUD showMessage:@""];
    [ZTHttpTool postWithUrl:@"user/electricUser/deleteElectricCards" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]==0) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([_myArray[indexPath.row].accountNo isEqual:[userDefault valueForKey:@"accountNo"]]) {
                [userDefault setValue:nil forKey:@"accountNo"];
            }
            
            [_myArray removeObjectsInArray:deleteArr];
            [deleteArr removeAllObjects];
            [self setTags];
            [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//            [self.myTableView reloadData];
            
            
            
        }else{
            [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [deleteArr removeAllObjects];
        NSLog(@"%@",error);
    }];
}
-(void)setTags{
    NSMutableArray * array = [NSMutableArray array];
    for (ElectricityCardList * dict  in _myArray) {
        [array addObject:dict.accountNo];
    }
    //用于绑定Tag的 根据自己想要的Tag加入，值得注意的是这里Tag需要用到NSSet
    [JPUSHService setTags:[NSSet setWithArray:array] callbackSelector:nil object:self];
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

- (IBAction)addElectricityCardBtnClick:(id)sender {
    NewPaymentAccountTwoViewController * page = [[NewPaymentAccountTwoViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
@end
