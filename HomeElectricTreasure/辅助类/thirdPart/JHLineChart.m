//
//  JHLineChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHLineChart.h"
#define kXandYSpaceForSuperView 20.0

@interface JHLineChart ()<CAAnimationDelegate>
{
    NSMutableArray *anArr;
    NSMutableArray *momArr;
}
@property (assign, nonatomic)   CGFloat  xLength;
@property (assign , nonatomic)  CGFloat  yLength;
@property (assign , nonatomic)  CGFloat  perXLen ;
@property (assign , nonatomic)  CGFloat  perYlen ;
@property (assign , nonatomic)  CGFloat  perValue ;
@property (nonatomic,strong)    NSMutableArray * drawDataArr;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (assign , nonatomic) BOOL  isEndAnimation ;
@property (nonatomic,strong) NSMutableArray * layerArr;
@end

@implementation JHLineChart



/**
 *  重写初始化方法
 *
 *  @param frame         frame
 *  @param lineChartType 折线图类型
 *
 *  @return 自定义折线图
 */
-(instancetype)initWithFrame:(CGRect)frame andLineChartType:(JHLineChartType)lineChartType{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _lineType = lineChartType;
        _lineWidth = 0.5;
       
        _yLineDataArr  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xLineDataArr  = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _showXDescVertical = NO;
        _xDescriptionAngle = M_PI_2/15;
        _xDescMaxWidth = 20.0;
        _pointNumberColorArr = @[[UIColor redColor]];
        _positionLineColorArr = @[[UIColor darkGrayColor]];
        _pointColorArr = @[[UIColor orangeColor]];
        _xAndYNumberColor = [UIColor darkGrayColor];
        _valueLineColorArr = @[[UIColor redColor]];
        _layerArr = [NSMutableArray array];
        _showYLine = YES;
        _showYLevelLine = NO;
        _showValueLeadingLine = YES;
        _valueFontSize = 8.0;
        _showPointDescription = YES;
        
//        _contentFillColorArr = @[[UIColor lightGrayColor]];
        [self configChartXAndYLength];
        [self configChartOrigin];
        [self configPerXAndPerY];
}
    return self;
    
}

/**
 *  清除图标内容
 */
-(void)clear{
    
    _valueArr = nil;
    _drawDataArr = nil;
    
    for (CALayer *layer in _layerArr) {
        
        [layer removeFromSuperlayer];
    }
    [self showAnimation];
    
}
/**
 *  竖线
 */
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
    }
    return _lineView;
}
/**
*  同比
*/
- (UILabel *)anLabel{
    if (!_anLabel) {
        _anLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
        _anLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:20/255.0 alpha:1];
        _anLabel.textAlignment = NSTextAlignmentCenter;
        _anLabel.font = [UIFont systemFontOfSize:13];
        _anLabel.layer.cornerRadius = 5;
        _anLabel.layer.masksToBounds = YES;
        _anLabel.textColor = [UIColor whiteColor];
    }
    return _anLabel;
}
/**
*  环比
*/
- (UILabel *)momLabel{
    if (!_momLabel) {
        _momLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
        _momLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:209/255.0 blue:58/255.0 alpha:1];
        _momLabel.textAlignment = NSTextAlignmentCenter;
        _momLabel.font = [UIFont systemFontOfSize:13];
        _momLabel.layer.cornerRadius = 5;
        _momLabel.layer.masksToBounds = YES;
        _momLabel.textColor = [UIColor whiteColor];
    }
    return _momLabel;
}

/**
 *  获取每个X或y轴刻度间距
 */
- (void)configPerXAndPerY{
    
   
    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:
        {
            _perXLen = (_xLength-kXandYSpaceForSuperView)/((_xLineDataArr.count-1)==0?1:(_xLineDataArr.count-1));
            _perYlen = (_yLength-kXandYSpaceForSuperView)/_yLineDataArr.count;
        }
            break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:
        {
            _perXLen = (_xLength/2-kXandYSpaceForSuperView)/[_xLineDataArr[0] count];
            _perYlen = (_yLength-kXandYSpaceForSuperView)/_yLineDataArr.count;
        }
            break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:
        {
            _perXLen = (_xLength-kXandYSpaceForSuperView)/((_xLineDataArr.count-1)==0?1:(_xLineDataArr.count-1));
            _perYlen = (_yLength/2-kXandYSpaceForSuperView)/[_yLineDataArr[0] count];
        }
            break;
        case JHLineChartQuadrantTypeAllQuardrant:
        {
             _perXLen = (_xLength/2-kXandYSpaceForSuperView)/([_xLineDataArr[0] count]);
             _perYlen = (_yLength/2-kXandYSpaceForSuperView)/[_yLineDataArr[0] count];
        }
            break;
            
        default:
            break;
    }
    
}


/**
 *  重写LineChartQuardrantType的setter方法 动态改变折线图原点
 *
 */
-(void)setLineChartQuadrantType:(JHLineChartQuadrantType)lineChartQuadrantType{
    
    _lineChartQuadrantType = lineChartQuadrantType;
    [self configChartOrigin];
    
}

/**
 *  获取X与Y轴的长度
 */
- (void)configChartXAndYLength{
    _xLength = CGRectGetWidth(self.frame)-self.contentInsets.left-self.contentInsets.right;
    _yLength = CGRectGetHeight(self.frame)-self.contentInsets.top-self.contentInsets.bottom;
}


