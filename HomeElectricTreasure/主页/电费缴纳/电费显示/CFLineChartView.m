//
//  CFLineChartView.m
//  CFLineChartDemo
//
//  Created by TheMoon on 16/3/24.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFLineChartView.h"

static CGRect myFrame;
static int count;   // 点个数，x轴格子数
static int yCount;  // y轴格子数
static CGFloat everyX;  // x轴每个格子宽度
static CGFloat everyY;  // y轴每个格子高度
static CGFloat maxY;    // 最大的y值
static CGFloat minY;    // 最小的y值
static CGFloat allH;    // 整个图表高度
static CGFloat allW;    // 整个图表宽度
#define XMargin 20
#define YMargin 70
#define MinNumber 15
@interface CFLineChartView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end



@implementation CFLineChartView

+ (instancetype)lineChartViewWithFrame:(CGRect)frame{
    CFLineChartView *lineChartView = [[NSBundle mainBundle] loadNibNamed:@"CFLineChartView" owner:self options:nil].lastObject;
    lineChartView.frame = frame;
    
    myFrame = frame;
    
    return lineChartView;
}


#pragma mark - 计算

- (void)doWithCalculate{
    if (!self.xValues || !self.xValues.count || !self.yValues || !self.yValues.count) {
        return;
    }
    // 移除多余的值，计算点个数
    if (self.xValues.count > self.yValues.count) {
        NSMutableArray * xArr = [self.xValues mutableCopy];
        for (int i = 0; i < self.xValues.count - self.yValues.count; i++){
            [xArr removeLastObject];
        }
        self.xValues = [xArr mutableCopy];
    }else if (self.xValues.count < self.yValues.count){
        NSMutableArray * yArr = [self.yValues mutableCopy];
        for (int i = 0; i < self.yValues.count - self.xValues.count; i++){
            [yArr removeLastObject];
        }
        self.yValues = [yArr mutableCopy];
    }
    
    count = (int)self.xValues.count;
    if (count==1) {
        everyX = (CGFloat)(CGRectGetWidth(myFrame) - XMargin * 2);
    }else{
        everyX = (CGFloat)(CGRectGetWidth(myFrame) - XMargin * 2) / (count-1);

    }
    
    // y轴最多分5部分
    yCount = count <= 5 ? count : 5;
    
    everyY =  (CGRectGetHeight(myFrame) - YMargin * 2) / (yCount-1);
    
    maxY = CGFLOAT_MIN;
    for (int i = 0; i < count; i ++) {
        if ([self.yValues[i] floatValue] > maxY) {
            maxY = [self.yValues[i] floatValue];
        }
    }
    minY = CGFLOAT_MAX;
    for (int i = 0; i < count; i ++) {
        if ([self.yValues[i] floatValue] < minY) {
            minY = [self.yValues[i] floatValue];
        }
    }
    allH = CGRectGetHeight(myFrame) - YMargin * 2;
    allW = CGRectGetWidth(myFrame) - XMargin * 2;
}

#pragma mark - 画X轴
- (void)drawXLine{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(myFrame) - YMargin/2.0-10)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame), CGRectGetHeight(myFrame) - YMargin/2.0-10)];

    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor colorWithRed:130/255.0 green:184/255.0 blue:218/255.0 alpha:1].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;
    [self.bgView.layer addSublayer:layer];
}

