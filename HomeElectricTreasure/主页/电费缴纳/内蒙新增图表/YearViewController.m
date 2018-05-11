//
//  YearViewController.m
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/3.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "YearViewController.h"
#import "WYLineChartView.h"
#import "WYLineChartPoint.h"
#import "WYChartCategory.h"
#import "LineChartSettingViewController.h"
#import "TrendHeaderView.h"
#import "DataComparisonView.h"
#import "ElectricityAdviceView.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface YearViewController ()<WYLineChartViewDelegate,
WYLineChartViewDatasource,JHLineChartDelegate>
@property (nonatomic, strong) WYLineChartView *chartView;
@property (nonatomic, strong) NSMutableArray <WYLineChartPoint *>*points;

@property (nonatomic, strong) UILabel *touchLabel;

@property (nonatomic, strong) LineChartSettingViewController *settingViewController;
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)DataComparisonView *dataComparisonView;
@property (nonatomic,strong)ElectricityAdviceView *electricityAdviceView;
@end

@implementation YearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, k_MainBoundsHeight-64)];
                                                                  if(kDevice_Is_iPhoneX){
                                                                      _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, k_MainBoundsHeight-64-56)];
                                                                      
                                                                  }
    _myScrollView.contentSize = CGSizeMake(k_MainBoundsWidth, 100+300+20+300+100);
    [self.view addSubview:_myScrollView];
    
    TrendHeaderView *trendHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"TrendHeaderView" owner:self options:nil] lastObject];
    trendHeaderView.frame = CGRectMake(0, 0, k_MainBoundsWidth, 100);
    trendHeaderView.eleNum.text = _electricUserYearTrend.pointTrendYear.totalElecSum;//@"8920.0";
    trendHeaderView.eleFee.text = _electricUserYearTrend.pointTrendYear.totalElecPrice;//@"12503.00";
    trendHeaderView.date.text = _electricUserYearTrend.pointTrendYear.currentDate;//@"2017";
    [_myScrollView addSubview:trendHeaderView];
    // Do any additional setup after loading the view.
    
   
    
    
    if (_electricUserYearTrend.pointTrendYear.data.count == 0) {
        CGRect frame = CGRectMake(0, 100, k_MainBoundsWidth,  k_MainBoundsWidth/2.0+50);
        UIView *emptyDataView = [[UIView alloc]initWithFrame:frame];
        UIImage* image = [UIImage imageNamed:@"暂无数据1"];
        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-k_MainBoundsWidth/2.0)/2, 10, k_MainBoundsWidth/2.0, k_MainBoundsWidth/2.0+20)];
        carImageView.image = image;
        [emptyDataView addSubview:carImageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, k_MainBoundsWidth/2.0+35, SCREEN_WIDTH, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:RGBCOLOR(96, 96, 96)];
        label.text = @"暂无数据";
        label.font = [UIFont systemFontOfSize:14];
        [emptyDataView addSubview:label];
        [self.myScrollView addSubview:emptyDataView];
    }else{
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
        
        _settingViewController = [[LineChartSettingViewController alloc] init];
        
        
        
        _points = [NSMutableArray array];
        for (NSInteger idx = 0; idx < _electricUserYearTrend.pointTrendYear.data.count +2; ++idx) {
            WYLineChartPoint *point = [[WYLineChartPoint alloc] init];
            point.index = idx;
            [_points addObject:point];
        }
        
        _points[0].value = 0;
        for (NSInteger i = 0;i<= _electricUserYearTrend.pointTrendYear.data.count;i++) {
            if (i== _electricUserYearTrend.pointTrendYear.data.count) {
                _points[i+1].value = 0;
            }else{
                _points[i+1].value = [_electricUserYearTrend.pointTrendYear.data[i].data floatValue];
                _points[i+1].index = [_electricUserYearTrend.pointTrendYear.data[i].month integerValue];
            }
        }
        _chartView = [[WYLineChartView alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, 300)];
        _chartView.delegate = self;
        _chartView.datasource = self;
        _chartView.points = _points;
        
        CGFloat maxPiontY = 0;
        for (WYLineChartPoint *point in _chartView.points) {
            if (maxPiontY<point.value) {
                maxPiontY = point.value;
            }
        }
        if (maxPiontY<=300) {
            _chartView.gradientColors = @[[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1]];
            _chartView.gradientColorsLocation = @[@(0.0),@(1.0)];
            
        }else if(maxPiontY<=600){
            _chartView.gradientColors = @[[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1],[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1]];
            _chartView.gradientColorsLocation = @[@(0.5),@(1.0)];
            
        }else if (maxPiontY <=900){
            _chartView.gradientColors = @[
                                          [UIColor colorWithRed:238/255.0 green:53/255.0 blue:214/255.0 alpha:1],[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1],[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1]];
            _chartView.gradientColorsLocation = @[@(0.33),@(0.66),@(1.0)];
            
            
        }else if (maxPiontY<=1200){
            _chartView.gradientColors = @[[UIColor colorWithRed:255/255.0 green:54/255.0 blue:39/255.0 alpha:1],
                                          [UIColor colorWithRed:238/255.0 green:53/255.0 blue:214/255.0 alpha:1],[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1],[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1]];
            _chartView.gradientColorsLocation = @[@(0.25),@(0.5),@(0.75),@(1.0)];
            
        }else{
            CGFloat f = 300/maxPiontY;
            _chartView.gradientColors = @[
                                          [UIColor colorWithRed:255/255.0 green:54/255.0 blue:39/255.0 alpha:1],
                                          [UIColor colorWithRed:238/255.0 green:53/255.0 blue:214/255.0 alpha:1],[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1],[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1]];
            _chartView.gradientColorsLocation = @[@(1-3*f),@(1-2*f),@(1-f),@(1)];
            
        }
        
        
        _chartView.touchPointColor = [UIColor redColor];
        
        //    _chartView.yAxisHeaderPrefix = @"消费总数";
        _chartView.yAxisHeaderSuffix = @"单位：月";
        
        _chartView.lineColor = [UIColor clearColor];
        _chartView.junctionColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
        
        _touchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _touchLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
        _touchLabel.textColor = [UIColor blackColor];
        _touchLabel.layer.cornerRadius = 5;
        _touchLabel.layer.masksToBounds = YES;
        _touchLabel.textAlignment = NSTextAlignmentCenter;
        _touchLabel.font = [UIFont systemFontOfSize:13.f];
        _chartView.touchView = _touchLabel;
        
        [self.myScrollView addSubview:_chartView];

    }