/**
 *  重写ValueArr的setter方法 赋值时改变Y轴刻度大小
 *
 */
-(void)setValueArr:(NSArray *)valueArr{
    
    _valueArr = valueArr;
    
    [self updateYScale];
    
    
}


/**
 *  更新Y轴的刻度大小
 */
- (void)updateYScale{
        switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:{
            
            NSInteger max = 0;
            NSInteger min = 0;
            
            for (NSArray *arr in _valueArr) {
                for (NSString * numer  in arr) {
                    NSInteger i = [numer integerValue];
                    if (i>=max) {
                        max = i;
                    }
                    if (i<=min) {
                        min = i;
                    }
                }
                
            }
            
         min = labs(min);
         max = (min<max?(max):(min));
        if (max%5==0) {
                max = max;
            }else
                max = (max/5+1)*5;
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *minArr = [NSMutableArray array];
        if (max<=5) {
            for (NSInteger i = 0; i<5; i++) {
                    
                [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
                [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*1]];
                }
            }
            
        if (max<=10&&max>5) {
                
                
            for (NSInteger i = 0; i<5; i++) {
                    
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*2]];

                }
                
        }else if(max>10&&max<=100){
            
            
            for (NSInteger i = 0; i<max/5; i++) {
                [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*5]];
                [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*5]];
            }
            
        }else{
            
            NSInteger count = max / 10;
            
            for (NSInteger i = 0; i<11; i++) {
                [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*count]];
                [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*count]];
            }
            
        }

        
            
            _yLineDataArr = @[[arr copy],[minArr copy]];
            
            
            [self setNeedsDisplay];
            
            
        }break;
        case JHLineChartQuadrantTypeAllQuardrant:{
            
            NSInteger max = 0;
            NSInteger min = 0;
            
            
            for (NSArray *arr in _valueArr) {
                for (NSString * numer  in arr) {
                    NSInteger i = [numer integerValue];
                    if (i>=max) {
                        max = i;
                    }
                    if (i<=min) {
                        min = i;
                    }
                }
                
            }

            
            min = labs(min);
            max = (min<max?(max):(min));
            if (max%5==0) {
                max = max;
            }else
                max = (max/5+1)*5;
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *minArr = [NSMutableArray array];
            if (max<=5) {
                for (NSInteger i = 0; i<5; i++) {
                    
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*1]];
                }
            }
            
            if (max<=10&&max>5) {
                
                
                for (NSInteger i = 0; i<5; i++) {
                    
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*2]];
                    
                }
                
            }else if(max>10&&max<=100){
                
                
                for (NSInteger i = 0; i<max/5; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*5]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*5]];
                }
                
            }else{
                
                NSInteger count = max / 10;
                
                for (NSInteger i = 0; i<11; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*count]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*count]];
                }
                
            }

            _yLineDataArr = @[[arr copy],[minArr copy]];
            
            [self setNeedsDisplay];
        }break;
        default:{
            if (_valueArr.count) {
                
                NSInteger max=0;
                
                for (NSArray *arr in _valueArr) {
                    for (NSString * numer  in arr) {
                        NSInteger i = [numer integerValue];
                        if (i>=max) {
                            max = i;
                        }
                        
                    }
                    
                }

                
                if (max%5==0) {
                    max = max;
                }else
                    max = (max/5+1)*5;
                _yLineDataArr = nil;
                NSMutableArray *arr = [NSMutableArray array];
                if (max<=5) {
                    for (NSInteger i = 0; i<5; i++) {
                        
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
                        
                    }
                }
                
                if (max<=10&&max>5) {
                    
                    
                    for (NSInteger i = 0; i<5; i++) {
                        
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                        
                    }
                    
                }else if(max>10&&max<=50){
                    
                    for (NSInteger i = 0; i<max/5+1; i++) {
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*5]];
                        
                        
                    }
                    
                }else if(max<=100){
                    
                    for (NSInteger i = 0; i<max/10; i++) {
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*10]];
                        
                        
                    }
                    
                }else if(max > 100){
                    
                    NSInteger count = max / 10;
                    
                    for (NSInteger i = 0; i<10+1; i++) {
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*count]];
                        
                    }
                }

                
                _yLineDataArr = [arr copy];
                
                [self setNeedsDisplay];
                
                
            }

        }
            break;
    }
    
    
    
}


/**
 *  构建折线图原点
 */
- (void)configChartOrigin{
    
    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:
        {
            self.chartOrigin = CGPointMake(self.contentInsets.left, self.frame.size.height-self.contentInsets.bottom);
        }
            break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:
        {
            self.chartOrigin = CGPointMake(self.contentInsets.left+_xLength/2, CGRectGetHeight(self.frame)-self.contentInsets.bottom);
        }
            break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:
        {
            self.chartOrigin = CGPointMake(self.contentInsets.left, self.contentInsets.top+_yLength/2);
        }
            break;
        case JHLineChartQuadrantTypeAllQuardrant:
        {
             self.chartOrigin = CGPointMake(self.contentInsets.left+_xLength/2, self.contentInsets.top+_yLength/2);
        }
            break;
            
        default:
            break;
    }
    
}




