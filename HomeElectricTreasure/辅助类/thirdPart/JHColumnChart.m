//
//  JHColumnChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHColumnChart.h"
#import <objc/runtime.h>
@interface JHColumnChart ()<CAAnimationDelegate>

//背景图
@property (nonatomic,strong)UIScrollView *BGScrollView;

//峰值
@property (nonatomic,assign) CGFloat maxHeight;

//横向最大值
@property (nonatomic,assign) CGFloat maxWidth;

//Y轴辅助线数据源
@property (nonatomic,strong)NSMutableArray * yLineDataArr;

//所有的图层数组
@property (nonatomic,strong)NSMutableArray * layerArr;

//所有的柱状图数组
@property (nonatomic,strong)NSMutableArray * showViewArr;

@property (nonatomic,assign) CGFloat perHeight;

@property (nonatomic , strong) NSMutableArray * drawLineValue;
@end

@implementation JHColumnChart

-(NSMutableArray *)drawLineValue{
    if (!_drawLineValue) {
        _drawLineValue = [NSMutableArray array];
    }
    return _drawLineValue;
}

-(NSMutableArray *)showViewArr{
    
    
    if (!_showViewArr) {
        _showViewArr = [NSMutableArray array];
    }
    
    return _showViewArr;
    
}

-(NSMutableArray *)layerArr{
    
    
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    
    return _layerArr;
}


-(UIScrollView *)BGScrollView{
    
    
    if (!_BGScrollView) {

        _BGScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _BGScrollView.showsHorizontalScrollIndicator = NO;
        _BGScrollView.backgroundColor = _bgVewBackgoundColor;
        [self addSubview:_BGScrollView];
        
    }
    
    return _BGScrollView;
    
    
}


-(void)setBgVewBackgoundColor:(UIColor *)bgVewBackgoundColor{
    
    _bgVewBackgoundColor = bgVewBackgoundColor;
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
}


-(NSMutableArray *)yLineDataArr{
    
    
    if (!_yLineDataArr) {
        _yLineDataArr = [NSMutableArray array];
    }
    return _yLineDataArr;
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {

        _needXandYLine = YES;
        _isShowYLine = YES;
        _lineChartPathColor = [UIColor blueColor];
        _lineChartValuePointColor = [UIColor yellowColor];
    }
    return self;
    
}

-(void)setLineValueArray:(NSArray *)lineValueArray{
    
    if (!_isShowLineChart) {
        return;
    }
    
    _lineValueArray = lineValueArray;
    CGFloat max = _maxHeight;
    
    for (id number in _lineValueArray) {
        
        CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
        if (currentNumber>max) {
            max = currentNumber;
        }
        
    }
    if (max<5.0) {
        _maxHeight = 5.0;
    }else if(max<10){
        _maxHeight = 10;
    }else{
        _maxHeight = max;
    }
    
    _maxHeight += 4;
    _perHeight = (CGRectGetHeight(self.frame) - 30 - _originSize.y)/_maxHeight;
    
    
}

-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    
    
    _valueArr = valueArr;
    CGFloat max = 0;
 
    for (NSArray *arr in _valueArr) {
        
        for (id number in arr) {
            
            CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
            if (currentNumber>max) {
                max = currentNumber;
            }
            
        }

    }
    
    if (max<5.0) {
        _maxHeight = 5.0;
    }else if(max<10){
        _maxHeight = 10;
    }else{
        _maxHeight = max;
    }
    
    _maxHeight += 10;
    _perHeight = (CGRectGetHeight(self.frame) - 30 - _originSize.y)/_maxHeight;
    
    
}