//    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"数据对比",@"用电建议",nil];
//
//    UISegmentedControl *mySeg = [[UISegmentedControl alloc]initWithItems:segmentedArray];
//    mySeg.frame = CGRectMake((k_MainBoundsWidth-160)/2.0, 100+300+20, 160, 30);
//    mySeg.selectedSegmentIndex = 0;
//
//    mySeg.tintColor = [UIColor colorWithRed:0/255.0 green:167/255.0 blue:255/255.0 alpha:1];
//    [mySeg addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
//    [_myScrollView addSubview:mySeg];
    
    _dataComparisonView = [[[NSBundle mainBundle] loadNibNamed:@"DataComparisonView" owner:self options:nil] lastObject];
    _dataComparisonView.frame = CGRectMake(0, 100+300+20, k_MainBoundsWidth, 300+100);
    [self.myScrollView addSubview:_dataComparisonView];
//    NSArray *xLineDataArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
//    NSArray *valueArr = @[@[@"5",@"-22",@"17",@(-4),@25,@5,@6,@9,@"0",@"-22",@"17",@(-4)]];
//    [_dataComparisonView reInit:xLineDataArr Value:valueArr];
    
    NSMutableArray *xLineDataArry = [NSMutableArray array];
    NSMutableArray *valueArry1 = [NSMutableArray array];
    NSMutableArray *valueArry2 = [NSMutableArray array];
    
    
    if (_electricUserYearTrend.pointTrendYear.data.count>0) {
        for (int i =0; i<_electricUserYearTrend.pointTrendYear.data.count; i++) {
            [xLineDataArry addObject:@(i+1)];
            [valueArry1 addObject:_electricUserYearTrend.pointTrendYear.data[i].an];
        }
        for (int i =0; i<_electricUserYearTrend.pointTrendYear.data.count; i++) {
            [valueArry2 addObject:_electricUserYearTrend.pointTrendYear.data[i].mom];
        }

        
    }else{
        for (int i =0; i<11; i++) {
            [xLineDataArry addObject:@(i+1)];
        }
    }

    
    NSArray *valueArr = @[valueArry1,valueArry2];
    [_dataComparisonView reInit:xLineDataArry Value:valueArr];
    
    _dataComparisonView.lineChart.showMomLabel = YES;
    _dataComparisonView.lineChart.unit = @"单位:月";
    if (_electricUserYearTrend.pointTrendYear.data.count > 0) {
        _dataComparisonView.lineChart.noDataStr = @"";
    }else{
        _dataComparisonView.lineChart.noDataStr = @"暂无数据";
    }
    _dataComparisonView.lineChart.delegate = self;
    [self jhLineChartDelegate:_electricUserYearTrend.pointTrendYear.data.count -1];
    [_dataComparisonView showAnimation];
    
    _electricityAdviceView = [[[NSBundle mainBundle] loadNibNamed:@"ElectricityAdviceView" owner:self options:nil] lastObject];
    _electricityAdviceView.frame = CGRectMake(0, 100+300+20, k_MainBoundsWidth, 300);
    _electricityAdviceView.elecAdvice.text = _electricUserYearTrend.year.proposal;

    NSDictionary *par = _settingViewController.parameters;
    _chartView.animationDuration = roundf([par[kLineChartAnimationDuration] floatValue]);
    _chartView.animationStyle = [par[kLineChartAnimationStyle] unsignedIntegerValue];
    _chartView.backgroundColor = par[kLineChartBackgroundColor];
    _chartView.drawGradient = [par[kLineChartDrawGradient] boolValue];
    _chartView.scrollable = [par[kLineChartScrollable] boolValue];
    _chartView.pinchable = [par[kLineChartPinchable] boolValue];
    _chartView.junctionStyle = [par[kLineChartJunctionStyle] boolValue];
    [_chartView updateGraph];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {

}

