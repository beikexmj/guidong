//
//  DataComparisonView.m
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "DataComparisonView.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface DataComparisonView (){
    UILabel *anLabel;
    UILabel *momLabel;
    UIView *anView;
    UIView *momView2;
}
@property (nonatomic,strong)UIScrollView * myScrollView;
@end

@implementation DataComparisonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, 260)];
    _myScrollView.contentSize = CGSizeMake(k_MainBoundsWidth*2, 260);
    _myScrollView.showsHorizontalScrollIndicator = NO;
    [self.chartView addSubview:_myScrollView];
    
    anView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 6)];
    anView.backgroundColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0 alpha:1];
    [self.chartView addSubview:anView];
    
    momView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 6)];
    momView2.backgroundColor = [UIColor colorWithRed:0 green:167/255.0 blue:255/255.0 alpha:1];
    [self.chartView addSubview:momView2];
    
    anLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    anLabel.textColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    anLabel.font = [UIFont systemFontOfSize:10];
    anLabel.text = @"同比";
    [self.chartView addSubview:anLabel];
    
    momLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    momLabel.textColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    momLabel.font = [UIFont systemFontOfSize:10];
    momLabel.text = @"环比";
    [self.chartView addSubview:momLabel];
    
    CGPoint p = CGPointMake(k_MainBoundsWidth, 10);
    momLabel.center = CGPointMake(p.x-20, p.y);
    momView2.center = CGPointMake(p.x -20 -35, p.y);
    anLabel.center = CGPointMake(p.x-20-35-30, p.y);
    anView.center = CGPointMake(p.x-20-35-30-35, p.y);
    
    /*       Start animation        */
    

    
}
-(void)reInit:(NSArray*)xLineDataArr Value:(NSArray*)valueArr{
    CGFloat width = 0;
    if (xLineDataArr.count<12) {
        width = k_MainBoundsWidth;
    }else{
        width  = 40*xLineDataArr.count +35;
    }
     _myScrollView.contentSize = CGSizeMake(width, 260);
    /*     Create object        */
    _lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 0, width, 260) andLineChartType:JHChartLineValueNotForEveryX];
    
    /* The scale value of the X axis can be passed into the NSString or NSNumber type and the data structure changes with the change of the line chart type. The details look at the document or other quadrant X axis data source sample.*/
    
    _lineChart.xLineDataArr = xLineDataArr;
    _lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    /* The different types of the broken line chart, according to the quadrant division, different quadrant correspond to different X axis scale data source and different value data source. */
    
    _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    
    _lineChart.valueArr = valueArr;
    _lineChart.showYLevelLine = YES;
    _lineChart.showYLine = NO;
    _lineChart.showValueLeadingLine = NO;
    _lineChart.valueFontSize = 9.0;
    _lineChart.backgroundColor = [UIColor whiteColor];
    _lineChart.showPointDescription = NO;
    _lineChart.showXDescVertical = NO;
    _lineChart.xDescMaxWidth = 15;
    /* Line Chart colors */
    _lineChart.valueLineColorArr =@[ [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0 alpha:1], [UIColor colorWithRed:0 green:167/255.0 blue:255/255.0 alpha:1]];
    /* Colors for every line chart*/
    _lineChart.pointColorArr = @[ [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0 alpha:1], [UIColor colorWithRed:0 green:167/255.0 blue:255/255.0 alpha:1]];
    /* color for XY axis */
    _lineChart.xAndYLineColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
    /* XY axis scale color */
    _lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    _lineChart.positionLineColorArr = @[ [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0 alpha:1], [UIColor colorWithRed:0 green:167/255.0 blue:255/255.0 alpha:1]];
    /*        Set whether to fill the content, the default is False         */
    _lineChart.contentFill = NO;
    /*        Set whether the curve path         */
    _lineChart.pathCurve = NO;
    /*        Set fill color array         */
    _lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [_myScrollView addSubview:_lineChart];

    
    

}
-(void)showAnimation{
//    if (!_lineChart.showMomLabel) {
//        anView.frame = momView2.frame;
//        anLabel.frame = momLabel.frame;
//        momView2.hidden = YES;
//        momLabel.hidden = YES;
//        _height.constant = 60;
//        self.momView.hidden = YES;
//    }else{
//        
//    }
    [_lineChart showAnimation];
}
- (void)hiddenAnViewAnMonView{
    anView.hidden = YES;
    momView2.hidden = YES;
    anLabel.hidden = YES;
    momLabel.hidden = YES;
}
@end
