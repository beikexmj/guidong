//
//  QuarterViewController.m
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/3.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "QuarterViewController.h"
#import "WYChartCategory.h"
#import "WYPieChartView.h"
#import "PieChartSettingViewController.h"
#import "TrendHeaderView.h"
#import "QuarterChartView.h"
#import "DataComparisonView.h"
#import "ElectricityAdviceView.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface QuarterViewController ()<WYPieChartViewDelegate,
WYPieChartViewDatasource>
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic, strong) WYPieChartView *pieView;
@property (nonatomic, strong) PieChartSettingViewController *settingViewController;
@property (nonatomic,strong)DataComparisonView *dataComparisonView;
@property (nonatomic,strong)ElectricityAdviceView *electricityAdviceView;
@end

@implementation QuarterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, k_MainBoundsHeight-64)];
    if(kDevice_Is_iPhoneX){
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, k_MainBoundsHeight-64-56)];
    }
    _myScrollView.contentSize = CGSizeMake(k_MainBoundsWidth, 100+k_MainBoundsWidth/2.0+50+20+300+100);
    [self.view addSubview:_myScrollView];
    
    TrendHeaderView *trendHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"TrendHeaderView" owner:self options:nil] lastObject];
    trendHeaderView.frame = CGRectMake(0, 0, k_MainBoundsWidth, 100);
    trendHeaderView.eleNum.text = _electricUserQuarterTrend.pointTrendQuarter.totalElecSum;//@"720.0";
    trendHeaderView.eleFee.text = _electricUserQuarterTrend.pointTrendQuarter.totalElecPrice;//@"1003.00";
    trendHeaderView.date.text = [_electricUserQuarterTrend.pointTrendQuarter.currentDate stringByReplacingOccurrencesOfString:@"|" withString:@"/"];//@"2017/二季度";
    [_myScrollView addSubview:trendHeaderView];
    // Do any additional setup after loading the view.
    NSInteger i= 0;
    for (QuarterData *data in _electricUserQuarterTrend.pointTrendQuarter.data) {
        if ([data.elecSum isEqualToString:@"0"]) {
            i++;
        }
    }
    
    if (_electricUserQuarterTrend.pointTrendQuarter.data.count == 0 || i==3) {
        CGRect frame = CGRectMake(0, 100, k_MainBoundsWidth,  k_MainBoundsWidth/2.0+50);
        UIView *emptyDataView = [[UIView alloc]initWithFrame:frame];
        UIImage* image = [UIImage imageNamed:@"暂无数据-2"];
        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-k_MainBoundsWidth/2.0)/2, 0, k_MainBoundsWidth/2.0, k_MainBoundsWidth/2.0+20)];
        carImageView.image = image;
        [emptyDataView addSubview:carImageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, k_MainBoundsWidth/2.0+25, SCREEN_WIDTH, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:RGBCOLOR(96, 96, 96)];
        label.text = @"暂无数据";
        label.font = [UIFont systemFontOfSize:14];
        [emptyDataView addSubview:label];
        [self.myScrollView addSubview:emptyDataView];
    }else{
        
        QuarterChartView *quarterChartView = [[[NSBundle mainBundle] loadNibNamed:@"QuarterChartView" owner:self options:nil] lastObject];
        quarterChartView.frame = CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth/2.0+50);
        
        quarterChartView.monthOne.text = [NSString stringWithFormat:@"%@月",_electricUserQuarterTrend.pointTrendQuarter.data[0].month];
        quarterChartView.monthTwo.text = [NSString stringWithFormat:@"%@月",_electricUserQuarterTrend.pointTrendQuarter.data[1].month];
        quarterChartView.monthThree.text = [NSString stringWithFormat:@"%@月",_electricUserQuarterTrend.pointTrendQuarter.data[2].month];
        quarterChartView.monthOneElecNum.text = [NSString stringWithFormat:@"%0.1f 度",_electricUserQuarterTrend.pointTrendQuarter.data[0].elecSum.floatValue];
        quarterChartView.monthTwoElecNum.text = [NSString stringWithFormat:@"%.1f 度",_electricUserQuarterTrend.pointTrendQuarter.data[1].elecSum.floatValue];
        quarterChartView.monthThreeElecNum.text = [NSString stringWithFormat:@"%.1f 度",_electricUserQuarterTrend.pointTrendQuarter.data[2].elecSum.floatValue];
        quarterChartView.monthOneElecFee.text = [NSString stringWithFormat:@"%@ 元",_electricUserQuarterTrend.pointTrendQuarter.data[0].elecFree];
        quarterChartView.monthTwoElecFee.text = [NSString stringWithFormat:@"%@ 元",_electricUserQuarterTrend.pointTrendQuarter.data[1].elecFree];
        quarterChartView.monthThreeElecFee.text = [NSString stringWithFormat:@"%@ 元",_electricUserQuarterTrend.pointTrendQuarter.data[2].elecFree];
        quarterChartView.monthOneProportionlabel.text = [NSString stringWithFormat:@"%@占比",quarterChartView.monthOne.text];
        quarterChartView.monthTwoProportionLabel.text = [NSString stringWithFormat:@"%@占比",quarterChartView.monthTwo.text];
        quarterChartView.monthThreeProportionLabel.text = [NSString stringWithFormat:@"%@占比",quarterChartView.monthThree.text];
        
        CGFloat elecNumSum = 0;
        for (QuarterData * data in _electricUserQuarterTrend.pointTrendQuarter.data) {
            elecNumSum += [data.elecSum floatValue];
        }
        quarterChartView.monthOneProportion.text = [NSString stringWithFormat:@"%0.2f%%",[_electricUserQuarterTrend.pointTrendQuarter.data[0].elecSum floatValue]/elecNumSum*100];
        quarterChartView.monthTwoProportion.text = [NSString stringWithFormat:@"%0.2f%%",[_electricUserQuarterTrend.pointTrendQuarter.data[1].elecSum floatValue]/elecNumSum*100];
        quarterChartView.monthThreeProportion.text = [NSString stringWithFormat:@"%0.2f%%",[_electricUserQuarterTrend.pointTrendQuarter.data[2].elecSum floatValue]/elecNumSum*100];
        
        [self.myScrollView addSubview:quarterChartView];
        _settingViewController = [[PieChartSettingViewController alloc] init];
        
        _pieView = [[WYPieChartView alloc] initWithFrame:CGRectMake(0,0,k_MainBoundsWidth/2.0 , k_MainBoundsWidth/2.0)];
        _pieView.delegate = self;
        _pieView.datasource = self;
        _pieView.backgroundColor = [UIColor clearColor];
        if (_electricUserQuarterTrend.pointTrendQuarter.data.count>0) {
            _pieView.yearLabel.text = _electricUserQuarterTrend.pointTrendQuarter.data[0].year;
            _pieView.quarterLabel.text = [_electricUserQuarterTrend.pointTrendQuarter.currentDate substringFromIndex:5];//_electricUserQuarterTrend.pointTrendQuarter.data[0].quarter;
        }
        NSMutableArray *dataArry = [NSMutableArray array];
        for (QuarterData *data in _electricUserQuarterTrend.pointTrendQuarter.data) {
            [dataArry addObject:data.elecSum];
        }
        _pieView.values = dataArry;
        
        [quarterChartView addSubview:_pieView];
        
    }
    
