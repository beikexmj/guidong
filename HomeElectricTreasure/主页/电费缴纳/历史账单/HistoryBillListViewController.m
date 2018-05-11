//
//  HistoryBillListViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "HistoryBillListViewController.h"
#import "HistoryBillListTableViewCell.h"
#import "LGLCalenderCell.h"
#import "LGLHeaderView.h"
#import "LGLCalenderModel.h"
#import "LGLCalenderSubModel.h"
#import "LGLCalendarDate.h"
#import "LGLWeekView.h"
#import "UICollectionView+WFEmpty.h"

@interface HistoryBillListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger year;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableDictionary *cellDic; // 用来存放Cell的唯一标示符


@end

@implementation HistoryBillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    NSDate * date = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp1 = [myCal components:units fromDate:date];
    year = [comp1 year];
    self.dateTime.text = [NSString stringWithFormat:@"%ld年",year];

//    self.headerSubView.layer.cornerRadius = 5;
//    [self initOtherData];
    [self addHeaderWeekView];
//    [self getData];
    [self createCalendarView];
    _eleFeePaymentArry = [NSMutableArray array];

    [self fetchData:0];//0 不变 1 year-- 2 year++;
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)fetchData:(NSInteger)flag{
    
    
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"year":[NSString stringWithFormat:@"%ld",year],@"accountNo":self.accountNo};
    [MBProgressHUD showMessage:@""];
    [ZTHttpTool postWithUrl:@"user/electricUser/getElectricCardHistory" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ElectricityCardHistoryListDataModel *electricityCard = [ElectricityCardHistoryListDataModel mj_objectWithKeyValues:str];
        if (electricityCard.rcode == 0) {
            [_eleFeePaymentArry removeAllObjects];
            [_eleFeePaymentArry addObjectsFromArray:electricityCard.form];
            if (_eleFeePaymentArry.count == 0) {
//                //button事件year增减回去。
//                if (flag == 1) {
//                    year++;
//                }else if (flag ==2){
//                    year--;
//                }
                [self.collectionView addEmptyViewWithImageName:@"历史账单" title:@"暂无历史账单"];
                self.collectionView.emptyView.hidden = NO;
                
            }else{
                self.collectionView.emptyView.hidden = YES;
            }
            [self resetData];
            [self.collectionView reloadData];
        }else{
            //button事件year增减回去。
            if (flag == 1) {
                year++;
            }else if (flag ==2){
                year--;
            }
            [self.collectionView addEmptyViewWithImageName:@"历史账单" title:@"暂无历史账单"];
            self.collectionView.emptyView.hidden = NO;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
        [self.collectionView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.collectionView.emptyView.hidden = NO;
    }];
    
}
-(void)resetData{
    NSInteger startMonth = _eleFeePaymentArry.lastObject.month;
    NSInteger endMonth = _eleFeePaymentArry.firstObject.month;
    [LGLCalenderModel getCalenderDataWithYear:year startMonth:startMonth endMonth:endMonth  ElectricityCardHistoryListDataModel:(NSMutableArray<ElectricityCardHistoryListForm*> *)[[_eleFeePaymentArry reverseObjectEnumerator] allObjects] block:^(NSMutableArray *result) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[[result reverseObjectEnumerator] allObjects]];
        [self.collectionView reloadData];
    }];
    self.dateTime.text = [NSString stringWithFormat:@"%ld年",year];
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

- (void)addHeaderWeekView {
    LGLWeekView * week = [[LGLWeekView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, 30)];
    [self.view addSubview:week];
}




