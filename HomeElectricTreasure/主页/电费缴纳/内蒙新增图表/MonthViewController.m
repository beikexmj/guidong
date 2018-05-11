//
//  MonthViewController.m
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/3.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "MonthViewController.h"
#import "JHColumnChart.h"
#import "TrendHeaderView.h"
#import "PricingMethodView.h"
#import "DataComparisonView.h"
#import "ElectricityAdviceView.h"

#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface MonthViewController ()<JHColumnChartDelegate,JHLineChartDelegate>
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)PricingMethodView *priceMethodView;
@property (nonatomic,strong)DataComparisonView *dataComparisonView;
@property (nonatomic,strong)ElectricityAdviceView *electricityAdviceView;
@end

@implementation MonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, k_MainBoundsHeight-64)];
    if(kDevice_Is_iPhoneX){
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, k_MainBoundsHeight-64-56)];

    }
    _myScrollView.contentSize = CGSizeMake(k_MainBoundsWidth, 100+320+20+30+20+300+100);
    [self.view addSubview:_myScrollView];
    
    TrendHeaderView *trendHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"TrendHeaderView" owner:self options:nil] lastObject];
    trendHeaderView.frame = CGRectMake(0, 0, k_MainBoundsWidth, 100);
    trendHeaderView.eleNum.text = _electricUserMonthTrend.pointTrendMonth.totalElecSum;//@"373.0";
    trendHeaderView.eleFee.text = _electricUserMonthTrend.pointTrendMonth.totalElecPrice;//@"456.00";
    trendHeaderView.date.text = [_electricUserMonthTrend.pointTrendMonth.currentDate stringByReplacingOccurrencesOfString:@"|" withString:@"/"];//@"2017/06";
    [_myScrollView addSubview:trendHeaderView];
    
    
    
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, 320)];
    /*        Create an array of data sources, each array is a module data. For example, the first array can represent the average score of a class of different subjects, the next array represents the average score of different subjects in another class        */
    NSMutableArray *DataArry = [NSMutableArray array];
    NSMutableArray *DateArry = [NSMutableArray array];

    for (RealData *data in _electricUserMonthTrend.pointTrendMonth.realData) {
        [DateArry addObject:data.day];
        [DataArry addObject:@[data.data]];
    }
    for (PredictionData *data in _electricUserMonthTrend.pointTrendMonth.predictionData) {
        [DateArry addObject:data.day];
        [DataArry addObject:@[data.data]];

    }
    column.valueArr = DataArry;
    column.xShowInfoText = DateArry;
    column.realDataDate = _electricUserMonthTrend.pointTrendMonth.realData.count;
    
    /*       This point represents the distance from the lower left corner of the origin.         */
    column.originSize = CGPointMake(20, 40);
    /*    The first column of the distance from the starting point     */
    column.drawFromOriginX = 0;
    column.typeSpace = 30;
    column.isShowYLine = NO;
    column.needXandYLine = NO;
    /*        Column width         */
    column.columnWidth = 15;
    /*        Column backgroundColor         */
    column.bgVewBackgoundColor = [UIColor whiteColor];
    /*        X, Y axis font color         */
    column.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    column.colorForXYLine = [UIColor darkGrayColor];
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    column.columnBGcolorsArr = @[[UIColor colorWithRed:72/256.0 green:200.0/256 blue:255.0/256 alpha:1],[UIColor greenColor],[UIColor orangeColor]];
    /*        Module prompt         */
    column.isShowLineChart = NO;
    
    column.delegate = self;
    /*       Start animation        */
    [column showAnimation];
    [_myScrollView addSubview:column];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"计价方式",@"数据对比",@"用电建议",nil];