//    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"数据对比",@"用电建议",nil];
//
//    UISegmentedControl *mySeg = [[UISegmentedControl alloc]initWithItems:segmentedArray];
//    mySeg.frame = CGRectMake((k_MainBoundsWidth-160)/2.0, 100+k_MainBoundsWidth/2.0+50+20, 160, 30);
//    mySeg.selectedSegmentIndex = 0;
//
//    mySeg.tintColor = [UIColor colorWithRed:0/255.0 green:167/255.0 blue:255/255.0 alpha:1];
//    [mySeg addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
//    [_myScrollView addSubview:mySeg];
    
    _dataComparisonView = [[[NSBundle mainBundle] loadNibNamed:@"DataComparisonView" owner:self options:nil] lastObject];
    _dataComparisonView.frame = CGRectMake(0, 100+k_MainBoundsWidth/2.0+50+20, k_MainBoundsWidth, 300+100);
    [self.myScrollView addSubview:_dataComparisonView];
//    NSArray *xLineDataArr = @[@"4",@"5",@"6"];
//    NSArray *valueArr = @[@[@"5",@"-22",@"17"],@[@"1",@"-12",@"1"]];
    
//    [_dataComparisonView reInit:xLineDataArr Value:valueArr];
//    _dataComparisonView.lineChart.showMomLabel = YES;
//    _dataComparisonView.lineChart.unit = @"单位:月";
    [self jhLineChartDataComparison];
    [_dataComparisonView hiddenAnViewAnMonView];
    
    _electricityAdviceView = [[[NSBundle mainBundle] loadNibNamed:@"ElectricityAdviceView" owner:self options:nil] lastObject];
    _electricityAdviceView.elecAdvice.text = _electricUserQuarterTrend.quarter.proposal;
    _electricityAdviceView.frame = CGRectMake(0, 100+k_MainBoundsWidth/2.0+50+20, k_MainBoundsWidth, 300);
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    _pieView.style = [_settingViewController.parameters[kPieChartStyle] unsignedIntegerValue];
    _pieView.selectedStyle = [_settingViewController.parameters[kPieChartSelectedStyle] unsignedIntegerValue];
    _pieView.animationStyle = [_settingViewController.parameters[kPieChartAnimationStyle] unsignedIntegerValue];
    _pieView.animationDuration = roundf([_settingViewController.parameters[kPieChartAnimationDuration] floatValue]);
    _pieView.fillByGradient = [_settingViewController.parameters[kPieChartFillByGradient] boolValue];;
    _pieView.showInnerCircle = [_settingViewController.parameters[kPieChartShowInnerCircle] boolValue];
    _pieView.rotatable = [_settingViewController.parameters[kPieChartRotatable] boolValue];
    [_pieView update];
}