- (void)handleSettingButton {
    
    [self.navigationController pushViewController:_settingViewController animated:true];
}

- (void)handleGesture {
    
    //    NSLog(@"touch !");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - WYLineChartViewDelegate

- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    
    return _electricUserYearTrend.pointTrendYear.data.count+1;
}

- (CGFloat)gapBetweenPointsHorizontalInLineChartView:(WYLineChartView *)chartView {
    
    return 75.f;
}

- (CGFloat)maxValueForPointsInLineChartView:(WYLineChartView *)chartView {
    CGFloat maxPiontY = 0;
    CGFloat maxValue = 0;
    for (WYLineChartPoint *point in _chartView.points) {
        if (maxPiontY<point.value) {
            maxPiontY = point.value;
        }
    }
   
    if (maxPiontY<=300) {
        maxValue = 300;
    }else if(maxPiontY<=600){
        maxValue = 600;
    }else if (maxPiontY <=900){
        maxValue = 900;
    }else if (maxPiontY<=1200){
        maxValue = 1200;
    }else{
        maxValue = maxPiontY;
    }

    return maxPiontY;
}

- (CGFloat)minValueForPointsInLineChartView:(WYLineChartView *)chartView {
    
    return 0;//321.2;
}

- (NSInteger)numberOfReferenceLineVerticalInLineChartView:(WYLineChartView *)chartView {
    return _electricUserYearTrend.pointTrendYear.data.count+2;
}

- (NSInteger)numberOfReferenceLineHorizontalInLineChartView:(WYLineChartView *)chartView {
    return 3;
}