-(void)createCalendarView
{
    //布局
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    //设置item的宽高
    layout.itemSize=CGSizeMake(SCREEN_WIDTH / 7, 412.0 / 7);
    //设置滑动方向
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //设置行间距
    layout.minimumLineSpacing=0.0f;
    //每列的最小间距
    layout.minimumInteritemSpacing = 0.0f;
    //四周边距
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, SCREEN_HEIGHT - 144) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.collectionView];
    // [self.collectionView registerClass:[LGLCalenderCell class] forCellWithReuseIdentifier:@"calender"];
    [self.collectionView registerClass:[LGLHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"calenderHeaderView"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    LGLCalenderModel * model = self.dataSource[section];
    return model.details.count + model.firstday;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"LGLCalenderCell%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.collectionView registerClass:[LGLCalenderCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    LGLCalenderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ((indexPath.row / 7) % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:247.0/255 green:248.0/255 blue:249.0/255 alpha:1];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (self.dataSource.count) {
        LGLCalenderModel * model = self.dataSource[indexPath.section];
        if (indexPath.item >= model.firstday) {
            NSInteger index = indexPath.item - model.firstday;
            LGLCalenderSubModel * subModel = model.details[index];
            cell.dateL.text = [NSString stringWithFormat:@"%ld",(long)subModel.day];
            cell.priceL.text = [[NSString stringWithFormat:@"%@", subModel.price] isEqualToString:@"-99999"]?@"-":[NSString stringWithFormat:@"%@", subModel.price];
            cell.electNum.text = [[NSString stringWithFormat:@"%@", subModel.elecNum] isEqualToString:@"-99999"]?@"-":[NSString stringWithFormat:@"%.1f", subModel.elecNum.floatValue];
           
        }else{
            cell.dateL.text = @"";
            cell.priceL.text =@"";
            cell.electNum.text = @"";

        }
    }
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    LGLHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"calenderHeaderView" forIndexPath:indexPath];
    LGLCalenderModel * model = self.dataSource[indexPath.section];
    headerView.dateL.text = [NSString stringWithFormat:@"%ld月 电费%@元 用电%@度",model.month,model.totalFee,model.totalElecNumber];
    
    NSMutableAttributedString * moneyAttriStr = [[NSMutableAttributedString alloc] initWithString:headerView.dateL.text];
    headerView.dateL.tintColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1];
    //设置字号(月)
    [moneyAttriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld",model.month] length])];
    //设置文字颜色（月）
    [moneyAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:167.0/255  blue:255.0/255 alpha:1] range:NSMakeRange(0, [[NSString stringWithFormat:@"%ld",model.month] length])];
    
    //设置文字颜色（元）
    [moneyAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0] range:NSMakeRange([[NSString stringWithFormat:@"%ld",model.month] length]+4, [model.totalFee length])];
    
    //设置文字颜色（度）
    [moneyAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:167.0/255  blue:255.0/255 alpha:1] range:NSMakeRange([headerView.dateL.text length]-[model.totalElecNumber length]-1, [model.totalElecNumber length])];
    
    headerView.dateL.attributedText = moneyAttriStr;

    
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    LGLCalenderModel * model = self.dataSource[indexPath.section];
//    NSInteger index = indexPath.row - model.firstday;
//    LGLCalenderSubModel * subModel = model.details[index];
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue: [NSString stringWithFormat:@"%ld", model.year] forKey:@"year"];
//    [dic setValue: [NSString stringWithFormat:@"%ld", model.month] forKey:@"month"];
//    [dic setValue: [NSString stringWithFormat:@"%ld", subModel.day] forKey:@"day"];
//    [dic setValue: [NSString stringWithFormat:@"%@",  subModel.price] forKey:@"price"];
//    self.block(dic);
    
//    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)seleDateWithBlock:(SelectDateBalock)block {
//    self.block = block;
//}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableDictionary *)cellDic {
    if (!_cellDic) {
        _cellDic = [NSMutableDictionary dictionary];
    }
    return _cellDic;
}

- (IBAction)NextOrBeforeYearBtnClick:(id)sender {
    UIButton * button = sender;
    if (button.tag == 10) {
        year--;
        [self fetchData:1];//0 不变 1 year-- 2 year++;
    }else{
        year++;
        [self fetchData:2];//0 不变 1 year-- 2 year++;
    }
}
@end