-(void)showAnimation{

    [self clear];
    
    _columnWidth = (_columnWidth<=0?30:_columnWidth);
    NSInteger count = _valueArr.count * [_valueArr[0] count];
    _typeSpace = (_typeSpace<=0?15:_typeSpace);
    _maxWidth = count * _columnWidth + _valueArr.count * _typeSpace + _typeSpace + 40;
    self.BGScrollView.contentSize = CGSizeMake(_maxWidth, 0);
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
    
    /*        绘制X、Y轴  可以在此改动X、Y轴字体大小       */
    if (_needXandYLine) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        [self.layerArr addObject:layer];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        if (self.isShowYLine) {
            [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
             [bezier addLineToPoint:P_M(self.originSize.x, 20)];
        }
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
    
        [bezier addLineToPoint:P_M(_maxWidth , CGRectGetHeight(self.frame) - self.originSize.y)];
        
        
        layer.path = bezier.CGPath;
        
        layer.strokeColor = (_colorForXYLine==nil?([UIColor blackColor].CGColor):_colorForXYLine.CGColor);
        
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic.duration = self.isShowYLine?1.5:0.75;
        
        basic.fromValue = @(0);
        
        basic.toValue = @(1);
        
        basic.autoreverses = NO;
        
        basic.fillMode = kCAFillModeForwards;
        
        
        [layer addAnimation:basic forKey:nil];
        
        [self.BGScrollView.layer addSublayer:layer];
        
//        _maxHeight += 4;
        
        /*        设置虚线辅助线         */
        UIBezierPath *second = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<5; i++) {
            NSInteger pace = (_maxHeight) / 5;
            CGFloat height = _perHeight * (i+1)*pace;
            [second moveToPoint:P_M(_originSize.x, CGRectGetHeight(self.frame) - _originSize.y -height)];
            [second addLineToPoint:P_M(_maxWidth, CGRectGetHeight(self.frame) - _originSize.y - height)];
            
            
            
            CATextLayer *textLayer = [CATextLayer layer];
            
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            NSString *text =[NSString stringWithFormat:@"%ld",(i + 1) * pace];
            CGFloat be = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:text].width;
            textLayer.frame = CGRectMake(self.originSize.x - be - 3, CGRectGetHeight(self.frame) - _originSize.y -height - 5, be, 15);
            
            UIFont *font = [UIFont systemFontOfSize:self.yDescTextFontSize];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textLayer.font = fontRef;
            textLayer.fontSize = font.pointSize;
            CGFontRelease(fontRef);
            
            textLayer.string = text;
            
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            [_BGScrollView.layer addSublayer:textLayer];
            [self.layerArr addObject:textLayer];

        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = second.CGPath;
        
        shapeLayer.strokeColor = (_dashColor==nil?([UIColor darkGrayColor].CGColor):_dashColor.CGColor);
        
        shapeLayer.lineWidth = 0.5;
        
        [shapeLayer setLineDashPattern:@[@(3),@(3)]];
        
        CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic2.duration = 1.5;
        
        basic2.fromValue = @(0);
        
        basic2.toValue = @(1);
        
        basic2.autoreverses = NO;
        
        
        
        basic2.fillMode = kCAFillModeForwards;
        
        [shapeLayer addAnimation:basic2 forKey:nil];
        
        [self.BGScrollView.layer addSublayer:shapeLayer];
        [self.layerArr addObject:shapeLayer];
        
    }
    
    
    

    /*        绘制X轴提示语  不管是否设置了是否绘制X、Y轴 提示语都应有         */
    if (_xShowInfoText.count == _valueArr.count&&_xShowInfoText.count>0) {
        
        NSInteger count = [_valueArr[0] count];
        for (NSInteger i = 0; i<_xShowInfoText.count+1; i++) {
            
            
            
            //            CATextLayer *textLayer = [CATextLayer layer];
            UILabel *textLayer = [[UILabel alloc]init];
            CGFloat wid =  count * _columnWidth+_typeSpace;
            
            if ( i == _xShowInfoText.count) {
                textLayer.frame = CGRectMake( -1 * (count * _columnWidth +_typeSpace) + _typeSpace/2.0 + _originSize.x +wid/4.0, CGRectGetHeight(self.frame) - _originSize.y,wid*3/4.0, 40);
            }else{
                textLayer.frame = CGRectMake( i * (count * _columnWidth +_typeSpace) + _typeSpace/2.0 + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y,wid, 40);
            }
            
            //            textLayer.contentsScale = [UIScreen mainScreen].scale;
            UIFont *font = [UIFont systemFontOfSize:11];
            
            
            textLayer.font = font;
            
            
            
            if (i< _realDataDate) {
                
                textLayer.backgroundColor = [UIColor colorWithRed:70/255.0 green:193/255.0 blue:253/255.0 alpha:1];
                
                
                
                
            }else{
                if (i==_xShowInfoText.count) {
                    textLayer.backgroundColor = [UIColor colorWithRed:61/255.0 green:134/255.0 blue:181/255.0 alpha:1];
                    
                }else{
                    textLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:247/255.0 blue:255/255.0 alpha:1];
                    
                    
                }
                
            }
            
            textLayer.contentMode = NSTextAlignmentCenter;
            
            [_BGScrollView addSubview:textLayer];
            
            [self.showViewArr addObject:textLayer];

            
            
        }

        for (NSInteger i = 0; i<_xShowInfoText.count+1; i++) {
            
            
            
            CATextLayer *textLayer = [CATextLayer layer];
            
            CGFloat wid =  count * _columnWidth+_typeSpace;
            
            if (i==_xShowInfoText.count) {
                textLayer.string = @"日期\n度";
            }else{
                textLayer.string = [NSString stringWithFormat:@"%@\n%@",_xShowInfoText[i],_valueArr[i][0]] ;
            }

            
            CGSize size = [textLayer.string boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.xDescTextFontSize]} context:nil].size;
            if ( i == _xShowInfoText.count) {
                textLayer.frame = CGRectMake( -1 * (count * _columnWidth +_typeSpace) + _typeSpace/2.0 + _originSize.x +wid/4.0, CGRectGetHeight(self.frame) - _originSize.y+5,wid*3/4.0, size.height+15);
            }else{
                textLayer.frame = CGRectMake( i * (count * _columnWidth +_typeSpace) + _typeSpace/2.0 + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height+20);
            }
        
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            UIFont *font = [UIFont systemFontOfSize:11];

            
            textLayer.fontSize = font.pointSize;
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:textLayer.string];
            
            
            if (i< _realDataDate) {
                
                    textLayer.backgroundColor = [UIColor colorWithRed:70/255.0 green:193/255.0 blue:253/255.0 alpha:1].CGColor;
                    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:200/255.0 green:243/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(0, [_xShowInfoText[i] length])];
                    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange([_xShowInfoText[i] length], [attributedStr length]-[_xShowInfoText[i] length])];
                    textLayer.string = attributedStr;
                
                

            }else{
                if (i==_xShowInfoText.count) {
                    textLayer.backgroundColor = [UIColor colorWithRed:61/255.0 green:134/255.0 blue:181/255.0 alpha:1].CGColor;
                    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
                    
                }else{
                    textLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:247/255.0 blue:255/255.0 alpha:1].CGColor;
                    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1] range:NSMakeRange(0, [_xShowInfoText[i] length])];
                    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange([_xShowInfoText[i] length], [attributedStr length]-[_xShowInfoText[i] length])];
                    textLayer.string = attributedStr;

                }
                
            }

            textLayer.alignmentMode = kCAAlignmentCenter;
           
            [_BGScrollView.layer addSublayer:textLayer];
            
            [self.layerArr addObject:textLayer];
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    /*        动画展示         */
    for (NSInteger i = 0; i<_valueArr.count; i++) {
        
        
        NSArray *arr = _valueArr[i];

        for (NSInteger j = 0; j<arr.count; j++) {
            CGFloat height =[arr[j] floatValue] *_perHeight;

            UIView *itemsView = [[UIView alloc]init];
            NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:i];
            itemsView.layer.masksToBounds = YES;
            objc_setAssociatedObject(itemsView, "indexPath", path,OBJC_ASSOCIATION_COPY_NONATOMIC);
            [self.showViewArr addObject:itemsView];
            itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace, CGRectGetHeight(self.frame) - _originSize.y-11, _columnWidth, 0);
            itemsView.layer.cornerRadius = 5;
            if (i< _realDataDate) {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,0- (CGRectGetHeight(self.frame) - height - _originSize.y -1), _columnWidth, CGRectGetHeight(self.frame)-_originSize.y-1)];
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                CGFloat maxPiontY = 0;
                
                for (NSArray *arr in _valueArr) {
                    for (id number in arr) {
                        CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
                        if (currentNumber>maxPiontY) {
                            maxPiontY = currentNumber;
                        }
                    }
                }
                if (maxPiontY<=10) {
                    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1].CGColor];
                    gradientLayer.locations = @[@(0.0),@(1.0)];
                    
                }else if(maxPiontY<=20){
                    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1].CGColor];
                    gradientLayer.locations = @[@(0.5),@(1.0)];
                    
                }else if (maxPiontY <=30){
                    gradientLayer.colors = @[
                                             (__bridge id)[UIColor colorWithRed:238/255.0 green:53/255.0 blue:214/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1].CGColor];
                    gradientLayer.locations = @[@(0.33),@(0.66),@(1.0)];
                    
                    
                }else if (maxPiontY<=40){
                    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:54/255.0 blue:39/255.0 alpha:1].CGColor,
                                             (__bridge id)[UIColor colorWithRed:238/255.0 green:53/255.0 blue:214/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1].CGColor];
                    gradientLayer.locations = @[@(0.25),@(0.5),@(0.75),@(1.0)];
                    
                }else{
                    CGFloat f = 10/maxPiontY;
                    gradientLayer.colors = @[
                                             (__bridge id)[UIColor colorWithRed:255/255.0 green:54/255.0 blue:39/255.0 alpha:1].CGColor,
                                             (__bridge id)[UIColor colorWithRed:238/255.0 green:53/255.0 blue:214/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:159/255.0 green:80/255.0 blue:251/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:2/255.0 green:187/255.0 blue:255/255.0 alpha:1].CGColor];
                    gradientLayer.locations = @[@(1-3*f),@(1-2*f),@(1-f),@(1)];
                    
                }

            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
            gradientLayer.frame = backView.bounds;
            [backView.layer addSublayer:gradientLayer];
        
            [itemsView addSubview:backView];
            }
            
            if (_delegate) {
                [itemsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)]];
            }
            if (_isShowLineChart) {
                NSString *value = [NSString stringWithFormat:@"%@",_lineValueArray[i]];
                float valueFloat =[value floatValue];
                NSValue *lineValue = [NSValue valueWithCGPoint:P_M(CGRectGetMaxX(itemsView.frame) - _columnWidth / 2, CGRectGetHeight(self.frame) - valueFloat * _perHeight - _originSize.y -1)];
                [self.drawLineValue addObject:lineValue];
            }
            
            
            itemsView.backgroundColor = [UIColor lightGrayColor];
            [UIView animateWithDuration:1 animations:^{
                
                 itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace, CGRectGetHeight(self.frame) - height - _originSize.y -11, _columnWidth, height);
                
            } completion:^(BOOL finished) {
                /*        动画结束后添加提示文字         */
                if (finished) {
                    
                    CATextLayer *textLayer = [CATextLayer layer];
                    
                    [self.layerArr addObject:textLayer];
                    NSString *str;
                    if (i<_realDataDate) {
                        str = @"";//[NSString stringWithFormat:@"%@",arr[j]];
                    }else{
                        str = @"(预测)";
                    }
                    
                    CGSize size = [str boundingRectWithSize:CGSizeMake(_columnWidth*2, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
                    
                    textLayer.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace - _columnWidth/3.0, CGRectGetHeight(self.frame) - height - _originSize.y -13 - size.height, size.width, size.height);
                    
                    textLayer.string = str;
                    
                    textLayer.fontSize = 9.0;
                    
                    textLayer.alignmentMode = kCAAlignmentCenter;
                    textLayer.contentsScale = [UIScreen mainScreen].scale;
                    textLayer.foregroundColor = itemsView.backgroundColor.CGColor;
                    
                    [_BGScrollView.layer addSublayer:textLayer];
                 
                    
                    
                    
                    //添加折线图
                    if (i==_valueArr.count - 1&&j == arr.count-1 && _isShowLineChart) {
                        
                        UIBezierPath *path = [UIBezierPath bezierPath];
                        
                        for (int32_t m=0;m<_lineValueArray.count;m++) {
                            NSLog(@"%@",_drawLineValue[m]);
                            if (m==0) {
                                [path moveToPoint:[_drawLineValue[m] CGPointValue]];
                                
                            }else{
                                [path addLineToPoint:[_drawLineValue[m] CGPointValue]];
                                [path moveToPoint:[_drawLineValue[m] CGPointValue]];
                            }
                            
                        }
                        
                        CAShapeLayer *shaper = [CAShapeLayer layer];
                        shaper.path = path.CGPath;
                        shaper.frame = self.bounds;
                        shaper.lineWidth = 2.5;
                        shaper.strokeColor = _lineChartPathColor.CGColor;
                        
                        [self.layerArr addObject:shaper];
                        
                        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];

                        basic.fromValue = @0;
                        basic.toValue = @1;
                        basic.duration = 1;
                        basic.delegate = self;
                        [shaper addAnimation:basic forKey:@"stokentoend"];
                        [self.BGScrollView.layer addSublayer:shaper];
                    }
                    
                    
                    
                }
                
            }];
            
            [self.BGScrollView addSubview:itemsView];
            

        }
        
    }
}