/* 绘制x与y轴 */
- (void)drawXAndYLineWithContext:(CGContextRef)context{

    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:{
            
            [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
            
            if (_showYLine) {
                  [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:self.xAndYLineColor];
            }
          
            if (_xLineDataArr.count>0) {
                CGFloat xPace = (_xLength-kXandYSpaceForSuperView)/((_xLineDataArr.count-1)==0?1:(_xLineDataArr.count-1));
                
                for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    if (_showXDescVertical) {
                        CGSize contentSize = [self sizeOfStringWithMaxSize:CGSizeMake(_xDescMaxWidth, CGFLOAT_MAX) textFont:self.xDescTextFontSize aimString:[NSString stringWithFormat:@"%@",_xLineDataArr[i]]];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - contentSize.width / 2.0, p.y+2, contentSize.width, contentSize.height)];
                        label.text = [NSString stringWithFormat:@"%@",_xLineDataArr[i]];
                        label.font = [UIFont systemFontOfSize:self.xDescTextFontSize];
                        label.numberOfLines = 0;
                        label.transform = CGAffineTransformRotate(label.transform, _xDescriptionAngle);
                        [self addSubview:label];
            
                    }else{
                        CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.xDescTextFontSize aimString:_xLineDataArr[i]].width;
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    
                        [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                    }
                }
              
                
                
            }
            
            if (_yLineDataArr.count>0) {
                CGFloat yPace = (_yLength - kXandYSpaceForSuperView)/(_yLineDataArr.count);
                for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    
                    CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].width;
                    CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].height;
                    if (_showYLevelLine) {
                         [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(self.contentInsets.left+_xLength, p.y) andIsDottedLine:YES andColor:self.xAndYLineColor];
                        
                    }else{
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    }
                    [self drawText:[NSString stringWithFormat:@"%@",_yLineDataArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:_xAndYNumberColor andFontSize:self.yDescTextFontSize];
                }
            }
            
        }break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:{
            [self drawLineWithContext:context andStarPoint:P_M(self.contentInsets.left, self.chartOrigin.y) andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
            
            if (_showYLine) {
                 [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:self.xAndYLineColor];
            }

            if (_xLineDataArr.count == 2) {
                NSArray * rightArr = _xLineDataArr[1];
                NSArray * leftArr = _xLineDataArr[0];
                
                CGFloat xPace = (_xLength/2-kXandYSpaceForSuperView)/(rightArr.count-1);
                
                for (NSInteger i = 0; i<rightArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    if (_showXDescVertical) {
                        CGSize contentSize = [self sizeOfStringWithMaxSize:CGSizeMake(_xDescMaxWidth, CGFLOAT_MAX) textFont:self.xDescTextFontSize aimString:[NSString stringWithFormat:@"%@",rightArr[i]]];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - contentSize.width / 2.0, p.y+2, contentSize.width, contentSize.height)];
                        label.text = [NSString stringWithFormat:@"%@",rightArr[i]];
                        label.font = [UIFont systemFontOfSize:self.xDescTextFontSize];
                        label.numberOfLines = 0;
                        label.transform = CGAffineTransformRotate(label.transform, _xDescriptionAngle);
                        [self addSubview:label];
                    }else{
                        CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.xDescTextFontSize aimString:rightArr[i]].width;
                    
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    
                        [self drawText:[NSString stringWithFormat:@"%@",rightArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                    }
                }
                
                for (NSInteger i = 0; i<leftArr.count;i++ ) {
                    CGPoint p = P_M(self.chartOrigin.x-(i+1)*xPace, self.chartOrigin.y);
                    if (_showXDescVertical) {
                        CGSize contentSize = [self sizeOfStringWithMaxSize:CGSizeMake(_xDescMaxWidth, CGFLOAT_MAX) textFont:self.xDescTextFontSize aimString:[NSString stringWithFormat:@"%@",leftArr[i]]];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - contentSize.width / 2.0, p.y+2, contentSize.width, contentSize.height)];
                        label.text = [NSString stringWithFormat:@"%@",leftArr[i]];
                        label.font = [UIFont systemFontOfSize:self.xDescTextFontSize];
                        label.numberOfLines = 0;
                        label.transform = CGAffineTransformRotate(label.transform, _xDescriptionAngle);
                        [self addSubview:label];
                    }else{
                        CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.xDescTextFontSize aimString:leftArr[i]].width;
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:self.xAndYLineColor];
                        [self drawText:[NSString stringWithFormat:@"%@",leftArr[leftArr.count-1-i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                    }
                }
                
            }
            if (_yLineDataArr.count>0) {
                CGFloat yPace = (_yLength - kXandYSpaceForSuperView)/(_yLineDataArr.count);
                for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].width;
                    CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].height;
                    if (_showYLevelLine) {
                         [self drawLineWithContext:context andStarPoint:P_M(self.contentInsets.left, p.y) andEndPoint:P_M(self.contentInsets.left+_xLength, p.y) andIsDottedLine:YES andColor:self.xAndYLineColor];
                    }else
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",_yLineDataArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:_xAndYNumberColor andFontSize:self.yDescTextFontSize];
                }
            }

        }break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:{
            CGPoint pp = CGPointMake(self.chartOrigin.x -10, self.chartOrigin.y);
//            [self drawLineWithContext:context andStarPoint:pp andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:YES andColor:self.xAndYLineColor];
            
            
            // 线的路径
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            // 起点
            [linePath moveToPoint:pp];
            // 其他点
            [linePath addLineToPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y)];
            CGFloat dash[] = {1.5,2};
            [linePath setLineDash:dash count:1 phase:1];
            [self.xAndYLineColor setStroke];
            [linePath stroke];
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            lineLayer.lineWidth = 1;
            lineLayer.path = linePath.CGPath;
            [self.layer addSublayer:lineLayer];
            
            
            if (_showYLine) {
                [self drawLineWithContext:context andStarPoint:P_M(self.contentInsets.left,CGRectGetHeight(self.frame)-self.contentInsets.bottom) andEndPoint:P_M(self.chartOrigin.x,self.contentInsets.top) andIsDottedLine:NO andColor:self.xAndYLineColor];
            }
            
            if (_xLineDataArr.count>0) {
                CGFloat xPace = (_xLength-kXandYSpaceForSuperView)/((_xLineDataArr.count-1)==0?1:(_xLineDataArr.count-1));
                
                
                
                for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
//                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    NSArray * bottomArr = _yLineDataArr[1];
                    CGFloat yPace = (_yLength/2 - kXandYSpaceForSuperView)/([_yLineDataArr[0] count]);
                      CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y + bottomArr.count*yPace);
                    if (_showXDescVertical) {
                        CGSize contentSize = [self sizeOfStringWithMaxSize:CGSizeMake(_xDescMaxWidth, CGFLOAT_MAX) textFont:self.xDescTextFontSize aimString:[NSString stringWithFormat:@"%@",_xLineDataArr[i]]];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - contentSize.width / 2.0, p.y+2, contentSize.width, contentSize.height)];
                        label.text = [NSString stringWithFormat:@"%@",_xLineDataArr[i]];
                        label.font = [UIFont systemFontOfSize:self.xDescTextFontSize];
                        label.numberOfLines = 0;
                        label.transform = CGAffineTransformRotate(label.transform, _xDescriptionAngle);
                        [self addSubview:label];
                    }else{
                        CGFloat len = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.xDescTextFontSize aimString:_xLineDataArr[i]].width;
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    
                        if (i==0) {
                            len = -2;
                        }
                    
                        [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+8) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                    }
                }
            }
            CGFloat xPace;
            if (_xLineDataArr.count == 1) {
                xPace = _xLength-kXandYSpaceForSuperView;
            }else{
                xPace = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
            }
            NSArray * topArr = _yLineDataArr[0];
            NSArray * bottomArr = _yLineDataArr[1];
            CGFloat yPace = (_yLength/2 - kXandYSpaceForSuperView)/([_yLineDataArr[0] count]);
            CGPoint p = P_M(0*xPace+self.chartOrigin.x, self.chartOrigin.y );
            CGPoint p2 = P_M(0*xPace+self.chartOrigin.x, self.chartOrigin.y + bottomArr.count*yPace);

            [self drawText:@"0.00%" andContext:context atPoint:P_M(CGRectGetWidth(self.frame)-25, p.y-5) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
            
            [self drawText:@"0.00%" andContext:context atPoint:P_M(2, p.y-5) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];

            [self drawText:_noDataStr andContext:context atPoint:P_M(CGRectGetWidth(self.frame)/2.0-20, p.y-15) WithColor:_xAndYNumberColor andFontSize:12];
            
            [self drawText:_unit andContext:context atPoint:P_M(p2.x, p2.y+20) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                       


            
            
            _lineView.frame = CGRectMake((_xLineDataArr.count -1)*xPace+self.chartOrigin.x, p.y - topArr.count*yPace, 1, (topArr.count + bottomArr.count)*yPace);
            
            if (_yLineDataArr.count == 2) {
                
                NSArray * topArr = _yLineDataArr[0];
                NSArray * bottomArr = _yLineDataArr[1];
                CGFloat yPace = (_yLength/2 - kXandYSpaceForSuperView)/([_yLineDataArr[0] count]);
                _perYlen = yPace;
                    CGPoint p = P_M(self.chartOrigin.x -10 , self.chartOrigin.y -topArr.count*yPace);
//                    CGFloat len = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:topArr[i]].width;
//                    CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:topArr[i]].height;
                    if (_showYLevelLine) {
                         [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(self.contentInsets.left+_xLength, p.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    }else
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
//                    [self drawText:[NSString stringWithFormat:@"%@",topArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:_xAndYNumberColor andFontSize:self.yDescTextFontSize];
                
                
                
                
                    CGPoint p2 = P_M(self.chartOrigin.x - 10, self.chartOrigin.y + bottomArr.count*yPace);
//                    CGFloat len = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:bottomArr[i]].width;
//                    CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:bottomArr[i]].height;

                    if (_showYLevelLine) {
                         [self drawLineWithContext:context andStarPoint:p2 andEndPoint:P_M(self.contentInsets.left+_xLength, p2.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    }else{
                    
                        [self drawLineWithContext:context andStarPoint:p2 andEndPoint:P_M(p2.x+3, p2.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    }
//                    [self drawText:[NSString stringWithFormat:@"%@",bottomArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:_xAndYNumberColor andFontSize:self.yDescTextFontSize];
                
                
                
            }
            for (NSInteger m = 0;m<_valueArr.count;m++) {
                NSArray *arr = _drawDataArr[m];
                
                for (NSInteger i = 0 ;i<arr.count;i++ ) {
                    
                    CGPoint p = [arr[i] CGPointValue];
                    if (i == arr.count -1 ) {
                        NSString *aimStr;
                        aimStr = [_valueArr[m][i] floatValue]<0?[NSString stringWithFormat:@"%0.2f",-[_valueArr[m][i] floatValue]]:[NSString stringWithFormat:@"%@",_valueArr[m][i]];

                        if (m==0) {
                            _anLabel.center = p;
                            _anLabel.text = aimStr;
                            if ([_valueArr[m][i] floatValue]>0.001) {
                                _anLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:20/255.0 alpha:1];
                                
                            }else if([_valueArr[m][i] floatValue]<-0.001){
                                _anLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:209/255.0 blue:58/255.0 alpha:1];
                            }else{
                                _anLabel.backgroundColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];

                            }
                        }else{
                            _momLabel.center = p;
                            _momLabel.text = aimStr;
                            if ([_valueArr[m][i] floatValue]>0.001) {
                                _momLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:20/255.0 alpha:1];
                            }else if([_valueArr[m][i] floatValue]<-0.001){
                                _momLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:209/255.0 blue:58/255.0 alpha:1];
                            }else{
                                _momLabel.backgroundColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];

                            }
                        }

                    }
                }
            }
        }break;
        case JHLineChartQuadrantTypeAllQuardrant:{
            [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x-_xLength/2, self.chartOrigin.y) andEndPoint:P_M(self.chartOrigin.x+_xLength/2, self.chartOrigin.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
            
            if (_showYLine) {
                [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x,self.chartOrigin.y+_yLength/2) andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength/2) andIsDottedLine:NO andColor:self.xAndYLineColor];
            }
            
            
            
            if (_xLineDataArr.count == 2) {
                NSArray * rightArr = _xLineDataArr[1];
                NSArray * leftArr = _xLineDataArr[0];
                
                CGFloat xPace = (_xLength/2-kXandYSpaceForSuperView)/(rightArr.count-1);
                
                for (NSInteger i = 0; i<rightArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    if (_showXDescVertical) {
                        CGSize contentSize = [self sizeOfStringWithMaxSize:CGSizeMake(_xDescMaxWidth, CGFLOAT_MAX) textFont:self.xDescTextFontSize aimString:[NSString stringWithFormat:@"%@",rightArr[i]]];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - contentSize.width / 2.0, p.y+2, contentSize.width, contentSize.height)];
                        label.text = [NSString stringWithFormat:@"%@",rightArr[i]];
                        label.font = [UIFont systemFontOfSize:self.xDescTextFontSize];
                        label.numberOfLines = 0;
                        label.transform = CGAffineTransformRotate(label.transform, _xDescriptionAngle);
                        [self addSubview:label];
                    }else{
                        CGFloat len = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.xDescTextFontSize aimString:rightArr[i]].width;
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    
                        [self drawText:[NSString stringWithFormat:@"%@",rightArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                    }
                }
                for (NSInteger i = 0; i<leftArr.count;i++ ) {
                    CGPoint p = P_M(self.chartOrigin.x-(i+1)*xPace, self.chartOrigin.y);
                    if (_showXDescVertical) {
                        CGSize contentSize = [self sizeOfStringWithMaxSize:CGSizeMake(_xDescMaxWidth, CGFLOAT_MAX) textFont:self.xDescTextFontSize aimString:[NSString stringWithFormat:@"%@",leftArr[i]]];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - contentSize.width / 2.0, p.y+2, contentSize.width, contentSize.height)];
                        label.text = [NSString stringWithFormat:@"%@",leftArr[i]];
                        label.font = [UIFont systemFontOfSize:self.xDescTextFontSize];
                        label.numberOfLines = 0;
                        label.transform = CGAffineTransformRotate(label.transform, _xDescriptionAngle);
                        [self addSubview:label];
                    }else{
                        CGFloat len = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.xDescTextFontSize aimString:leftArr[i]].width;
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    
                        [self drawText:[NSString stringWithFormat:@"%@",leftArr[leftArr.count-1-i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                    }
                }
                
            }

            
            if (_yLineDataArr.count == 2) {
                
                NSArray * topArr = _yLineDataArr[0];
                NSArray * bottomArr = _yLineDataArr[1];
                CGFloat yPace = (_yLength/2 - kXandYSpaceForSuperView)/([_yLineDataArr[0] count]);
                _perYlen = yPace;
                for (NSInteger i = 0; i<topArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    CGFloat len = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:topArr[i]].width;
                    CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:topArr[i]].height;

                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",topArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:_xAndYNumberColor andFontSize:self.yDescTextFontSize];
                    
                }
                
                
                for (NSInteger i = 0; i<bottomArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y + (i+1)*yPace);
                    CGFloat len = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:bottomArr[i]].width;
                    CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:bottomArr[i]].height;

                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",bottomArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:_xAndYNumberColor andFontSize:self.yDescTextFontSize];
                }
                
                
            }
            
        }break;
            
        default:
            break;
    }
    

}