#pragma mark - 添加label
- (void)drawLabels{
    
    
    // X轴
    for(int i = 0; i < count; i ++){
        if (count>=MinNumber) {
            if ((i+1)%5 ==0 | i==0) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(XMargin + everyX * i - 30 / 2, CGRectGetHeight(myFrame) - YMargin, 30, YMargin)];
                
                lbl.textColor = [UIColor whiteColor];
                lbl.font = [UIFont systemFontOfSize:12];
                //lbl.backgroundColor = [UIColor brownColor];
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i]];
                
                [self.bgView addSubview:lbl];
            }
        }else{
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(XMargin + everyX * i - everyX / 2, CGRectGetHeight(myFrame) - YMargin, everyX, YMargin)];
            
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont systemFontOfSize:12];
            //lbl.backgroundColor = [UIColor brownColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i]];
            
            [self.bgView addSubview:lbl];
        }
        
    }
    
}
#pragma mark - 画刻度线
- (void)drawTickMark{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i<count; i ++) {
        //最低值横线
        [path moveToPoint:CGPointMake(XMargin + i*everyX, CGRectGetHeight(myFrame) - YMargin/2.0-10)];
        if (count>=MinNumber) {
            if ((i+1)%5 == 0 | i==0) {
                [path addLineToPoint:CGPointMake(XMargin + i*everyX, CGRectGetHeight(myFrame) - YMargin/2.0-20)];
 
            }else{
                [path addLineToPoint:CGPointMake(XMargin + i*everyX, CGRectGetHeight(myFrame) - YMargin/2.0-15)];
            }
        }else{
            
            [path addLineToPoint:CGPointMake(XMargin + i*everyX, CGRectGetHeight(myFrame) - YMargin/2.0-15)];
        }
        
    }
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor colorWithRed:130/255.0 green:184/255.0 blue:218/255.0 alpha:1].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;
    [self.bgView.layer addSublayer:layer];
}

#pragma mark - 画虚线
- (void)drawLines{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *hightPath = [UIBezierPath bezierPath];
    UIBezierPath *lowPath = [UIBezierPath bezierPath];

    //最低值横线
    [lowPath moveToPoint:CGPointMake(0 , YMargin + (1 - minY / maxY ) * allH)];
    [lowPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width , YMargin + (1 - minY / maxY ) * allH)];
    
    //最高值横线
    [hightPath moveToPoint:CGPointMake(0 , YMargin + 0)];
    [hightPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width , YMargin + 0)];
    
    //左边虚线
    [path moveToPoint:CGPointMake(XMargin , YMargin + (1 - [self.yValues[0] floatValue] / maxY ) * allH)];
    [path addLineToPoint:CGPointMake(XMargin , CGRectGetHeight(myFrame) - YMargin/2.0-10)];
    
    //右边虚线
    [path moveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width-XMargin, YMargin + (1 - [self.yValues[count-1] floatValue] / maxY ) * allH)];
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width-XMargin, CGRectGetHeight(myFrame) - YMargin/2.0-10)];
    
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    leftImageView.image = [UIImage imageNamed:@"home_icon_circle"];
    leftImageView.center = CGPointMake(XMargin , YMargin + (1 - [self.yValues[0] floatValue] / maxY ) * allH);

    UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    rightImageView.image = [UIImage imageNamed:@"home_icon_circle"];
    rightImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width-XMargin , YMargin + (1 - [self.yValues[count-1] floatValue] / maxY ) * allH);
    
    
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    //设置虚线的颜色 - 颜色请必须设置
    layer.strokeColor = [UIColor colorWithRed:130/255.0 green:184/255.0 blue:218/255.0 alpha:1].CGColor;
    
    //设置虚线的高度
    [layer setLineWidth:1.0f];
    
    //设置类型
    [layer setLineJoin:kCALineJoinRound];
    
    /*
     1.f=每条虚线的长度
     2.f=每两条线的之间的间距
     */
    [layer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:1.f],
      [NSNumber numberWithInt:2.f],nil]];
    
    
    layer.fillColor = [UIColor clearColor].CGColor;

    
    CAShapeLayer *hightLayer = [[CAShapeLayer alloc] init];
    hightLayer.path = hightPath.CGPath;
    //设置虚线的颜色 - 颜色请必须设置
    hightLayer.strokeColor = [UIColor colorWithRed:15/255.0 green:238/255.0 blue:54/255.0 alpha:1].CGColor;
    
    //设置虚线的高度
    [hightLayer setLineWidth:1.0f];
    
    //设置类型
    [hightLayer setLineJoin:kCALineJoinRound];
    
    /*
     1.f=每条虚线的长度
     2.f=每两条线的之间的间距
     */
    [hightLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:1.f],
      [NSNumber numberWithInt:2.f],nil]];
    
    
    hightLayer.fillColor = [UIColor clearColor].CGColor;
    
    
    CAShapeLayer *lowLayer = [[CAShapeLayer alloc] init];
    lowLayer.path = lowPath.CGPath;
    //设置虚线的颜色 - 颜色请必须设置
    lowLayer.strokeColor = [UIColor colorWithRed:89/255.0 green:255/255.0 blue:249/255.0 alpha:1].CGColor;
    
    //设置虚线的高度
    [lowLayer setLineWidth:1.0f];
    
    //设置类型
    [lowLayer setLineJoin:kCALineJoinRound];
    
    /*
     1.f=每条虚线的长度
     2.f=每两条线的之间的间距
     */
    [lowLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:1.f],
      [NSNumber numberWithInt:2.f],nil]];
    
    
    lowLayer.fillColor = [UIColor clearColor].CGColor;
    
    
    [self.bgView.layer addSublayer:layer];
    [self.bgView.layer addSublayer:hightLayer];
    [self.bgView.layer addSublayer:lowLayer];
    [self.bgView addSubview:leftImageView];
    [self.bgView addSubview:rightImageView];
}