- (void)itemClick:(UITapGestureRecognizer *)sender{
    if ([_delegate respondsToSelector:@selector(columnItem:didClickAtIndexRow:)]) {
        [_delegate columnItem:sender.view didClickAtIndexRow:objc_getAssociatedObject(sender.view, "indexPath")];
    }
}

-(void)clear{
    
    
    for (CALayer *lay in self.layerArr) {
        [lay removeAllAnimations];
        [lay removeFromSuperlayer];
    }
    
    for (UIView *subV in self.showViewArr) {
        [subV removeFromSuperview];
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    if (flag) {
        
        if (_isShowLineChart) {
            

                for (int32_t m=0;m<_lineValueArray.count;m++) {
                    NSLog(@"%@",_drawLineValue[m]);


                        
                        CAShapeLayer *roundLayer = [CAShapeLayer layer];
                        UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:[_drawLineValue[m] CGPointValue] radius:4.5 startAngle:M_PI_2 endAngle:M_PI_2 + M_PI * 2 clockwise:YES];
                        roundLayer.path = roundPath.CGPath;
                        roundLayer.fillColor = _lineChartValuePointColor.CGColor;
                    [self.layerArr addObject:roundLayer];
                        [self.BGScrollView.layer addSublayer:roundLayer];
                        

                    
                }
                

            
        }
        
    }
    
    
}







@end
