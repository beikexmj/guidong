//
//  IntegrationDetailsViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "IntegrationDetailsViewController.h"
#import "IntegralDetailTableViewCell.h"
#import "IntegralRoleViewController.h"
#import "MyPointDetailDataModel.h"
#import "UITableView+WFEmpty.h"
#import "MyWebViewController.h"
@interface IntegrationDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray <MyPointDetailList*> *dataArry;
@end

@implementation IntegrationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navTitle.font = [UIFont systemFontOfSize:18.0];
        _headerHight.constant = 192+22;
    }
    _dataArry = [NSMutableArray array];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"积分规则?"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:strRange];
    
    [_integralRoleBtn setAttributedTitle:str forState:UIControlStateNormal];
    _integralNum.text = [StorageUserInfromation storageUserInformation].point;
    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
-(void)fetchData{
    [_dataArry removeAllObjects];
    [MBProgressHUD showMessage:@"加载中..."];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"point/mypoint/detail" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        MyPointDetailDataModel *myPointDetailList = [MyPointDetailDataModel mj_objectWithKeyValues:str];
        if (myPointDetailList.rcode == 0) {
            NSArray<MyPointDetailList*> * myArray = myPointDetailList.form.list;
            [_dataArry addObjectsFromArray:myArray];
            if (_dataArry.count ==0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无积分"];
                self.myTableView.emptyView.hidden = NO;
            }else{
                self.myTableView.emptyView.hidden = YES;
            }
            [self.myTableView reloadData];
        }else{
            [MBProgressHUD showError:@"暂无积分"];
//            for (UIView * myView in self.myTableView.subviews) {
//                if ([myView isEqual:self.myTableView.emptyView]) {
//                    [myView removeFromSuperview];
//                }
//            }
            [self.myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无积分"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArry.count>0) {
        MyPointDetailList *list = _dataArry[indexPath.row];
        cell.type.text = list.reason;
        cell.time.text = list.createTime;
        if (list.changeAmount>0) {
            cell.num.text = [NSString stringWithFormat:@"%ld",list.changeAmount];
            cell.symbol.text = @"+";
        }else{
            cell.num.text = [NSString stringWithFormat:@"%ld",-list.changeAmount];
            cell.symbol.text = @"-";
        }

    }
    
    cell.numWidth.constant = [cell.num sizeThatFits:CGSizeMake(SCREEN_WIDTH, 25)].width;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArry.count;
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

- (IBAction)integralRoleBtnClick:(id)sender {
//    IntegralRoleViewController *page = [[IntegralRoleViewController alloc]init];
//    [self.navigationController pushViewController:page animated:YES];
    MyWebViewController *page = [[MyWebViewController alloc]init];
    page.titleStr = @"积分规则";
    page.urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL,@"/static/html/pointrule.html"];
    [self.navigationController pushViewController:page animated:YES];
}
@end