/**
 *  动画展示路径
 */
-(void)showAnimation{
    if ([self.subviews count]>0) {
        return;
    }
    [self configPerXAndPerY];
    [self configValueDataArray];
    [self drawAnimation];
    if ([_noDataStr isEqualToString:@""]) {
        [self addSubview:self.lineView];
//        [self addSubview:self.anLabel];
//        if (self.showMomLabel) {
//            [self addSubview:self.momLabel];
//            
//        }
//        [self bringSubviewToFront:_anLabel];
//        [self bringSubviewToFront:_momLabel];

    }
}


- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawXAndYLineWithContext:context];
    
    
    if (!_isEndAnimation) {
        return;
    }
    
    if (_drawDataArr.count) {
        [self drawPositionLineWithContext:context];
    }
    
}



/**
 *  装换值数组为点数组
 */
- (void)configValueDataArray{
    _drawDataArr = [NSMutableArray array];
    
    if (_valueArr.count==0) {
        return;
    }
    
    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:{
            _perValue = _perYlen/[[_yLineDataArr firstObject] floatValue];
            
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
                for (NSInteger i = 0; i<valueArr.count; i++) {
                    
                    CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue);
                    NSValue *value = [NSValue valueWithCGPoint:p];
                    [dataMArr addObject:value];
                }
                [_drawDataArr addObject:[dataMArr copy]];
                
            }

            
        }break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:{
            
            _perValue = _perYlen/[[_yLineDataArr firstObject] floatValue];
            
            
            
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
              
                    
                    CGPoint p ;
                    for (NSInteger i = 0; i<[_xLineDataArr[0] count]; i++) {
                        p = P_M(self.contentInsets.left + kXandYSpaceForSuperView+i*_perXLen, self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                    }
                    
                    for (NSInteger i = 0; i<[_xLineDataArr[1] count]; i++) {
                        p = P_M(self.chartOrigin.x+i*_perXLen, self.contentInsets.top + _yLength - [valueArr[i+[_xLineDataArr[0] count]] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                        
                    }
                    
                    
               
                [_drawDataArr addObject:[dataMArr copy]];
                
            }


            
            
        }break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:{
            _perValue = _perYlen/[[_yLineDataArr[0] firstObject] floatValue];
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
                for (NSInteger i = 0; i<valueArr.count; i++) {
                    
                    CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.chartOrigin.y - [valueArr[i] floatValue]*_perValue);
                    NSValue *value = [NSValue valueWithCGPoint:p];
                    [dataMArr addObject:value];
                }
                [_drawDataArr addObject:[dataMArr copy]];
                
            }
            
        }break;
        case JHLineChartQuadrantTypeAllQuardrant:{
            
            
            
            _perValue = _perYlen/[[_yLineDataArr[0] firstObject] floatValue];
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
             
                    
                    CGPoint p ;
                    for (NSInteger i = 0; i<[_xLineDataArr[0] count]; i++) {
                        p = P_M(self.contentInsets.left + kXandYSpaceForSuperView+i*_perXLen, self.chartOrigin.y-[valueArr[i] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                    }
                    
                    for (NSInteger i = 0; i<[_xLineDataArr[1] count]; i++) {
                        p = P_M(self.chartOrigin.x+i*_perXLen, self.chartOrigin.y-[valueArr[i+[_xLineDataArr[0] count]] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                        
                    }
                    
                    
           
                [_drawDataArr addObject:[dataMArr copy]];
                
            }

        }break;
        default:
            break;
    }



}


//执行动画
- (void)drawAnimation{
    
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = [CAShapeLayer layer];
    if (_drawDataArr.count==0) {
        return;
    }
    
//    NSArray * onceArry = _drawDataArr[0];
//    if (onceArry.count == 0) {
//        return;
//    }
    
    //第一、UIBezierPath绘制线段
    [self configPerXAndPerY];
 
    
    for (NSInteger i = 0;i<_drawDataArr.count;i++) {
        
        NSArray *dataArr = _drawDataArr[i];
        
        [self drawPathWithDataArr:dataArr andIndex:i];
        
    }
    

    
}


- (CGPoint)centerOfFirstPoint:(CGPoint)p1 andSecondPoint:(CGPoint)p2{
    
    
    return P_M((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
    
}



- (void)drawPathWithDataArr:(NSArray *)dataArr andIndex:(NSInteger )colorIndex{
    
    UIBezierPath *firstPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0, 0)];
    
    UIBezierPath *secondPath = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i<dataArr.count; i++) {
        
        NSValue *value = dataArr[i];
        
        CGPoint p = value.CGPointValue;
        
        if (_pathCurve) {
            if (i==0) {
                
                if (_contentFill) {

                    [secondPath moveToPoint:P_M(p.x, self.chartOrigin.y)];
                    [secondPath addLineToPoint:p];
                }

                [firstPath moveToPoint:p];
            }else{
                CGPoint nextP = [dataArr[i-1] CGPointValue];
                CGPoint control1 = P_M(p.x + (nextP.x - p.x) / 2.0, nextP.y );
                CGPoint control2 = P_M(p.x + (nextP.x - p.x) / 2.0, p.y);
                 [secondPath addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
                [firstPath addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
            }
        }else{
            
              if (i==0) {
                  if (_contentFill) {
                      [secondPath moveToPoint:P_M(p.x, self.chartOrigin.y)];
                      [secondPath addLineToPoint:p];
                  }
                  [firstPath moveToPoint:p];
//                   [secondPath moveToPoint:p];
              }else{
                   [firstPath addLineToPoint:p];
                   [secondPath moveToPoint:p];
                   [secondPath addLineToPoint:p];
            }

        }

        if (i==dataArr.count-1) {
            
            [secondPath addLineToPoint:P_M(p.x, self.chartOrigin.y)];
            
        }
    }
    
    
    
    if (_contentFill) {
        [secondPath closePath];
    }
    
    //第二、UIBezierPath和CAShapeLayer关联
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = firstPath.CGPath;
    UIColor *color = (_valueLineColorArr.count==_drawDataArr.count?(_valueLineColorArr[colorIndex]):([UIColor orangeColor]));
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = (_animationPathWidth<=0?2:_animationPathWidth);
    
    //第三，动画
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    
    ani.fromValue = @0;
    
    ani.toValue = @1;
    
    ani.duration = 0.2 * dataArr.count;
    
    ani.delegate = self;
    
    [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
//    dispatch_queue_t queue = dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL);
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (NSInteger j = 0; j<dataArr.count; j++) {
//            dispatch_async(queue, ^{
//                
//                CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
//                
//                ani.fromValue = @(j*1.0/dataArr.count);
//                
//                ani.toValue = @((j+1)*1.0/dataArr.count);
//                
//                ani.duration = 0.2;
//                
//                [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
//                
//            });
//            
//        }
//        // 回到主线程
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.layer addSublayer:shapeLayer];
            [_layerArr addObject:shapeLayer];
//        });
//    });
    
    weakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * dataArr.count * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CAShapeLayer *shaperLay = [CAShapeLayer layer];
        shaperLay.frame = weakself.bounds;
        shaperLay.path = secondPath.CGPath;
        if (weakself.contentFillColorArr.count == weakself.drawDataArr.count) {
            
            shaperLay.fillColor = [weakself.contentFillColorArr[colorIndex] CGColor];
        }else{
            shaperLay.fillColor = [UIColor clearColor].CGColor;
        }
        
        [weakself.layer addSublayer:shaperLay];
        [_layerArr addObject:shaperLay];
    });
    
    
}



/**
 *  设置点的引导虚线
 *
 *  @param context 图形面板上下文
 */
- (void)drawPositionLineWithContext:(CGContextRef)context{
    
    
    
    if (_drawDataArr.count==0) {
        return;
    }
    
    
    
    for (NSInteger m = 0;m<_valueArr.count;m++) {
        NSArray *arr = _drawDataArr[m];
        
        for (NSInteger i = 0 ;i<arr.count;i++ ) {
            
            CGPoint p = [arr[i] CGPointValue];
            
            UIColor *positionLineColor;
            if (_positionLineColorArr.count == _valueArr.count) {
                positionLineColor = _positionLineColorArr[m];
            }else
                positionLineColor = [UIColor orangeColor];

            
            if (_showValueLeadingLine) {
                [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x, p.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
                [self drawLineWithContext:context andStarPoint:P_M(p.x, self.chartOrigin.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
            }
          
            if (!_showPointDescription) {
                continue;
            }
            if (p.y!=0) {
                UIColor *pointNumberColor = (_pointNumberColorArr.count == _valueArr.count?(_pointNumberColorArr[m]):([UIColor orangeColor]));
                
                switch (_lineChartQuadrantType) {
                       
                        
                    case JHLineChartQuadrantTypeFirstQuardrant:
                    {
                        NSString *aimStr = [NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(100, 25) textFont:self.valueFontSize aimString:aimStr];
                        CGFloat length = size.width;
                        
                        [self drawText:aimStr andContext:context atPoint:P_M(p.x - length / 2, p.y - size.height / 2 -10) WithColor:pointNumberColor andFontSize:self.valueFontSize];
                    }
                        break;
                    case JHLineChartQuadrantTypeFirstAndSecondQuardrant:
                    {
                        NSString *str = (i<[_xLineDataArr[0] count]?(_xLineDataArr[0][i]):(_xLineDataArr[1][i-[_xLineDataArr[0] count]]));
                        
                        NSString *aimStr = [NSString stringWithFormat:@"(%@,%@)",str,_valueArr[m][i]];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(100, 25) textFont:self.valueFontSize aimString:aimStr];
                        CGFloat length = size.width;
                        [self drawText:aimStr andContext:context atPoint:P_M(p.x - length / 2, p.y - size.height / 2 -5) WithColor:pointNumberColor andFontSize:self.valueFontSize];
                    }
                        break;
                    case JHLineChartQuadrantTypeFirstAndFouthQuardrant:
                    {
                        NSString *aimStr = [NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(100, 25) textFont:self.valueFontSize aimString:aimStr];
                        CGFloat length = size.width;
                        [self drawText:aimStr andContext:context atPoint:P_M(p.x - length / 2, p.y - size.height / 2 -5) WithColor:pointNumberColor andFontSize:self.valueFontSize];
                    }
                        break;
                    case JHLineChartQuadrantTypeAllQuardrant:
                    {
                        NSString *str = (i<[_xLineDataArr[0] count]?(_xLineDataArr[0][i]):(_xLineDataArr[1][i-[_xLineDataArr[0] count]]));
                        
                        NSString *aimStr =[NSString stringWithFormat:@"(%@,%@)",str,_valueArr[m][i]];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(100, 25) textFont:self.valueFontSize aimString:aimStr];
                        CGFloat length = size.width;
                        
                        [self drawText:aimStr andContext:context atPoint:P_M(p.x - length / 2, p.y - size.height / 2 -5) WithColor:pointNumberColor andFontSize:self.valueFontSize];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            
        }
    }
    
     _isEndAnimation = NO;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    for (NSInteger m = 0;m<_valueArr.count;m++) {
        NSArray *arr = _drawDataArr[m];
        if (arr.count == 0) {
            return;
        }
        for (NSInteger i = 0 ;i<arr.count-1;i++ ) {
            
            CGPoint p = [arr[i] CGPointValue];
            CGPoint p2 = [arr[i+1] CGPointValue];

            if (point.x>=p.x && point.x<p2.x) {
                CGPoint rightPoint;
                NSString *aimStr = [NSString stringWithFormat:@"%@",_valueArr[m][i]];
                NSInteger k = 0;
                if (point.x>(p.x+p2.x)/2.0) {
                    rightPoint = p2;
                    aimStr =[_valueArr[m][i+1] floatValue]<0?[NSString stringWithFormat:@"%.2f",-[_valueArr[m][i+1] floatValue]]:[NSString stringWithFormat:@"%@",_valueArr[m][i+1]];
                    k = i+1;
                }else{
                    rightPoint = p;
                    aimStr = [_valueArr[m][i] floatValue]<0?[NSString stringWithFormat:@"%0.2f",-[_valueArr[m][i] floatValue]]:[NSString stringWithFormat:@"%@",_valueArr[m][i]];
                    k = i;
                }
                NSArray * topArr = _yLineDataArr[0];
                NSArray * bottomArr = _yLineDataArr[1];
                CGFloat yPace = (_yLength/2 - kXandYSpaceForSuperView)/([_yLineDataArr[0] count]);
                CGPoint p3 = P_M(self.chartOrigin.x, self.chartOrigin.y );
                _lineView.frame = CGRectMake(rightPoint.x, p3.y - topArr.count*yPace, 1, (topArr.count + bottomArr.count)*yPace);

                if (m==0) {
                    _anLabel.center = rightPoint;
                    _anLabel.text = aimStr;
                    if ([_valueArr[m][k] floatValue]>0.001) {
                        _anLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:20/255.0 alpha:1];
                        
                    }else if([_valueArr[m][k] floatValue]<-0.001){
                        _anLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:209/255.0 blue:58/255.0 alpha:1];
                    }else{
                        _anLabel.backgroundColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                        
                    }
                    if ([self.delegate respondsToSelector:@selector(jhLineChartDelegate:)]) {
                        [self.delegate jhLineChartDelegate:k];
                    }
                }else{
                    _momLabel.center = rightPoint;
                    _momLabel.text = aimStr;
                    if ([_valueArr[m][k] floatValue]>0.001) {
                        _momLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:20/255.0 alpha:1];
                    }else if([_valueArr[m][k] floatValue]<-0.001){
                        _momLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:209/255.0 blue:58/255.0 alpha:1];
                    }else{
                        _momLabel.backgroundColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                        
                    }
                }


            }
            [self layoutIfNeeded];
        }
    }
    
}



-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag) {
        
        
     
//        [self drawPoint];

        
    }
    
}