- (void)lineChartView:(WYLineChartView *)lineView didBeganTouchAtSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //    NSLog(@"began move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didMovedTouchToSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //    NSLog(@"changed move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didEndedTouchToSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //    NSLog(@"ended move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didBeganPinchWithScale:(CGFloat)scale {
    
    //    NSLog(@"begin pinch, scale : %f", scale);
}

- (void)lineChartView:(WYLineChartView *)lineView didChangedPinchWithScale:(CGFloat)scale {
    
    //    NSLog(@"change pinch, scale : %f", scale);
}

- (void)lineChartView:(WYLineChartView *)lineView didEndedPinchGraphWithOption:(WYLineChartViewScaleOption)option scale:(CGFloat)scale {
    
    //    NSLog(@"end pinch, scale : %f", scale);
}

#pragma mark - WYLineChartViewDatasource

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForXAxisLabelAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"";
    }else if (index == chartView.points.count-1){
        return @"";
    }
    return [NSString stringWithFormat:@"%ld",chartView.points[index].index];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToXAxisLabelAtIndex:(NSInteger)index {
    return _points[index];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToVerticalReferenceLineAtIndex:(NSInteger)index {
    
    return _points[index];
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToHorizontalReferenceLineAtIndex:(NSInteger)index {
    CGFloat value;
    switch (index) {
        case 0:
            value = 90980.f;
            break;
        case 1:
            value = 50500.f;
            break;
        case 2:
            value = 0;
            break;
        default:
            value = 0;
            break;
    }
    return value;
}
-(NSInteger)numberOfLabelOnYAxisInLineChartView:(WYLineChartView *)chartView{
    return 3;
}

- (void)jhLineChartDelegate:(NSInteger)integer{
    if (_electricUserYearTrend.pointTrendYear.data.count == 0) {
        _dataComparisonView.anLabel.text = @"暂无数据";
        _dataComparisonView.momLabel.text = @"暂无数据";
        _dataComparisonView.anData.text = @"暂无数据";
        _dataComparisonView.monData.text = @"暂无数据";
        return;
    }
    NSInteger i = integer;
    
    _dataComparisonView.anLabel.text = _electricUserYearTrend.pointTrendYear.data[i].anDate;
    _dataComparisonView.momLabel.text = _electricUserYearTrend.pointTrendYear.data[i].momDate;
    NSString * anStr = _electricUserYearTrend.pointTrendYear.data[i].an;
    NSString * monStr = _electricUserYearTrend.pointTrendYear.data[i].mom;
    
    if ( [anStr isEqualToString:@"--"]) {
        _dataComparisonView.anData.text = anStr;
        [_dataComparisonView.anData setTextColor:RGBCOLOR(96, 96, 96)];
    }else if ([anStr isEqualToString:@"0"]){
        _dataComparisonView.anData.text = [NSString stringWithFormat:@"%.2f%%",anStr.floatValue];
        [_dataComparisonView.anData setTextColor:RGBCOLOR(156, 156, 156)];
    }else{
        if ([anStr floatValue]>0){
            _dataComparisonView.anData.text = [NSString stringWithFormat:@"+%.2f%%",anStr.floatValue];
            [_dataComparisonView.anData setTextColor:RGBCOLOR(255, 59, 20)];
            
        }else{
            _dataComparisonView.anData.text = [NSString stringWithFormat:@"%.2f%%",anStr.floatValue];
            [_dataComparisonView.anData setTextColor:RGBCOLOR(11, 208, 52)];
            
        }
    }
    
    if ( [monStr isEqualToString:@"--"]) {
        _dataComparisonView.monData.text = monStr;
        [_dataComparisonView.monData setTextColor:RGBCOLOR(96, 96, 96)];
    }else if ([monStr isEqualToString:@"0"]){
        _dataComparisonView.monData.text = [NSString stringWithFormat:@"%.2f%%",monStr.floatValue];
        [_dataComparisonView.monData setTextColor:RGBCOLOR(156, 156, 156)];
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
@end
