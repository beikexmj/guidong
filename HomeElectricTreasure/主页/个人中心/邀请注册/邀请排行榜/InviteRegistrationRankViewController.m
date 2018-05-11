//
//  InviteRegistrationRankViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/12/13.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "InviteRegistrationRankViewController.h"
#import "InviteRegistrationRankTableViewCell.h"
#import "RankRuleViewController.h"
#import "InviteRankingDataModel.h"
#import "UITableView+WFEmpty.h"
@interface InviteRegistrationRankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray <InviteRankingList *> *myArr;

@end

@implementation InviteRegistrationRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _tableHeaderView.hidden = YES;
    _headerIcon.layer.cornerRadius = 35.0;
    _headerIcon.layer.masksToBounds = YES;
    _myArr = [NSMutableArray array];
    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"InviteRegistrationRankTableViewCell";
    InviteRegistrationRankTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_myArr.count>0) {
        myCell.rankNum.text = [NSString stringWithFormat:@"NO.%ld",indexPath.row+2];
        myCell.nickName.text = _myArr[indexPath.row+1].nickname;
        [myCell.headerIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"res/avatar?userId=",_myArr[indexPath.row+1].inviterId]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        myCell.inviteNum.text = [NSString stringWithFormat:@"本月有效邀请人数：%@",_myArr[indexPath.row+1].total];
    }
    return myCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_myArr.count>0) {
        return _myArr.count-1;
    }
    return 0;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)fetchData{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"invite/ranking" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        InviteRankingDataModel *inviteRankingData = [InviteRankingDataModel mj_objectWithKeyValues:str];
        if (inviteRankingData.rcode == 0) {
            [_myArr addObjectsFromArray:inviteRankingData.form.list];
            if (_myArr.count == 0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无邀请对象" title:@"暂无有效邀请人"];
                self.myTableView.emptyView.hidden = NO;
            }else{
                self.myTableView.emptyView.hidden = YES;
            }
            [self dataWithSuface];
        }else{
            [MBProgressHUD showError:inviteRankingData.msg];

        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;
    }];
}
- (void)dataWithSuface{
    if (_myArr.count>0) {
        _tableHeaderView.hidden = NO;
        [_headerIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"res/avatar?userId=",_myArr[0].inviterId]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        _nickName.text = _myArr[0].nickname;
        _inviteNum.text = [NSString stringWithFormat:@"本月有效邀请人数：%@",_myArr[0].total];
        
        NSDate *date =[NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
        [lastMonthComps setMonth:-1];//获取上一个月日期
        NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];

        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:newdate] integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:newdate]integerValue];
        
        _rankTime.text = [NSString stringWithFormat:@"%ld年%ld月排行榜",currentYear,currentMonth];
        
        [self.myTableView reloadData];
        
    }
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

- (IBAction)rankRuleBtnClick:(id)sender {
    RankRuleViewController *page = [[RankRuleViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
@end