-(void)animationDidStart:(CAAnimation *)anim{
    [self drawPoint];
}
/**
 *  绘制值的点
 */
- (void)drawPoint{
    anArr = [NSMutableArray array];
    momArr = [NSMutableArray array];
    for (NSInteger m = 0;m<_drawDataArr.count;m++) {
        
        NSArray *arr = _drawDataArr[m];
        for (NSInteger i = 0; i<arr.count; i++) {
            
            NSValue *value = arr[i];
            
            CGPoint p = value.CGPointValue;
            
            
            UIBezierPath *pBezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 5, 5)];
            [pBezier moveToPoint:p];
            //            [pBezier addArcWithCenter:p radius:13 startAngle:0 endAngle:M_PI*2 clockwise:YES];
            CAShapeLayer *pLayer = [CAShapeLayer layer];
            pLayer.frame = CGRectMake(0, 0, 5, 5);
            pLayer.lineWidth = 1.f;
            pLayer.position = p;
            pLayer.path = pBezier.CGPath;
            
            UIColor *color = _pointColorArr.count==_drawDataArr.count?(_pointColorArr[m]):([UIColor orangeColor]);
            
            if ([_valueArr[m][i] isEqualToString:@"--"]) {
                pLayer.fillColor = [UIColor whiteColor].CGColor;
            }else{
                pLayer.fillColor = color.CGColor;
            }
            pLayer.strokeColor = color.CGColor;//线条颜色
//            CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
//            
//            ani.fromValue = @0;
//            
//            ani.toValue = @1;
//            
//            ani.duration = 0;
//            
//            
//            [pLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
            
            [self.layer addSublayer:pLayer];
//            pLayer.zPosition = -1;
            [_layerArr addObject:pLayer];
            if (m==0) {
                [anArr addObject:pLayer];
            }else{
                [momArr addObject:pLayer];
            }
            pLayer.hidden = YES;

        }
        _isEndAnimation = YES;
       
        [self setNeedsDisplay];

    }
    if (anArr.count != 0) {
        [self addSubview];
    }
}

- (void)addSubview{
    [self addSubviews:0];
}

- (void)addSubviews:(NSInteger)i{
    
    CAShapeLayer *layer = anArr[i];
    layer.hidden = NO;
    if (momArr.count>0) {
        CAShapeLayer *layer = momArr[i];
        layer.hidden = NO;
    }
    i++;
    if (i == anArr.count) {
        return;
    }
    double delayInSeconds = 0.2;
    weakSelf(self);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakself addSubviews:i];
            //执行事件
         });
//    [self setNeedsDisplay];

}


@end