- (void)handleSettingButton {
    
    [self.navigationController pushViewController:_settingViewController
                                         animated:true];
}

#pragma mark - Pie Chart View Delegate
- (NSInteger)numberOfLabelOnPieChartView:(WYPieChartView *)pieChartView {
    
    return 3;
}

#pragma mark - Pie Chart View Datasource

- (NSString *)pieChartView:(WYPieChartView *)pieChartView textForLabelAtIndex:(NSInteger)index {
    CGFloat f = 0;
    for (NSNumber *number in _pieView.values) {
        
      f +=  [number floatValue];
    }
   CGFloat ff = [_pieView.values[index] floatValue]/f *100;
    return [NSString stringWithFormat:@"%0.2f%%",ff];
}

- (NSInteger)pieChartView:(WYPieChartView *)pieChartView valueIndexReferToLabelAtIndex:(NSInteger)index {
    return index;
}

- (UIColor *)pieChartView:(WYPieChartView *)pieChartView sectorColorAtIndex:(NSInteger)index {
    
    UIColor *color;
    
    switch (index) {
        case 0:
            color = [UIColor colorWithRed:255/255.0 green:85/255.0 blue:129/255.0 alpha:1];
            break;
        case 1:
            color = [UIColor colorWithRed:0 green:204/255.0 blue:255/255.0 alpha:1];

            break;
        case 2:
            color = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:0 alpha:1];

            break;
        case 3:
            color = [UIColor wy_colorWithHexString:@"#78D8D0"];
            break;
        case 4:
            color = [UIColor wy_colorWithHexString:@"#0C4762"];
            break;
        default:
            break;
    }
    return color;
}
- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %ld", Index);
    [_electricityAdviceView removeFromSuperview];
    [_dataComparisonView removeFromSuperview];
    switch (Index) {
        case 0:
            [_myScrollView addSubview:_dataComparisonView];
            [_dataComparisonView showAnimation];
            break;
        case 1:
            [_myScrollView addSubview:_electricityAdviceView];
            break;
        default:
            break;
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

- (void)jhLineChartDataComparison{
    _dataComparisonView.anLabel.text = _electricUserQuarterTrend.pointTrendQuarter.anDate;
    _dataComparisonView.momLabel.text = _electricUserQuarterTrend.pointTrendQuarter.momDate;
    NSString * anStr = _electricUserQuarterTrend.pointTrendQuarter.an;
    NSString * monStr = _electricUserQuarterTrend.pointTrendQuarter.mom;
    if ([_dataComparisonView.anLabel.text isEqualToString:@"暂无数据"]&[_dataComparisonView.momLabel.text isEqualToString:@"暂无数据"]) {
        _dataComparisonView.anData.text = _dataComparisonView.monData.text = @"暂无数据";
        return;
    }
    if ([anStr isEqualToString:@"暂无数据"]) {
        _dataComparisonView.anData.text = anStr;
    }else{
        if ( [anStr isEqualToString:@"0"]) {
            _dataComparisonView.anData.text = @"0.00%";
            [_dataComparisonView.anData setTextColor:RGBCOLOR(156, 156, 156)];
        }else if ([anStr isEqualToString:@"--"]){
            _dataComparisonView.anData.text = anStr;
            [_dataComparisonView.anData setTextColor:RGBCOLOR(96, 96, 96)];
        }else{
            if ([anStr floatValue]>0){
                _dataComparisonView.anData.text = [NSString stringWithFormat:@"+%0.2f%%",anStr.floatValue];
                [_dataComparisonView.anData setTextColor:RGBCOLOR(255, 59, 20)];
                
            }else{
                _dataComparisonView.anData.text = [NSString stringWithFormat:@"%.2f%%",anStr.floatValue];
                [_dataComparisonView.anData setTextColor:RGBCOLOR(11, 208, 52)];
                
            }
        }
    }
    
    if ([monStr isEqualToString:@"暂无数据"]) {
        _dataComparisonView.monData.text = monStr;

    }else{
        if ( [monStr isEqualToString:@"0"]) {
            _dataComparisonView.monData.text = @"0.00%";
            [_dataComparisonView.monData setTextColor:RGBCOLOR(156, 156, 156)];
        }else if ([monStr isEqualToString:@"--"]){
            _dataComparisonView.monData.text = monStr;
            [_dataComparisonView.monData setTextColor:RGBCOLOR(96, 96, 96)];
        }else{
            if ([monStr floatValue]>0){
                _dataComparisonView.monData.text = [NSString stringWithFormat:@"+%.2f%%",monStr.floatValue];
                [_dataComparisonView.monData setTextColor:RGBCOLOR(255, 59, 20)];
                
            }else{
                _dataComparisonView.monData.text = [NSString stringWithFormat:@"%.2f%%",monStr.floatValue];
                [_dataComparisonView.monData setTextColor:RGBCOLOR(11, 208, 52)];
                
            }
        }
    }
    
}


- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