//    UISegmentedControl *mySeg = [[UISegmentedControl alloc]initWithFrame:CGRectMake((k_MainBoundsWidth-150)/2.0, 100+320+20, 150, 30)];
    UISegmentedControl *mySeg = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    mySeg.frame = CGRectMake((k_MainBoundsWidth-250)/2.0, 100+320+20, 250, 30);
    mySeg.selectedSegmentIndex = 0;
    
    mySeg.tintColor = [UIColor colorWithRed:0/255.0 green:167/255.0 blue:255/255.0 alpha:1];
    [mySeg addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    [_myScrollView addSubview:mySeg];
    
    _priceMethodView = [[[NSBundle mainBundle] loadNibNamed:@"PricingMethodView" owner:self options:nil] lastObject];
    _priceMethodView.frame = CGRectMake(0, 100+320+20+30+20, k_MainBoundsWidth, 300+30);
    [self priceMethodViewDataWithSuface];
    [_myScrollView addSubview:_priceMethodView];
    
    _dataComparisonView = [[[NSBundle mainBundle] loadNibNamed:@"DataComparisonView" owner:self options:nil] lastObject];
    _dataComparisonView.frame = CGRectMake(0, 100+320+20+30+20, k_MainBoundsWidth, 300+100);
    
    NSMutableArray *xLineDataArry = [NSMutableArray array];
    NSMutableArray *valueArry1 = [NSMutableArray array];
    NSMutableArray *valueArry2 = [NSMutableArray array];

    if (_electricUserMonthTrend.month.an.count>0) {
        for (int i =0; i<_electricUserMonthTrend.month.an.count; i++) {
            [xLineDataArry addObject:@(i+1)];
            [valueArry1 addObject:_electricUserMonthTrend.month.an[i].data];
        }
        for (int i =0; i<_electricUserMonthTrend.month.mon.count; i++) {
            [valueArry2 addObject:_electricUserMonthTrend.month.mon[i].data];
        }

    }else{
        for (int i =0; i<11; i++) {
            [xLineDataArry addObject:@(i+1)];
        }
    }
    NSArray *valueArr = @[valueArry1,valueArry2];

    [_dataComparisonView reInit:xLineDataArry Value:valueArr];
    _dataComparisonView.lineChart.showMomLabel = YES;
    _dataComparisonView.lineChart.unit = @"单位:日";
    if (_electricUserMonthTrend.month.an.count>0) {
        _dataComparisonView.lineChart.noDataStr = @"";

    }else{
        _dataComparisonView.lineChart.noDataStr = @"暂无数据";

    }
//    _dataComparisonView.anLabel.text = @"2016/06/08";
//    _dataComparisonView.momLabel.text = @"2017/06/01";
    _dataComparisonView.lineChart.delegate = self;
    [self jhLineChartDelegate:_electricUserMonthTrend.month.an.count -1];
    _electricityAdviceView = [[[NSBundle mainBundle] loadNibNamed:@"ElectricityAdviceView" owner:self options:nil] lastObject];
    _electricityAdviceView.elecAdvice.text = _electricUserMonthTrend.month.proposal;
    _electricityAdviceView.frame = CGRectMake(0, 100+320+20+30+20, k_MainBoundsWidth, 300);
    
   
    
    // Do any additional setup after loading the view from its nib.
}
-(void)columnItem:(UIView *)item didClickAtIndexRow:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)priceMethodViewDataWithSuface{
    _priceMethodView.sharpTime.text =[NSString stringWithFormat:@"%@",_electricUserMonthTrend.elecPrice.type[0].name];
    _priceMethodView.sharpTimeSection.text = _electricUserMonthTrend.elecPrice.type[0].value;
    _priceMethodView.sharpTimeRate.text = _electricUserMonthTrend.elecPrice.type[0].price;
    _priceMethodView.sharpTimeMark.hidden = !_electricUserMonthTrend.elecPrice.type[0].current;
    
    _priceMethodView.peakTime.text = [NSString stringWithFormat:@"%@",_electricUserMonthTrend.elecPrice.type[1].name];
    _priceMethodView.peakTimeSection.text = _electricUserMonthTrend.elecPrice.type[1].value;
//    [_priceMethodView.peakTimeSectionTextFlow setText:_electricUserMonthTrend.elecPrice.type[1].value];
    _priceMethodView.peakTimeRate.text = _electricUserMonthTrend.elecPrice.type[1].price;
    _priceMethodView.peakTimeMark.hidden = !_electricUserMonthTrend.elecPrice.type[1].current;
    
    _priceMethodView.peaceTime.text = [NSString stringWithFormat:@"%@",_electricUserMonthTrend.elecPrice.type[2].name];
    _priceMethodView.peaceTimeSection.text = _electricUserMonthTrend.elecPrice.type[2].value;
    _priceMethodView.peaceTimeRate.text = _electricUserMonthTrend.elecPrice.type[2].price;
    _priceMethodView.peaceTimeMark.hidden = !_electricUserMonthTrend.elecPrice.type[2].current;
    
    _priceMethodView.valleyTime.text = [NSString stringWithFormat:@"%@",_electricUserMonthTrend.elecPrice.type[3].name];
    _priceMethodView.valleyTimeSection.text = _electricUserMonthTrend.elecPrice.type[3].value;
    _priceMethodView.valleyTimeRate.text = _electricUserMonthTrend.elecPrice.type[3].price;
    _priceMethodView.valleyTimeMark.hidden = !_electricUserMonthTrend.elecPrice.type[3].current;
    
    _priceMethodView.firstStep.text = _electricUserMonthTrend.elecPrice.ladder[0].name;
    _priceMethodView.firstStepSection.text = _electricUserMonthTrend.elecPrice.ladder[0].value;
    _priceMethodView.firstStepElectricityPriceStandard.text = _electricUserMonthTrend.elecPrice.ladder[0].price;
    _priceMethodView.firstStepMark.hidden = !_electricUserMonthTrend.elecPrice.ladder[0].current;
    
    _priceMethodView.secondStep.text = _electricUserMonthTrend.elecPrice.ladder[1].name;
    _priceMethodView.secondStepSection.text = _electricUserMonthTrend.elecPrice.ladder[1].value;
    _priceMethodView.secondStepElectricityPriceStandard.text = _electricUserMonthTrend.elecPrice.ladder[1].price;
    _priceMethodView.secondStepMark.hidden = !_electricUserMonthTrend.elecPrice.ladder[1].current;
    
    _priceMethodView.thirdStep.text = _electricUserMonthTrend.elecPrice.ladder[2].name;
    _priceMethodView.thirdStepSection.text = _electricUserMonthTrend.elecPrice.ladder[2].value;
    _priceMethodView.thirdStepElectricityPriceStandard.text = _electricUserMonthTrend.elecPrice.ladder[2].price;
    _priceMethodView.thirdStepMark.hidden = !_electricUserMonthTrend.elecPrice.ladder[2].current;
    
    if (_priceMethodView.sharpTimeMark.hidden) {
        [_priceMethodView.sharpTime setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.sharpTime.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.sharpTimeSection setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.sharpTimeSection.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.sharpTimeRate setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.sharpTimeRate.backgroundColor = [UIColor whiteColor];
    }else{
        [_priceMethodView.sharpTime setTextColor:[UIColor whiteColor]];
        _priceMethodView.sharpTime.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.sharpTimeSection setTextColor:[UIColor whiteColor]];
        _priceMethodView.sharpTimeSection.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.sharpTimeRate setTextColor:[UIColor whiteColor]];
        _priceMethodView.sharpTimeRate.backgroundColor = RGBCOLOR(110, 122, 134);
    }
    
    if (_priceMethodView.peakTimeMark.hidden) {
        [_priceMethodView.peakTime setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.peakTime.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.peakTimeSection setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.peakTimeSection.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.peakTimeRate setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.peakTimeRate.backgroundColor = [UIColor whiteColor];
    }else{
        [_priceMethodView.peakTime setTextColor:[UIColor whiteColor]];
        _priceMethodView.peakTime.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.peakTimeSection setTextColor:[UIColor whiteColor]];
        _priceMethodView.peakTimeSection.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.peakTimeRate setTextColor:[UIColor whiteColor]];
        _priceMethodView.peakTimeRate.backgroundColor = RGBCOLOR(110, 122, 134);
    }
    if (_priceMethodView.peaceTimeMark.hidden) {
        [_priceMethodView.peaceTime setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.peaceTime.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.peaceTimeSection setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.peaceTimeSection.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.peaceTimeRate setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.peaceTimeRate.backgroundColor = [UIColor whiteColor];
    }else{
        [_priceMethodView.peaceTime setTextColor:[UIColor whiteColor]];
        _priceMethodView.peaceTime.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.peaceTimeSection setTextColor:[UIColor whiteColor]];
        _priceMethodView.peaceTimeSection.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.peaceTimeRate setTextColor:[UIColor whiteColor]];
        _priceMethodView.peaceTimeRate.backgroundColor = RGBCOLOR(110, 122, 134);
    }

    if (_priceMethodView.valleyTimeMark.hidden) {
        [_priceMethodView.valleyTime setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.valleyTime.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.valleyTimeSection setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.valleyTimeSection.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.valleyTimeRate setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.valleyTimeRate.backgroundColor = [UIColor whiteColor];
    }else{
        [_priceMethodView.valleyTime setTextColor:[UIColor whiteColor]];
        _priceMethodView.valleyTime.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.valleyTimeSection setTextColor:[UIColor whiteColor]];
        _priceMethodView.valleyTimeSection.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.valleyTimeRate setTextColor:[UIColor whiteColor]];
        _priceMethodView.valleyTimeRate.backgroundColor = RGBCOLOR(110, 122, 134);
    }
    
    if (_priceMethodView.firstStepMark.hidden) {
        [_priceMethodView.firstStep setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.firstStep.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.firstStepSection setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.firstStepSection.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.firstStepElectricityPriceStandard setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.firstStepElectricityPriceStandard.backgroundColor = [UIColor whiteColor];
    }else{
        [_priceMethodView.firstStep setTextColor:[UIColor whiteColor]];
        _priceMethodView.firstStep.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.firstStepSection setTextColor:[UIColor whiteColor]];
        _priceMethodView.firstStepSection.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.firstStepElectricityPriceStandard setTextColor:[UIColor whiteColor]];
        _priceMethodView.firstStepElectricityPriceStandard.backgroundColor = RGBCOLOR(110, 122, 134);
    }
    
    if (_priceMethodView.secondStepMark.hidden) {
        [_priceMethodView.secondStep setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.secondStep.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.secondStepSection setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.secondStepSection.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.secondStepElectricityPriceStandard setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.secondStepElectricityPriceStandard.backgroundColor = [UIColor whiteColor];
    }else{
        [_priceMethodView.secondStep setTextColor:[UIColor whiteColor]];
        _priceMethodView.secondStep.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.secondStepSection setTextColor:[UIColor whiteColor]];
        _priceMethodView.secondStepSection.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.secondStepElectricityPriceStandard setTextColor:[UIColor whiteColor]];
        _priceMethodView.secondStepElectricityPriceStandard.backgroundColor = RGBCOLOR(110, 122, 134);
    }

    if (_priceMethodView.thirdStepMark.hidden) {
        [_priceMethodView.thirdStep setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.thirdStep.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.thirdStepSection setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.thirdStepSection.backgroundColor = [UIColor whiteColor];
        [_priceMethodView.thirdStepElectricityPriceStandard setTextColor:RGBCOLOR(96, 96, 96)];
        _priceMethodView.thirdStepElectricityPriceStandard.backgroundColor = [UIColor whiteColor];
    }else{
        [_priceMethodView.thirdStep setTextColor:[UIColor whiteColor]];
        _priceMethodView.thirdStep.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.thirdStepSection setTextColor:[UIColor whiteColor]];
        _priceMethodView.thirdStepSection.backgroundColor = RGBCOLOR(110, 122, 134);
        [_priceMethodView.thirdStepElectricityPriceStandard setTextColor:[UIColor whiteColor]];
        _priceMethodView.thirdStepElectricityPriceStandard.backgroundColor = RGBCOLOR(110, 122, 134);
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
- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %ld", Index);
    [_electricityAdviceView removeFromSuperview];
    [_dataComparisonView removeFromSuperview];
    [_priceMethodView removeFromSuperview];
    switch (Index) {
        case 0:
            [_myScrollView addSubview:_priceMethodView];
            break;
        case 1:
            [_myScrollView addSubview:_dataComparisonView];
            [_dataComparisonView showAnimation];
            break;
        case 2:
            [_myScrollView addSubview:_electricityAdviceView];
            break;
            default:
            break;
    }
}

