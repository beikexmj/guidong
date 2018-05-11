//
//  ElectricityFeeDisplayBackView.m
//  copooo
//
//  Created by 夏明江 on 16/9/7.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityFeeDisplayBackView.h"
#import "ElectricityFeeDisplay.h"
@implementation ElectricityFeeDisplayBackView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.frame = CGRectMake(0, 64,  SCREEN_WIDTH, SCREEN_HEIGHT -64);
}

-(void)awakeFromNib{
    [super awakeFromNib];

    self.mySegment.selectedSegmentIndex = 1;
     _LCView = [CFLineChartView lineChartViewWithFrame:CGRectMake(0, 60+120, SCREEN_WIDTH, SCREEN_HEIGHT-64-180-20)];
  //  [self drawElectricityView];
}
- (IBAction)mySegment:(id)sender {
    UISegmentedControl * seg = sender;
    if (seg.selectedSegmentIndex == 0) {
        [self doWithCreateYearUI];
    }else{
        [self doWithSetMonthUI];
    }
}

-(void)addData:(Detail *)eleFeePaymentDict {
    _eleFeePaymentDict = eleFeePaymentDict;
    if ([_eleFeePaymentDict.index.cardType integerValue] == 9) {
        self.mySegment.selectedSegmentIndex = 0;
        _mySegment.hidden = YES;
        [self doWithCreateYearUI];
    }else{
        self.mySegment.selectedSegmentIndex = 1;
        _mySegment.hidden = NO;
        [self doWithSetMonthUI];
    }
}

- (void)doWithCreateYearUI{
    _myElectricityFee.text = _eleFeePaymentDict.index.totalYearElec;

    NSMutableArray *DayArry = [NSMutableArray array];
    for (MonthList *list in _eleFeePaymentDict.year.list) {
        [DayArry addObject:[NSNumber numberWithInteger:list.month]];
    }
    _LCView.xValues = DayArry;
    NSMutableArray *dayValueArray = [NSMutableArray array];
    for (MonthList *list in _eleFeePaymentDict.year.list) {
        [dayValueArray addObject:list.elecNumber];
    }
    _LCView.yValues = dayValueArray;
//    _LCView.monthOrYear = [NSString stringWithFormat:@"%@年",_eleFeePaymentDict.index.currentYear];
    _yearOrMonthElectNum.text = [NSString stringWithFormat:@"%@年用电量(度)",_eleFeePaymentDict.index.currentYear];
    _LCView.unit = @"单位：月";
    [self.LCView removeFromSuperview];
    [self addSubview:self.LCView];
    
    [self setupConditions];
}

- (void)doWithSetMonthUI{
    _myElectricityFee.text = _eleFeePaymentDict.index.currentElec;

    self.mySegment.selectedSegmentIndex = 1;
    NSMutableArray *DayArry = [NSMutableArray array];
    for (DayList *list in _eleFeePaymentDict.month.list) {
        [DayArry addObject:[NSNumber numberWithInteger:list.day]];
    }
    _LCView.xValues = DayArry;
    NSMutableArray *dayValueArray = [NSMutableArray array];
    for (DayList *list in _eleFeePaymentDict.month.list) {
        [dayValueArray addObject:list.elecNumber];
    }
    _LCView.yValues = dayValueArray;
//    _LCView.monthOrYear = [NSString stringWithFormat:@"%@月",_eleFeePaymentDict.index.currentMonth];
    _yearOrMonthElectNum.text = [NSString stringWithFormat:@"%@月用电量(度)",_eleFeePaymentDict.index.currentMonth];
    _LCView.unit = @"单位：日";
    [self.LCView removeFromSuperview];
    [self addSubview:self.LCView];
    
    [self setupConditions];
}
// 设置条件
- (void)setupConditions{
    self.LCView.isShowLine = YES;
    self.LCView.isShowPoint = NO;
    self.LCView.isShowPillar = NO;
    self.LCView.isShowValue = YES;
    
    [self.LCView drawChartWithLineChartType:0 pointType:0];
}
@end