#pragma mark - 画点
- (void)drawPointsWithPointType:(PointType)pointType{
    // 画点
    switch (pointType) {
        case PointType_Rect:
            
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(XMargin + everyX * i , YMargin + (1 - [self.yValues[i] floatValue] / maxY ) * allH);
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                layer.frame = CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5);
                layer.backgroundColor = [UIColor colorWithRed:71/255.0 green:211/255.0 blue:255/255.0 alpha:1].CGColor;
                [self.bgView.layer addSublayer:layer];
            }
            break;
            
        case PointType_Circel:
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(XMargin + everyX * i , YMargin + (1 - [self.yValues[i] floatValue] / maxY ) * allH);
                
                UIBezierPath *path = [UIBezierPath
                                      
                                      //    方法1                          bezierPathWithArcCenter:point radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                                      
                                      //    方法2
                                      bezierPathWithRoundedRect:CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5) cornerRadius:2.5];
                
                
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.path = path.CGPath;
                layer.strokeColor = [UIColor colorWithRed:71/255.0 green:211/255.0 blue:255/255.0 alpha:1].CGColor;
                layer.fillColor = [UIColor colorWithRed:71/255.0 green:211/255.0 blue:255/255.0 alpha:1].CGColor;
                [self.bgView.layer addSublayer:layer];
            }

            break;
    }
}


#pragma mark - 画折线\曲线
- (void)drawFoldLineWithLineChartType:(LineChartType)type{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(XMargin + everyX*0, YMargin + (1 - [self.yValues.firstObject floatValue] / maxY) * allH)];
    switch (type) {
        case LineChartType_Straight:
            for (int i = 1; i < count; i ++) {
                [path addLineToPoint:CGPointMake(XMargin + everyX * (i + 0), YMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH)];
            }
            break;
        case LineChartType_Curve:
            
            for (int i = 1; i < count; i ++) {
        
                CGPoint prePoint = CGPointMake(XMargin + everyX * (i-1), YMargin + (1 - [self.yValues[i-1] floatValue] / maxY) * allH);
                
                CGPoint nowPoint = CGPointMake(XMargin + everyX * i, YMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
                
                // 两个控制点的两个x中点为X值，preY、nowY为Y值；
                
                [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }
            break;
        
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor colorWithRed:71/255.0 green:211/255.0 blue:255/255.0 alpha:1].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [layer setLineWidth:2.0f];
    [self.bgView.layer addSublayer:layer];
    
}


#pragma mark - 显示数据
- (void)drawValues{
    for (int i = 0; i < count; i ++) {
        if (i==0 ||i==count-1) {
            CGPoint nowPoint = CGPointMake(XMargin + everyX * i, YMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint.x - 40, nowPoint.y - 30, 80, 30)];
            lbl.textColor = [UIColor whiteColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = [NSString stringWithFormat:@"%@",self.yValues[i]];
            lbl.font = [UIFont systemFontOfSize:15];
//            lbl.adjustsFontSizeToFitWidth = YES;
            if ([lbl sizeThatFits:CGSizeMake(120, 30)].width>40) {
                if(i==0){
                    lbl.textAlignment = NSTextAlignmentRight;
                }else{
                    lbl.textAlignment = NSTextAlignmentLeft;
                }
            }
            [self.bgView addSubview:lbl];
        }else{
            continue;
        }
    }
    CGPoint nowPoint = CGPointMake([UIScreen mainScreen].bounds.size.width - XMargin, YMargin);
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint.x - 60, nowPoint.y - 20, 60, 20)];
    lbl.textColor = [UIColor colorWithRed:71/255.0 green:211/255.0 blue:255/255.0 alpha:1];
    lbl.textAlignment = NSTextAlignmentRight;
    lbl.text = @"Max";
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:lbl];
    
     CGPoint nowPoint2 = CGPointMake([UIScreen mainScreen].bounds.size.width - XMargin, YMargin + (1 - minY / maxY ) * allH);
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint2.x - 30, nowPoint2.y, 40, 20)];
    lb2.textColor = [UIColor colorWithRed:71/255.0 green:211/255.0 blue:255/255.0 alpha:1];
    lb2.textAlignment = NSTextAlignmentRight;
    lb2.text = @"Min";
    lb2.font = [UIFont systemFontOfSize:14];
    lb2.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:lb2];
    