- (void)jhLineChartDelegate:(NSInteger)integer{
    
    if (_electricUserMonthTrend.month.an.count == 0) {
        _dataComparisonView.anLabel.text = @"暂无数据";
        _dataComparisonView.momLabel.text = @"暂无数据";
        _dataComparisonView.anData.text = @"暂无数据";
        _dataComparisonView.monData.text = @"暂无数据";
        return;
    }
    
    NSInteger i = integer;
    
    _dataComparisonView.anLabel.text = _electricUserMonthTrend.month.an[i].date;
    _dataComparisonView.momLabel.text = _electricUserMonthTrend.month.mon[i].date;
    NSString * anStr = _electricUserMonthTrend.month.an[i].data;
    NSString * monStr = _electricUserMonthTrend.month.mon[i].data;
    
    if ( [anStr isEqualToString:@"--"]) {
        _dataComparisonView.anData.text = anStr;
        [_dataComparisonView.anData setTextColor:RGBCOLOR(156, 156, 156)];
    }else if ([anStr isEqualToString:@"0.00"]){
        _dataComparisonView.anData.text = [NSString stringWithFormat:@"%@%%",_electricUserMonthTrend.month.an[i].data];
        [_dataComparisonView.anData setTextColor:RGBCOLOR(156, 156, 156)];
    }else{
        if ([_electricUserMonthTrend.month.an[i].data floatValue]>0){
            _dataComparisonView.anData.text = [NSString stringWithFormat:@"+%@%%",_electricUserMonthTrend.month.an[i].data];
            [_dataComparisonView.anData setTextColor:RGBCOLOR(255, 59, 20)];
            
        }else{
            _dataComparisonView.anData.text = [NSString stringWithFormat:@"%@%%",_electricUserMonthTrend.month.an[i].data];
            [_dataComparisonView.anData setTextColor:RGBCOLOR(11, 208, 52)];
            
        }
    }
    
    if ( [monStr isEqualToString:@"--"]) {
        _dataComparisonView.monData.text = monStr;
        [_dataComparisonView.monData setTextColor:RGBCOLOR(156, 156, 156)];
    }else if ([monStr isEqualToString:@"0.00"]){
        _dataComparisonView.monData.text = [NSString stringWithFormat:@"%@%%",_electricUserMonthTrend.month.mon[i].data];
        [_dataComparisonView.monData setTextColor:RGBCOLOR(156, 156, 156)];

    }else{
        if ([_electricUserMonthTrend.month.mon[i].data floatValue]>0){
            _dataComparisonView.monData.text = [NSString stringWithFormat:@"+%@%%",_electricUserMonthTrend.month.mon[i].data];
            [_dataComparisonView.monData setTextColor:RGBCOLOR(255, 59, 20)];
            
        }else{
            _dataComparisonView.monData.text = [NSString stringWithFormat:@"%@%%",_electricUserMonthTrend.month.mon[i].data];
            [_dataComparisonView.monData setTextColor:RGBCOLOR(11, 208, 52)];
            
        }
    }
    
    
}


- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
