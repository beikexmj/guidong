//
//  ElectricityFeePaymentViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/17.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityFeePaymentViewController.h"
#import "PGIndexBannerSubiew.h"
#import "PayElectricityFeeViewController.h"
#import "HistoryBillListViewController.h"
#import "NoElectricityCardView.h"
#import "NewPaymentAccountTwoViewController.h"
#import "ElectricityCardViewController.h"
#import "ElectricityCardDataModel.h"
#import "ElectricityFeePaymentDataModel.h"
#import "RFLayout.h"
#import "JPUSHService.h"
#import "ElectricitySearchViewController.h"
#import "MyElectricityFeePaymentDataModel.h"
#import "ElectricityFeePaymentLogModel.h"
#import "MJRefresh.h"
#import "ChoseElectricityCardViewController.h"
#import "XZMRefresh.h"
#import "HistoryBillListTwoViewController.h"
#import "PayElectricityFeeTwoViewController.h"
#import "NewElectricityFeePaymentDisplayUpCollectionViewCell.h"
#import "NewElectricityFeePaymentDisplayDownView.h"
#import "ElectricityFeeDisplayChartViewController.h"
#import "TrendViewController.h"
#import "ServiceAndNoticeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@class ElectricityCardDataModel;
@class ElectricityFeePaymentDataModel;
@interface ElectricityFeePaymentViewController ()<PGIndexBannerSubiewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>
{
    BOOL IsBackFromPurchase;
    BOOL IsBackFromElectricityFeeSearch;
    BOOL IsBackFromHistoryBill;
    BOOL IsBackFromElectricityCard;
    BOOL IsBackFromElectricityChart;
    NSInteger indexSectionForElectCard;
    NewElectricityFeePaymentDisplayDownView *newElectricityFeePaymentDisplayDownView;
    UIView *bottomView;
    NSIndexPath *indexPathNow;
    UIAlertView *alert;
    UITapGestureRecognizer *recognizerTap;
    MJRefreshGifHeader * header;
    BOOL flag;
}
/**
 *  真实数量的图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray<ElectricityCardList*> *eleCardArry;
@property (nonatomic, strong) NSMutableArray<Data *> *eleFeePaymentArry;
@property (nonatomic, strong) UIImageView * imageViewToUp;
@property (nonatomic, strong) NSMutableDictionary *integerDict;//刷新标记；
@end

@implementation ElectricityFeePaymentViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotificationCount:) name:@"addNotificationCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotificationCount:) name:@"fetchDataWithNotice2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(elecCardChange) name:@"elecCardChange" object:nil];

    IsBackFromPurchase = NO;
    IsBackFromElectricityFeeSearch = NO;
    IsBackFromHistoryBill = NO;
    IsBackFromElectricityCard = NO;
    IsBackFromElectricityChart = NO;
    indexSectionForElectCard = 0;
    flag = YES;
    _myScrollView.backgroundColor = RGBCOLOR(22, 157, 232);
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.delegate = self;
    _integerDict = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSDate date] forKey:@"date"];
    
    _badgeView = [[JSBadgeView alloc] initWithParentView:_noticeBtn alignment:JSBadgeViewAlignmentTopRight];
    header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchEleCard:)];
    NSMutableArray * images = [NSMutableArray array];
    for (int i=1; i<=7; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"circle_%d",8-i]];
        [images addObject:image];
    }
    // 设置普通状态的动画图片
    [header setImages:images forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:images forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:images forState:MJRefreshStateRefreshing];
    self.myScrollView.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    

    newElectricityFeePaymentDisplayDownView = [[[NSBundle mainBundle] loadNibNamed:@"NewElectricityFeePaymentDisplayDownView" owner:self options:nil] lastObject];
    if (SCREEN_WIDTH==320) {
        newElectricityFeePaymentDisplayDownView.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-(64+200+49)  +200);
        
    }else if(SCREEN_WIDTH == 375){
        newElectricityFeePaymentDisplayDownView.frame = CGRectMake(0, 245, SCREEN_WIDTH, SCREEN_HEIGHT-(64+245+49)- (kDevice_Is_iPhoneX?56:0) +200);
        
    }else if(SCREEN_WIDTH == 414){
        newElectricityFeePaymentDisplayDownView.frame = CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT-(64+290+49)+200);
        
    }
    [newElectricityFeePaymentDisplayDownView.electricityFeePaymentBtn addTarget:self action:@selector(electricityFeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [newElectricityFeePaymentDisplayDownView.electSearcth addTarget:self action:@selector(electricityFeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [newElectricityFeePaymentDisplayDownView.electHistoryBillList addTarget:self action:@selector(electricityFeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [newElectricityFeePaymentDisplayDownView.electUseChart addTarget:self action:@selector(electricityFeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, newElectricityFeePaymentDisplayDownView.frame.size.height +newElectricityFeePaymentDisplayDownView.frame.origin.y -2, SCREEN_WIDTH, 200)];

    [self fetchDataWithNotice];
    [self fetchEleCard:1];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.comfromFlag == 3 &&[StorageUserInfromation storageUserInformation].token) {
        delegate.comfromFlag = 4;
        ServiceAndNoticeViewController *page = [[ServiceAndNoticeViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![StorageUserInfromation storageUserInformation].token) {
         LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.comeFromFlag = 1;

        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        return;
    }
    
//
//    if (IsBackFromPurchase|IsBackFromHistoryBill|IsBackFromElectricityFeeSearch|IsBackFromElectricityCard|IsBackFromElectricityChart) {
//        IsBackFromPurchase = IsBackFromHistoryBill = IsBackFromElectricityFeeSearch = IsBackFromElectricityCard = IsBackFromElectricityChart =NO;
//        return;
//    }
    if(IsBackFromElectricityCard |IsBackFromPurchase){
        IsBackFromElectricityCard = NO;
        IsBackFromPurchase = NO;
        [self fetchEleCard:1];

    }

}
//- (void)setBadgeView:(JSBadgeView *)badgeView{
//    if (_badgeView != badgeView) {
//        _badgeView = [[JSBadgeView alloc] initWithParentView:_noticeBtn alignment:JSBadgeViewAlignmentTopRight];
//    }
//}

-(void)fetchEleCard:(NSInteger)integer{
    if (flag) {
        flag = NO;
    }else{
        return;
    }
    if (![StorageUserInfromation storageUserInformation].token) {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.comeFromFlag = 1;

        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        flag = YES;
        return;
    }
//    static BOOL myBool = YES;
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    if (integer == 1) {
        [MBProgressHUD showMessage:@"数据加载中..."];
    }
    _eleCardArry = [NSMutableArray array];

    [ZTHttpTool postWithUrl:@"user/electricUser/getElectricCardsInfo" param:dict success:^(id responseObj) {
//        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityCardDataModel *electricityCard = [ElectricityCardDataModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {

            _integerDict = [NSMutableDictionary dictionary];
            [_eleCardArry addObjectsFromArray:electricityCard.form.list];
            
            [self setTags];
            [self resetScrollView:integer];
        
        }else{
            if (integer == 1) {
                [MBProgressHUD hideHUD];
            }
            [MBProgressHUD showError:electricityCard.msg];
            if (integer != 1 && integer != 2) {
                [self.myScrollView.mj_header endRefreshing];
            }
            flag = YES;
        }
    } failure:^(NSError *error) {
        if (integer == 1) {
            [MBProgressHUD hideHUD];
        }
        NSLog(@"%@",error);
        if (integer != 1 && integer != 2) {
            [self.myScrollView.mj_header endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];
        flag = YES;
    }];

}
-(void)resetScrollView:(NSInteger)integer{
    if (_eleCardArry.count==0) {
        self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-113- kDevice_Is_iPhoneX?56:0);
        [self NoElecCard];
        self.myScrollView.scrollEnabled = NO;
        if (integer == 1) {
            [MBProgressHUD hideHUD];
        }
        flag = YES;
    }else{
        self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT-113-kDevice_Is_iPhoneX?56:0));
        self.myScrollView.scrollEnabled = YES;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSInteger n = 0;
        for (ElectricityCardList * dict in _eleCardArry) {
            NSString * cardNo = dict.accountNo;
            if (![cardNo isEqual:[userDefault valueForKey:@"accountNo"]]) {
                n++;
            }
        }
        if (n==[_eleCardArry count]) {
            [userDefault setValue:_eleCardArry[0].accountNo forKey:@"accountNo"];
        }
        [self fetchData:integer];
    }

}
-(void)fetchData:(NSInteger)integer{
    NSDate * date = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp1 = [myCal components:units fromDate:date];
    NSInteger month = [comp1 month];
    NSInteger year = [comp1 year];
    NSInteger month2;
    NSInteger year2;
    if (month<3) {
        month2 = month-2+12;
        year2 = year-1;
    }else{
        month2 = month-2;
        year2 = year;
    }
    NSDictionary *dict;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault valueForKey:@"accountNo"]) {
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"beginYear":[NSString stringWithFormat:@"%ld",year2],@"beginMonth":[NSString stringWithFormat:@"%ld",month2],@"endYear":[NSString stringWithFormat:@"%ld",year],@"endMonth":[NSString stringWithFormat:@"%ld",month],@"accountNo":[userDefault valueForKey:@"accountNo"]};
    }else{
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"beginYear":[NSString stringWithFormat:@"%ld",year2],@"beginMonth":[NSString stringWithFormat:@"%ld",month2],@"endYear":[NSString stringWithFormat:@"%ld",year],@"endMonth":[NSString stringWithFormat:@"%ld",month]};
    }
//    [MBProgressHUD showMessage:@"数据加载中..."];
    [ZTHttpTool postWithUrl:@"user/electricUser/getIndexCardInfo" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if (integer == 1) {
            [MBProgressHUD hideHUD];
        }
        //        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        MyElectricityFeePaymentDataModel *electricityCard = [MyElectricityFeePaymentDataModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {
            _eleFeePaymentArry = [NSMutableArray array];
            [_eleFeePaymentArry addObjectsFromArray:electricityCard.form];
//            [self setupUI];
            [self setUpUI2];

            
        }else{
            [MBProgressHUD showError:electricityCard.message];
        }
        if (integer != 1 && integer != 2) {
            [self.myScrollView.mj_header endRefreshing];
        }
        flag = YES;
//        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        if (integer == 1) {
            [MBProgressHUD hideHUD];
        }
        [MBProgressHUD showError:@"数据加载失败"];
        if (integer != 1 && integer != 2) {
            [self.myScrollView.mj_header endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];
        flag = YES;

    }];

}
-(void)reFetchData:(NSInteger)integer header:(XZMRefreshHeader *)header collectionView:(UICollectionView*)collectionView{
    if (!_integerDict[[NSString stringWithFormat:@"%ld",integer]]) {
        [_integerDict setValue:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%ld",integer]];
    }
    NSDate * date = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp1 = [myCal components:units fromDate:date];
    NSInteger month = [comp1 month];
    NSInteger year = [comp1 year]-[_integerDict[[NSString stringWithFormat:@"%ld",integer]] integerValue]+1;
    
    NSInteger month2;
    NSInteger year2;
    if (month<3) {
        month2 = month-2+12;
        year2 = year-1;
    }else{
        month2 = month-2;
        year2 = year;
    }
    [MBProgressHUD showMessage:@"加载中..."];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"beginYear":[NSString stringWithFormat:@"%ld",year2-1],@"beginMonth":[NSString stringWithFormat:@"%ld",month2],@"endYear":[NSString stringWithFormat:@"%ld",month2==1?year2-1:year2],@"endMonth":[NSString stringWithFormat:@"%ld",month2-1>0?month2-1:month2+11],@"accountNo":_eleFeePaymentArry[integer].accountNo};
    
    [ZTHttpTool postWithUrl:@"user/electricUser/getIndexCardInfo" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        //        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        MyElectricityFeePaymentDataModel *electricityCard = [MyElectricityFeePaymentDataModel mj_objectWithKeyValues:str];
        [MBProgressHUD hideHUD];
        
        [header endRefreshing];

        if (electricityCard.rcode == 0) {

//            _eleFeePaymentArry = [NSMutableArray array];
//            [_eleFeePaymentArry addObjectsFromArray:electricityCard.form.list];
            if (electricityCard.form[0].detail.count<=0) {
                [MBProgressHUD showError:@"没有更多数据"];
                return;
            }
            NSInteger m = electricityCard.form[0].detail.count;
            _eleFeePaymentArry[integer].detail = [[[[[_eleFeePaymentArry[integer].detail reverseObjectEnumerator] allObjects] arrayByAddingObjectsFromArray:[[electricityCard.form[0].detail reverseObjectEnumerator] allObjects]] reverseObjectEnumerator] allObjects];
            
//            UICollectionView * collectionView = [self.myScrollView viewWithTag:integer];
           int n = [_integerDict[[NSString stringWithFormat:@"%ld",integer]] intValue]+1;
            [_integerDict setValue:[NSNumber numberWithInt:n] forKey:[NSString stringWithFormat:@"%ld",integer]];
            [(UICollectionView*)header.scrollView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:m-1 inSection:0];
            if (indexPath.row >=0 && _eleFeePaymentArry[integer].detail.count>=indexPath.row+1) {
                [(UICollectionView*)header.scrollView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                [newElectricityFeePaymentDisplayDownView fetcthData:_eleFeePaymentArry[0] index:indexPath.row];

            }
        }else{
            [MBProgressHUD showError:electricityCard.message];
        }
    } failure:^(NSError *error) {
        [header endRefreshing];

        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];

    }];
    
}

-(void)NoElecCard{
    NoElectricityCardView * noCardEView = [[[NSBundle mainBundle] loadNibNamed:@"NoElectricityCardView" owner:self options:nil] lastObject];
    noCardEView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-113-(kDevice_Is_iPhoneX?56:0));
    [noCardEView.addElecCard addTarget:self action:@selector(addElecCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    for (UIView * subView in self.myScrollView.subviews) {
        if ([subView isEqual:self.myScrollView.mj_header]) {
            continue;
        }
        [subView removeFromSuperview];
    }
    [self.myScrollView addSubview:noCardEView];
}
-(void)addElecCardBtnClick:(id)sender{
    IsBackFromElectricityCard = YES;
    NewPaymentAccountTwoViewController * page = [[NewPaymentAccountTwoViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

-(void)setUpUI2{
    for (UIView * subView in self.myScrollView.subviews) {
        if ([subView isKindOfClass:[UICollectionView class]]|[subView isKindOfClass:[NewElectricityFeePaymentDisplayDownView class]]|[subView isKindOfClass:[NoElectricityCardView class]]|[subView isKindOfClass:[NewElectricityFeePaymentDisplayUpCollectionViewCell class]]|[subView isKindOfClass:[bottomView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (_eleFeePaymentArry.count<=0) {
        [MBProgressHUD showError:@"无电卡或电卡失效"];
        return;
    }
    for (int i = 0; i<_eleFeePaymentArry.count; i++) {
        if (i>0) {
            break;
        }
        RFLayout *rfLayout = [[RFLayout alloc] init];
        CGFloat height;
        if (SCREEN_WIDTH ==320) {
            height = 200;
        }else if(SCREEN_WIDTH == 375){
            height = 245;
        }else if(SCREEN_WIDTH == 414){
            height = 290;
        }else{
            height = 290;
        }
        UICollectionView *myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)collectionViewLayout:rfLayout];
        myCollectionView.backgroundColor = [UIColor clearColor];
        myCollectionView.delegate = self;
        myCollectionView.dataSource = self;
        myCollectionView.tag = i*10;
        myCollectionView.showsHorizontalScrollIndicator = NO;
        myCollectionView.pagingEnabled = YES;
        myCollectionView.layer.masksToBounds = NO;
        rfLayout.myCollectionView = myCollectionView;
        [myCollectionView registerNib:[UINib nibWithNibName:@"NewElectricityFeePaymentDisplayUpCollectionViewCell"  bundle:nil]forCellWithReuseIdentifier:@"NewElectricityFeePaymentDisplayUpCollectionViewCell"];
        
       
        
        if (_eleFeePaymentArry[i].detail.count>0) {
            if ([_eleFeePaymentArry[i].detail[0].index.cardType integerValue] != 9) {
                myCollectionView.alwaysBounceHorizontal = YES;
                myCollectionView.xzm_header.tag = i*10;
                [myCollectionView xzm_addNormalHeaderWithTarget:self action:@selector(loadNewDataWithHeader:)];
                myCollectionView.xzm_header.textColor = [UIColor whiteColor];
            }
            [self.myScrollView addSubview:myCollectionView];
        }else{
            NewElectricityFeePaymentDisplayUpCollectionViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NewElectricityFeePaymentDisplayUpCollectionViewCell" owner:self options:nil] lastObject];
            cell.frame = CGRectMake(0, 15, SCREEN_WIDTH, height-45);
            cell.elecFee.hidden = YES;
            cell.elecNum.hidden = YES;
            cell.monthElecFee.hidden = YES;
            cell.monthElecNum.hidden = YES;
            cell.year.hidden = YES;
            cell.yearBackGuandView.hidden = YES;
            cell.noBillView.hidden = NO;
            if ([_eleFeePaymentArry[i].cardType integerValue] == 9) {
                cell.noBillName.text = @"账单未出";
            }else{
                cell.noBillName.text = @"暂无数据";

            }
            [self.myScrollView addSubview:cell];
        }
        
        
       
        [self.myScrollView addSubview:newElectricityFeePaymentDisplayDownView];
//        [self.myScrollView addSubview:bottomView];
        
        [newElectricityFeePaymentDisplayDownView fetcthData:_eleFeePaymentArry[i] index:_eleFeePaymentArry[i].detail.count-1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_eleFeePaymentArry[i].detail.count-1 inSection:0];
        indexPathNow = indexPath;
        if (indexPath.row >0) {
            [myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:_eleFeePaymentArry[0].accountNo forKey:@"accountNo"];
//    self.myScrollView.mj_header = header;

}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    
    return NO;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _eleFeePaymentArry[collectionView.tag/10].detail.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewElectricityFeePaymentDisplayUpCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewElectricityFeePaymentDisplayUpCollectionViewCell" forIndexPath:indexPath];
    Index *index = _eleFeePaymentArry[0].detail[indexPath.row].index;
    cell.year.text = [NSString stringWithFormat:@"%@年",index.currentYear];
    cell.monthElecFee.text = [NSString stringWithFormat:@"%@月电费(元)",index.currentMonth];
    cell.monthElecNum.text = [NSString stringWithFormat:@"%@月电量(度)",index.currentMonth];
    cell.elecFee.text = [NSString stringWithFormat:@"%0.2f",[index.currentFee floatValue]];
    cell.elecNum.text = [NSString stringWithFormat:@"%0.1f",[index.currentElec floatValue]];
    return cell;
}

- (void)loadNewDataWithHeader:(XZMRefreshHeader *)header{
    [self reFetchData:header.tag  header:header collectionView: [self.myScrollView viewWithTag:header.tag]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.myScrollView]) {
        return;
    }
    
    UICollectionView * myCollectionView = (UICollectionView*)scrollView;
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:myCollectionView.center toView:myCollectionView];
    // 获取这一点的indexPath
    indexPathNow = [myCollectionView indexPathForItemAtPoint:pInView];
    // 打印
    NSLog(@"%@",indexPathNow);

//    [UIView animateWithDuration: 0.1 delay: 0.0 options: UIViewAnimationOptionOverrideInheritedOptions animations: ^{
//        [myCollectionView scrollToItemAtIndexPath:indexPathNow atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    } completion: ^(BOOL finished) {
//        
//    }];
    // 更新底部的数据
    [newElectricityFeePaymentDisplayDownView fetcthData:_eleFeePaymentArry[0] index:indexPathNow.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)eleCardArry {
    if (_eleCardArry == nil) {
        _eleCardArry = [NSMutableArray array];
    }
    return _eleCardArry;
}
- (NSMutableArray *)eleFeePaymentArry {
    if (_eleFeePaymentArry == nil) {
        _eleFeePaymentArry = [NSMutableArray array];
    }
    return _eleFeePaymentArry;
}

-(void)elecSearchBtnClick:(UIButton *)button{
    if (_eleFeePaymentArry[0].detail.count<=0) {
        [self showAlert];
        return;
    }
    IsBackFromElectricityFeeSearch = YES;
    ElectricitySearchViewController  * page = [[ElectricitySearchViewController alloc]init];
    page.cardType = _eleFeePaymentArry[0].cardType;
    page.accountNo = _eleFeePaymentArry[0].accountNo;
    [self.navigationController pushViewController:page animated:YES];
}

-(void)elecCardManagementBtnClick:(UIButton *)button{
    IsBackFromElectricityCard = YES;
    ElectricityCardViewController * page =[[ElectricityCardViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];

}

#pragma mark PGIndexBannerSubiewDelegate
-(void)payFeeBtnClickIndex:(NSInteger)index target:(PGIndexBannerSubiew *)pgIndexView tag:(NSInteger)tag{
//    if (_eleFeePaymentArry[0].detail.count<=0) {
//        [MBProgressHUD showError:@"没有数据"];
//        return;
//    }
    if (_eleFeePaymentArry[0].detail.count<=0) {
        [MBProgressHUD showError:@"没有未缴费用或账单未出"];
        return;
    }
    if (_eleFeePaymentArry[0].detail[0].index.balance.floatValue<0.001) {
        [MBProgressHUD showError:@"没有未缴费用或账单未出"];
        return;
    }
    IsBackFromPurchase = YES;
    if ([_eleFeePaymentArry[0].cardType integerValue] == 9) {
        if (_eleFeePaymentArry[0].detail.count<=0) {
            [self showAlert];
            return;
        }
        PayElectricityFeeViewController *page = [[PayElectricityFeeViewController alloc]init];
        page.accountNo = _eleFeePaymentArry[tag/10].accountNo;
        indexSectionForElectCard = tag/10;
        page.comfromFlag = 2;//后付费
        [self.navigationController pushViewController:page animated:YES];
    }else{
        PayElectricityFeeViewController * page = [[PayElectricityFeeViewController alloc]init];
        page.accountNo = _eleFeePaymentArry[tag/10].accountNo;
        indexSectionForElectCard = tag/10;
        page.comfromFlag = 1;//预付费
        [self.navigationController pushViewController:page animated:YES];
    }
   
}

-(void)historyBillListTag:(NSInteger)tag{
    if (_eleFeePaymentArry[0].detail.count<=0) {
        [self showAlert];
        return;
    }
    IsBackFromHistoryBill = YES;
    if ([_eleFeePaymentArry[0].cardType integerValue] == 9) {
        HistoryBillListTwoViewController *page = [[HistoryBillListTwoViewController alloc]init];
        page.accountNo = _eleFeePaymentArry[tag/10].accountNo;
        [self.navigationController pushViewController:page animated:YES];
    }else{
        HistoryBillListViewController * page = [[HistoryBillListViewController alloc]init];
        page.accountNo = _eleFeePaymentArry[tag/10].accountNo;
        [self.navigationController pushViewController:page animated:YES];
    }
    
}
-(void)electUseChart{
//    if (indexPathNow.row<0) {
//        [MBProgressHUD showError:@"没有数据"];
//        return;
//    }
//    if (_eleFeePaymentArry[0].detail.count<=0) {
//        [self showAlert];
//        return;
//    }
//    IsBackFromElectricityChart = YES;
//    ElectricityFeeDisplayChartViewController * page = [[ElectricityFeeDisplayChartViewController alloc]init];
//    page.eleFeePaymentDict = _eleFeePaymentArry[0].detail[indexPathNow.row];
//    [self.navigationController pushViewController:page animated:YES];
    
    TrendViewController *page = [[TrendViewController alloc]init];
    page.accountNo = _eleFeePaymentArry[0].accountNo;
    page.cardType = _eleFeePaymentArry[0].cardType;
    [self.navigationController pushViewController:page animated:YES];
}

- (void)showAlert {
    
    alert = [[UIAlertView alloc] initWithTitle:@"账单未出，暂无数据" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];

    [alert show];
    recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    
    [recognizerTap setNumberOfTapsRequired:1];
    recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![alert pointInside:[alert convertPoint:location fromView:alert.window] withEvent:nil]){
            [alert.window removeGestureRecognizer:sender];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        }  
    }  
}

#pragma mark -electricityFeeBtnClick
-(void)electricityFeeBtnClick:(UIButton*)button{
    if ([button isEqual:newElectricityFeePaymentDisplayDownView.electricityFeePaymentBtn]) {
        [self payFeeBtnClickIndex:0 target:nil tag:0];
    }else if([button isEqual:newElectricityFeePaymentDisplayDownView.electSearcth]){
        [self elecSearchBtnClick:button];
    }else if ([button isEqual:newElectricityFeePaymentDisplayDownView.electHistoryBillList]){
        [self historyBillListTag:0];
    }else if ([button isEqual:newElectricityFeePaymentDisplayDownView.electUseChart]){
        [self electUseChart];
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

- (IBAction)rightBtnClick:(id)sender {
    IsBackFromElectricityCard = YES;
    ChoseElectricityCardViewController * page = [[ChoseElectricityCardViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
    return;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_3
    // 1. 创建UIAlertControl变量，但并不穿GIAn
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 3. 添加取消按钮
    // 3.1 UIAlertAction 表示一个按钮，同时，这个按钮带有处理事件的block
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    // 3.2 添加到alertController上
    [alertController addAction:action];
    
    
    // 4. 添加需要谨慎操作的按钮，文字默认是红色的
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"用电查询" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"用电查询");
            ElectricitySearchViewController  * page = [[ElectricitySearchViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }];
        action;
    })];
    
    
    // 5. 添加确定按钮
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"电卡管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"电卡管理");
            ElectricityCardViewController * page =[[ElectricityCardViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
            
        }];
        action;
    })];
    
    // 7. 显示（使用模态视图推出）
    [self presentViewController:alertController animated:YES completion:nil];
   

#else
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"用电查询",@"电卡管理",nil];
    [actionSheet showInView:self.view];
#endif
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex:%ld",buttonIndex);
    if (buttonIndex == 0) {
        NSLog(@"用电查询");
        ElectricitySearchViewController  * page = [[ElectricitySearchViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }else if (buttonIndex == 1){
        NSLog(@"电卡管理");
        ElectricityCardViewController * page =[[ElectricityCardViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
}

-(void)setTags{
    NSMutableArray * array = [NSMutableArray array];
    for (ElectricityCardList * dict  in _eleCardArry) {
        [array addObject:dict.accountNo];
    }
    //用于绑定Tag的 根据自己想要的Tag加入，值得注意的是这里Tag需要用到NSSet
    [JPUSHService setTags:[NSSet setWithArray:array] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    NSLog(@"%s %s",__func__,__PRETTY_FUNCTION__);

}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (IBAction)noticeBtnClick:(id)sender {
    ServiceAndNoticeViewController *page = [[ServiceAndNoticeViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
#pragma mark - 广播
- (void)addNotificationCount:(NSNotification *)noticefication{
    if ([noticefication.name isEqualToString:@"fetchDataWithNotice2"]) {
        _badgeView.badgeText = [[noticefication userInfo] objectForKey:@"num"];
    }else{
        int i = 0;
        if (_badgeView.badgeText) {
            if ([_badgeView.badgeText isEqual:@"99+"]) {
                i=100;
            }else{
                i = [_badgeView.badgeText intValue]+1;
            }
        }else{
            i=1;
        }
        if (i<=99) {
            _badgeView.badgeText = [NSString stringWithFormat:@"%d",i];
        }else{
            _badgeView.badgeText = @"99+";
        }
    }
}

#pragma mark - 初始化数据（未读消息等）
-(void)fetchDataWithNotice{
    
    if (![StorageUserInfromation storageUserInformation].token) {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.comeFromFlag = 1;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        return;
    }
    
    
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"app/initApp" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
            
            NSInteger unreadCount = [[DictToJson dictionaryWithJsonString:str][@"form"][@"unreadCount"] integerValue];
            if (unreadCount <= 0) {
                _badgeView.badgeText = @"";
                
            }else{
                if (unreadCount<=99) {
                    _badgeView.badgeText = [NSString stringWithFormat:@"%ld",unreadCount];
                }else{
                    _badgeView.badgeText = @"99+";
                }
            }
            
        }else{
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];

    }];
}
- (void)elecCardChange{
    [self fetchEleCard:2];
}
@end