//    CGPoint nowPoint3 = CGPointMake(([UIScreen mainScreen].bounds.size.width-60)/2.0, 0);
//    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint3.x - 30, nowPoint3.y, 60, 20)];
//    lb3.textColor = [UIColor whiteColor];
//    lb3.textAlignment = NSTextAlignmentCenter;
//    lb3.text = self.monthOrYear;
//    lb3.font = [UIFont systemFontOfSize:15];
//    lb3.adjustsFontSizeToFitWidth = YES;
//    [self.bgView addSubview:lb3];
    
    CGPoint nowPoint4 = CGPointMake(XMargin, YMargin+allH+45);
    UILabel *lb4 = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint4.x, nowPoint4.y, 60, 20)];
    lb4.textColor = [UIColor whiteColor];
    lb4.textAlignment = NSTextAlignmentLeft;
    lb4.text = self.unit;
    lb4.font = [UIFont systemFontOfSize:14];
    lb4.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:lb4];
    
//    CGPoint nowPoint5 = CGPointMake([UIScreen mainScreen].bounds.size.width-60-XMargin, 0);
//    UILabel *lb5 = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint5.x-60, nowPoint5.y, 60, 20)];
//    lb5.textColor = [UIColor colorWithRed:138/255.0 green:227/255.0 blue:255/255.0 alpha:1];
//    lb5.textAlignment = NSTextAlignmentLeft;
//    lb5.text = @"用电量(度)";
//    lb5.font = [UIFont systemFontOfSize:13];
//    lb5.adjustsFontSizeToFitWidth = YES;
//    [self.bgView addSubview:lb5];
    
}

#pragma mark - 整合 画图表
- (void)drawChartWithLineChartType:(LineChartType)lineType pointType:(PointType) pointType{
    // 计算赋值
    [self doWithCalculate];
    
    NSArray *layers = [self.bgView.layer.sublayers mutableCopy];
    for (CAShapeLayer *layer in layers) {
        [layer removeFromSuperlayer];
    }

    // 画X轴
    [self drawXLine];
    
    //画刻度线
    [self drawTickMark];
    
    // 添加文字
    [self drawLabels];
    
    
    // 画折线
    [self drawFoldLineWithLineChartType:lineType];

    // 画虚线
    if (self.isShowLine) {
        [self drawLines];
    }

    
//    // 画点
//    if (self.isShowPoint) {
//        [self drawPointsWithPointType:pointType];
//    }
    
    // 显示数据
    if(self.isShowValue){
        [self drawValues];
    }
    
}


@end
