//
//  ElectricitySearchViewController.m
//  copooo
//
//  Created by 夏明江 on 2016/10/27.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricitySearchViewController.h"
//#import "HMDatePickView.h"
#import "ElectricityUseDetailViewController.h"
#import "ElectricityCardDataModel.h"
#import "HooDatePicker/HooDatePicker.h"
@interface ElectricitySearchViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,HooDatePickerDelegate>
{
    NSString * elecCardnoForChose;
    BOOL isSelect;
    BOOL startTimeOrendTime;//==YES startime ; == NO endTime;
}
@property (nonatomic,strong)NSMutableArray *elecCardNoArray;
@property (nonatomic,strong)UIView *pickerFatherView;
@property (nonatomic,strong)UIView *dateBgView;
@property (nonatomic, strong) HooDatePicker *datePicker;

@end

@implementation ElectricitySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [self datePickerInit];
    self.searchBtn.layer.cornerRadius = 5;
    _elecCardNoArray = [NSMutableArray array];
    _elecCardNo.text = _accountNo;
    [self fetchData];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)datePickerInit{
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    if ([_cardType integerValue] == 9) {
        self.datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    }else{
        self.datePicker.datePickerMode = HooDatePickerModeDate;
    }
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
    NSDate *maxDate = [dateFormatter dateFromString:@"2050-01-01"];
    NSDate *minDate = [dateFormatter dateFromString:@"2010-01-01"];
    
    [self.datePicker setDate:[NSDate date] animated:YES];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            NSArray<ElectricityCardList*> * myArray = electricityCard.form.list;
            for (ElectricityCardList * list in myArray) {
                if (list.eleType == [self.cardType integerValue]) {
                    [_elecCardNoArray addObject:list.accountNo];
                }
            }
            if (_elecCardNoArray.count>0) {
                elecCardnoForChose = _elecCardNoArray.firstObject;
 
            }else{
                elecCardnoForChose = @"0";
            }
            
        }else{
           
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startTimeBtnClick:(id)sender {
    startTimeOrendTime = YES;
//    if (![self.startTime.text isEqual:@""]) {
//        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
//        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
//        NSDate *date = [dateFormatter dateFromString:self.startTime.text];
//        [self.datePicker setDate:[NSDate date] animated:YES];
//    }
    [self.datePicker setDate:[NSDate date] animated:YES];

    [self.datePicker show];
//    /** 自定义日期选择器 */
//    
//    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.view.frame];
//    //距离当前日期的年份差（设置最大可选日期）
//    datePickVC.maxYear = 0;
//    //设置最小可选日期(年分差)
//    //    _datePickVC.minYear = 10;
//    datePickVC.date = [NSDate date];
//    //设置字体颜色
////    datePickVC.fontColor = [UIColor redColor];
//    //日期回调
//    datePickVC.completeBlock = ^(NSString *selectDate) {
//       
//        if ([self.endTime.text isEqual:@""]) {
//            self.startTime.text = selectDate;
//        }else{
//            switch ([self compareDate:selectDate withDate:self.endTime.text]) {
//                case 0: //endTime=startTime
//                {
//                    self.startTime.text = selectDate;
//                }
//                    break;
//                case 1://endTime比startTime大
//                {
//                    self.startTime.text = selectDate;
//                }
//                    break;
//                case -1://endTime比startTime小
//                {
//                    [MBProgressHUD showError:@"起始时间不能晚于截止时间"];
//                }
//                    break;
//
//                default:
//                    break;
//            }
//        }
//    };
//    //配置属性
//    [datePickVC configuration];
//    
//    [self.view addSubview:datePickVC];
    
    
    
}
//比较日期大小
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if ([_cardType integerValue] == 9) {
        [df setDateFormat:@"yyyy-MM"];
    }else{
        [df setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    NSLog(@"result %d", ci);
    return ci;
}
- (IBAction)endTimeBtnClick:(id)sender {
    startTimeOrendTime = NO;
//    if (![self.endTime.text isEqual:@""]) {
//        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
//        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
//        NSDate *date = [dateFormatter dateFromString:self.endTime.text];
//        [self.datePicker setDate:[NSDate date] animated:YES];
//    }
    [self.datePicker setDate:[NSDate date] animated:YES];

    [self.datePicker show];

//    /** 自定义日期选择器 */
//    
//    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.view.frame];
//    //距离当前日期的年份差（设置最大可选日期）
//    datePickVC.maxYear = 0;
//    //设置最小可选日期(年分差)
//    //    _datePickVC.minYear = 10;
//    datePickVC.date = [NSDate date];
//    //设置字体颜色
////    datePickVC.fontColor = [UIColor redColor];
//    //日期回调
//    datePickVC.completeBlock = ^(NSString *selectDate) {
//        if ([self.startTime.text isEqual:@""]) {
//            self.endTime.text = selectDate;
//        }else{
//            switch ([self compareDate:self.startTime.text withDate:selectDate]) {
//                case 0: //endTime=startTime
//                {
//                    self.endTime.text = selectDate;
//                }
//                    break;
//                case 1://endTime比startTime大
//                {
//                    self.endTime.text = selectDate;
//                }
//                    break;
//                case -1://endTime比startTime小
//                {
//                    [MBProgressHUD showError:@"截止时间不能早于起始时间"];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//
//    };
//    //配置属性
//    [datePickVC configuration];
//    
//    [self.view addSubview:datePickVC];
}
#pragma mark - FlatDatePicker Delegate

- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy-MM"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
        
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
}

- (void)datePicker:(HooDatePicker *)datePicker didCancel:(UIButton *)sender {
    
    
}

- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy-MM"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *selectDate = [dateFormatter stringFromDate:date];
    NSLog(@"selectDate:%@",selectDate);
    if (startTimeOrendTime) {
        if ([self.endTime.text isEqual:@""]) {
            self.startTime.text = selectDate;
        }else{
            switch ([self compareDate:selectDate withDate:self.endTime.text]) {
                case 0: //endTime=startTime
                {
                    self.startTime.text = selectDate;
                }
                    break;
                case 1://endTime比startTime大
                {
                    self.startTime.text = selectDate;
                }
                    break;
                case -1://endTime比startTime小
                {
                    [MBProgressHUD showError:@"起始时间不能晚于截止时间"];
                }
                    break;
                    
                default:
                    break;
            }
        }

    }else{
        if ([self.startTime.text isEqual:@""]) {
                self.endTime.text = selectDate;
            }else{
                switch ([self compareDate:self.startTime.text withDate:selectDate]) {
                    case 0: //endTime=startTime
                    {
                        self.endTime.text = selectDate;
                    }
                        break;
                    case 1://endTime比startTime大
                    {
                        self.endTime.text = selectDate;
                    }
                        break;
                    case -1://endTime比startTime小
                    {
                        [MBProgressHUD showError:@"截止时间不能早于起始时间"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }

    }
    
    
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.startTime.text ]) {
        [MBProgressHUD showError:@"请选择起始时间"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.endTime.text]) {
        [MBProgressHUD showError:@"请选择截止时间"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.elecCardNo.text]) {
        [MBProgressHUD showError:@"请选择电卡"];
        return;
    }
    ElectricityUseDetailViewController * page = [[ElectricityUseDetailViewController alloc]init];
    page.startTime = self.startTime.text;
    page.endTime = self.endTime.text;
    page.elecCardNo = self.elecCardNo.text;
    page.cardTpye = self.cardType;
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)elecCardNoChoseBtnClick:(id)sender {
    return;
//    if (_elecCardNoArray.count<=0) {
//        [MBProgressHUD showError:@"暂无电卡"];
//        return;
//    }
//    // 选择框
//
//    _pickerFatherView = [[UIView alloc]initWithFrame:self.view.frame];
//    _pickerFatherView.backgroundColor = [UIColor colorWithWhite:0.227 alpha:0.5];
//
//    //时间选择器
//    _dateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
//    _dateBgView.backgroundColor = [UIColor whiteColor];
//    [_pickerFatherView addSubview:_dateBgView];
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _dateBgView.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
//    } completion:^(BOOL finished) {
//        //finished判断动画是否完成
//        if (finished) {
//            NSLog(@"finished");
//        }
//    }];
//
//    //确定按钮
//    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    commitBtn.frame = CGRectMake(_dateBgView.bounds.size.width - 50, 0, 40, 30);
//    commitBtn.tag = 1;
//    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [commitBtn addTarget:self action:@selector(pressentPickerView:) forControlEvents:UIControlEventTouchUpInside];
//    [_dateBgView addSubview:commitBtn];
//
//    //取消按钮
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(10, 0, 40, 30);
//    cancelBtn.tag = 0;
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(pressentPickerView:) forControlEvents:UIControlEventTouchUpInside];
//    [_dateBgView addSubview:cancelBtn];
//
//
//    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, 162)];
//    // 显示选中框
//    pickerView.showsSelectionIndicator=YES;
//    pickerView.dataSource = self;
//    pickerView.delegate = self;
//    [_dateBgView addSubview:pickerView];
//
//    isSelect = NO;
//
//    [self.view addSubview:_pickerFatherView];
}

- (void)pressentPickerView:(UIButton *)button {
    if (button.tag == 0) {//取消
        
    }else if(button.tag == 1){//确定
        if (isSelect) {
            _elecCardNo.text = elecCardnoForChose;

        }else{
            _elecCardNo.text = _elecCardNoArray.firstObject;
        }
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dateBgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    } completion:^(BOOL finished) {
        //finished判断动画是否完成
        if (finished) {
            NSLog(@"finished");
        }
        [_pickerFatherView removeFromSuperview];
    }];
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_elecCardNoArray count];
}
#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return SCREEN_WIDTH;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     isSelect = YES;
    elecCardnoForChose = [_elecCardNoArray objectAtIndex:row];
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_elecCardNoArray objectAtIndex:row];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dateBgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    } completion:^(BOOL finished) {
        //finished判断动画是否完成
        if (finished) {
            NSLog(@"finished");
        }
        [_pickerFatherView removeFromSuperview];
    }];
}
@end
