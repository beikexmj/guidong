//
//  ElectricityCardViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityCardViewController.h"
#import "ElectricityCardTableViewCell.h"
#import "NewPaymentAccountTwoViewController.h"
#import "ElectricityCardDataModel.h"
#import "JPUSHService.h"
#import "NSString+Replace.h"
@class ElectricityCardDataModel;
@interface ElectricityCardViewController ()<UIAlertViewDelegate>
{
    NSInteger buttonTag;
    NSMutableArray *deleteArr;

}
@property (nonatomic,strong)NSMutableArray <ElectricityCardList*> *myArray;
@end

@implementation ElectricityCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
        _btnToBottom.constant = 34;
    }
//    self.addElectricityCardBtn.layer.cornerRadius = 5;
    self.delFlag  = YES;
    deleteArr = [NSMutableArray array];
    _myArray = [NSMutableArray<ElectricityCardList*> array];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}
-(void)fetchData{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"user/electricUser/getElectricCardsInfo" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityCardDataModel *electricityCard = [ElectricityCardDataModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {
            [_myArray removeAllObjects];
            [_myArray addObjectsFromArray:electricityCard.form.list];
            [self setTags];
            if (_myArray.count ==0) {
                _delBtn.hidden = YES;
                self.myTableView.hidden = YES;
            }else{
                _delBtn.hidden = NO;
                self.myTableView.hidden = NO;
            }
            [self.myTableView reloadData];
        }else{
            self.myTableView.hidden = YES;
            _delBtn.hidden = YES;
            [MBProgressHUD showError:electricityCard.msg];
        }
    } failure:^(NSError *error) {
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
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"ElectricityCardTableViewCell";
    ElectricityCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    cell.delBtnWidth.constant = 0;
    ElectricityCardList* list = _myArray[indexPath.row];
    NSString *accountName = list.accountName;
    if (accountName.length == 2) {
        accountName = [accountName replaceStringWithAsterisk:1 length: accountName.length-1];
    }else if (accountName.length > 2){
        accountName = [accountName replaceStringWithAsterisk:1 length: accountName.length-2];
    }
    cell.userInfor.text = [NSString stringWithFormat:@"%@|%@",list.accountNo,accountName];
    cell.adress.text = list.address;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _myArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.myTableView.editing) {
        [deleteArr addObject:_myArray[indexPath.row]];
        if (deleteArr.count!=0) {
            [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
            [_delBtn setTitleColor:[UIColor colorWithRed:226/255.0 green:23.0/255 blue:23/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myTableView.editing) {
        [deleteArr removeObject:_myArray[indexPath.row]];
        if (deleteArr.count == 0) {
            [_delBtn setTitle:@"取消删除" forState:UIControlStateNormal];
            [_delBtn setTitleColor:[UIColor colorWithRed:128/255.0 green:128.0/255 blue:128/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.myTableView.editing = YES;
//    [self.myTableView reloadData];
//    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [deleteArr addObject:_myArray[indexPath.row]];
//        // Delete the row from the data source.
//        [self deleteCards];
//    };
//
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
//    action1.backgroundColor = [UIColor redColor];
//    
//
//    return @[action1];
//}


//选择你要对表进行处理的方式  默认是删除方式

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delFlag) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
        
    }
    
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
        [self deleteCards];
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
- (IBAction)delBtnClick:(id)sender {
    
    if (self.delFlag) {
        [self.delBtn setTitle:@"取消删除" forState:UIControlStateNormal];
        self.myTableView.editing = YES;
        [_delBtn setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];

    }else{
        [self.delBtn setTitle:@"账户管理" forState:UIControlStateNormal];
        self.myTableView.editing = NO;
        [_delBtn setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        if (deleteArr.count != 0) {
            [self deleteCards];
        }
    }
    self.delFlag = !self.delFlag;
    [self.myTableView reloadData];
}

- (void)deleteCards{
    NSMutableArray * onceArray = [NSMutableArray array];
    for (ElectricityCardList * list in deleteArr) {
        [onceArray addObject:list.ids];
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"id":onceArray,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"user/electricUser/deleteElectricCards" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]==0) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            for (ElectricityCardList * dict in deleteArr) {
                if([dict.accountNo isEqual:[userDefault valueForKey:@"accountNo"]]){
                      [userDefault setValue:nil forKey:@"accountNo"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"elecCardChange" object:nil];
                }
            }
            
            [_myArray removeObjectsInArray:deleteArr];
            [deleteArr removeAllObjects];
            [self setTags];
            if (_myArray.count ==0) {
                _delBtn.hidden = YES;
            }else{
                _delBtn.hidden = NO;
            }
            [self.myTableView reloadData];
        }else{
            [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
    } failure:^(NSError *error) {
        [deleteArr removeAllObjects];
        NSLog(@"%@",error);
    }];
}


- (IBAction)addElectricityCardBtnClick:(id)sender {
    NewPaymentAccountTwoViewController * page = [[NewPaymentAccountTwoViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
@end
