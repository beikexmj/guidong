//
//  PersonalCenterViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterTableViewCell.h"
#import "BalanceRechargeViewController.h"
#import "SetUpViewController.h"
#import "PersonalInformationViewController.h"
#import "SafeCenterViewController.h"
#import "ElectricityCardViewController.h"
#import "ElectricityRecordViewController.h"
#import "IntegrationDetailsViewController.h"
#import "TicketCenterViewController.h"
#import "AccountDetailViewController.h"
#import "SignViewController.h"
#import "UserCenterDataModel.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ServiceAndNoticeViewController.h"
#import "ElectricityBuyRecordTwoViewController.h"
#import "MyQRCodeViewController.h"
#import "InvitedRegistrationViewController.h"
#import "MJRefresh.h"
@interface PersonalCenterViewController ()<CAAnimationDelegate,UIScrollViewDelegate>
{
    NSArray *iconArray;
    NSArray *nameArray;
}
@property (nonatomic,strong)UserCenterForm *dataDict;
@end

@implementation PersonalCenterViewController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reBuildConstant];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(integralChangeSuccessNotification:) name:@"IntegralChangeSuccess" object:nil];
    nameArray = [[NSArray alloc]initWithObjects: @"余额充值",@"购电/缴费记录",@"电卡管理",@"个人信息",@"安全中心",@"设置",nil];
    iconArray = [[NSArray alloc]initWithObjects: @"per_icon_pay",@"per_icon_record",@"per_icon_management",@"per_icon_massage",@"per_icon_security",@"per_icon_settle",nil];
    _headerImg.layer.cornerRadius = 40;
    _headerImg.layer.masksToBounds = YES;
    _headerImg.layer.borderWidth = 3;
    _headerImg.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImg.image = [UIImage imageNamed:@"默认头像"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceHeaderImgNotifaciotn:) name:@"ReplaceHeaderImg" object:nil];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImgTapClick:)];
    [_headerImg addGestureRecognizer:tap];
    _headerImg.userInteractionEnabled = YES;
    
    _myScrollView.contentSize =  CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [_myScrollView addSubview:_myView];
//    _myScrollView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
//         [self fetchData];
//        //Call this Block When enter the refresh status automatically
//    }];
    [self fetchImg];
    [self fetchData];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.comfromFlag == 3 &&[StorageUserInfromation storageUserInformation].token) {
        delegate.comfromFlag = 4;
        ServiceAndNoticeViewController *page = [[ServiceAndNoticeViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
       // Do any additional setup after loading the view.
}
- (void)fetchImg{
    if (![StorageUserInfromation storageUserInformation].token) {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.comeFromFlag = 2;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        return;
    }
    NSString * str = [NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"res/avatar?userId=",[StorageUserInfromation storageUserInformation].userId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str] options:NSDataReadingUncached error:nil];
        if (data.length) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.headerImg.image = [UIImage imageWithData:data];
            });
        }
       
    });
}
- (void)replaceHeaderImgNotifaciotn:(NSNotification *)notifaction{
    [self fetchImg];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat  offSet  = scrollView.contentOffset.y;
    NSLog(@"%f",offSet);
    if (offSet<0) {
        _headerBackImageToTop.constant = offSet;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![StorageUserInfromation storageUserInformation].token) {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.comeFromFlag = 2;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        return;
    }
    
//    [self fetchData];
//    self.money.text = [StorageUserInfromation storageUserInformation].accountBalance;
//    [_balanceBtn setTitle:[NSString stringWithFormat:@"  余额(元)：%@",[StorageUserInfromation storageUserInformation].accountBalance] forState:UIControlStateNormal];
}
-(void)fetchData{
    if (![StorageUserInfromation storageUserInformation].token) {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.comeFromFlag = 2;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        return;
    }
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"user/outline" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        UserCenterDataModel *userCenerList = [UserCenterDataModel mj_objectWithKeyValues:str];
        if (userCenerList.rcode == 0) {
            _dataDict = userCenerList.form;
            [self dataWithSuface];
        }else{
            
        }
//        [_myScrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        [_myScrollView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];

    }];
}

- (void)dataWithSuface{
    self.nickName.text = _dataDict.nickname;
    [StorageUserInfromation storageUserInformation].accountBalance = [NSString stringWithFormat:@"%0.2f", _dataDict.accountBalance.floatValue];
    self.banlance.text = [StorageUserInfromation storageUserInformation].accountBalance;
    [StorageUserInfromation storageUserInformation].point = _dataDict.point;
    
}


#pragma mark - 修改约束
-(void)reBuildConstant{
//    CGFloat n = SCREEN_WIDTH/320.0;
//    CGRect rect = self.tableHeaderView.frame;
//    rect.size.height = n*220;
//    self.tableHeaderView.frame = rect;
//    self.buttonHeigth.constant = n*80;
//    self.headerIconWidth.constant = self.headerIconHeight.constant = n*80;
//    self.headerSubbackGuandView.backgroundColor = [UIColor colorWithRed:237.0/255 green:237/255.0 blue:237/255.0 alpha:1];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"PersonalCenterTableViewCell";
    PersonalCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    if (indexPath.section == 0) {
        cell.icon.image = [UIImage imageNamed:iconArray[indexPath.row]];
        cell.nameLabel.text = nameArray[indexPath.row];
    }else{
        cell.icon.image = [UIImage imageNamed:iconArray[indexPath.row+3]];
        cell.nameLabel.text = nameArray[indexPath.row+3];
    }
    if (indexPath.row == 2) {
        cell.lineViewToLeft.constant = 0;
    }else{
        cell.lineViewToLeft.constant = 12;
    }
    return cell;
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    switch (btn.tag) {
        case 10://余额充值
        {
            BalanceRechargeViewController *page = [[BalanceRechargeViewController alloc]init];
            page.comfromFlag = 0;
            [self.navigationController pushViewController:page animated:YES];
           
        }
            break;
        case 20://缴费记录
        {
//            ElectricityRecordViewController * page  = [[ElectricityRecordViewController alloc]init];
            ElectricityBuyRecordTwoViewController *page = [[ElectricityBuyRecordTwoViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
            break;
        case 30://电卡管理
        {
            ElectricityCardViewController *page = [[ElectricityCardViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
            break;
        case 40://安全中心
        {
            SafeCenterViewController *page = [[SafeCenterViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
            break;
        case 50://设置
        {
            SetUpViewController *page = [[SetUpViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
           
        }
            break;
        case 60://邀请注册
        {
            InvitedRegistrationViewController *page = [[InvitedRegistrationViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
            break;
        case 70://账户余额
        {
            AccountDetailViewController *page = [[AccountDetailViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)integralChangeSuccessNotification:(NSNotification *)notification{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"user/outline" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        UserCenterDataModel *userCenerList = [UserCenterDataModel mj_objectWithKeyValues:str];
        if (userCenerList.rcode == 0) {
            _dataDict = userCenerList.form;
            [self dataWithSuface];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);        
    }];

}

- (void)headerImgTapClick:(UIGestureRecognizer *)tap{
    PersonalInformationViewController *page = [[PersonalInformationViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
- (IBAction)QRCodeBtnClick:(id)sender {
//    MyQRCodeViewController * page = [[MyQRCodeViewController alloc]init];
//    [self.navigationController pushViewController:page animated:YES];
}
@end
