//
//  ElectricityFeeDisplay.m
//  copooo
//
//  Created by 夏明江 on 16/9/8.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ElectricityFeeDisplay.h"
#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0 //判断SDK版本号是否是7.0或7。0以上

@implementation ElectricityFeeDisplay


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
     [self drawElectricityView];
}

-(instancetype)initWithFrame:(CGRect)frame data:(ElectricityFeePaymentList *)eleFeePaymentDict index:(NSInteger)index{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        self.height = frame.size.height;
        self.width = frame.size.width;
        _eleFeePaymentDict = eleFeePaymentDict;
        _index = index;
    }
    return self;
}
-(void)drawElectricityView{
//    UIGraphicsBeginImageContext(self.bounds.size);
    // 创建path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    CGFloat toSide = 15;
    CGFloat xiuzhen  = 50;
    // 添加路径
    //顶线
    [path moveToPoint:CGPointMake(toSide , 0)];
    [path addLineToPoint:CGPointMake(_width-xiuzhen, 0)];
//    [[UIColor blueColor] setStroke];
//    [path stroke];
    //底线
    [path moveToPoint:CGPointMake(toSide , _height-xiuzhen)];
    [path addLineToPoint:CGPointMake(_width-xiuzhen, _height-xiuzhen)];
    //左边线
    [path moveToPoint:CGPointMake(toSide , 0)];
    [path addLineToPoint:CGPointMake(toSide, _height-xiuzhen)];
    //右边线
    [path moveToPoint:CGPointMake(_width-xiuzhen , 0)];
    [path addLineToPoint:CGPointMake(_width-xiuzhen, _height-xiuzhen)];
    //中间两条线
    [path moveToPoint:CGPointMake((_width-xiuzhen-toSide)/4.0+toSide , 0)];
    [path addLineToPoint:CGPointMake((_width-xiuzhen-toSide)/4.0+toSide, _height-xiuzhen)];
    
    [path moveToPoint:CGPointMake(((_width-xiuzhen-toSide)/4.0)*3+toSide , 0)];
    [path addLineToPoint:CGPointMake(((_width-xiuzhen-toSide)/4.0)*3+toSide, _height-xiuzhen)];
    // 将path绘制出来
    [[UIColor whiteColor] setStroke];
    [path stroke];
    
    //中线
    UIBezierPath *middlePath = [UIBezierPath bezierPath];
    middlePath.lineWidth = 3.0;
    [middlePath moveToPoint:CGPointMake(((_width-xiuzhen-toSide)/4.0)*2+toSide , 0)];
    [middlePath addLineToPoint:CGPointMake(((_width-xiuzhen-toSide)/4.0)*2+toSide, _height-xiuzhen)];
    // 将path绘制出来
    [[UIColor whiteColor] setStroke];
    [middlePath stroke];
    
   

    CGFloat fFlag =5*(_height-xiuzhen)/6;
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(toSide,(_height-xiuzhen)/6)];
    [path2 addLineToPoint:CGPointMake(_width-xiuzhen,(_height-xiuzhen)/6)];
    [path2 moveToPoint:CGPointMake(toSide,fFlag)];
    [path2 addLineToPoint:CGPointMake(_width-xiuzhen,fFlag)];
    CGFloat dash[] = {1,1};
    [path2 setLineDash:dash count:2 phase:0];//!!!
    [[UIColor whiteColor] setStroke];
    [path2 stroke];
    
//    //黄线 全市平均用电
    CGFloat max = _eleFeePaymentDict.max + 0.01;//+0.01防止闪退
    CGFloat min = _eleFeePaymentDict.min;
//    NSMutableArray * allAveArrayNum = [NSMutableArray array];
//    for (NSInteger i= _index; i<_index+3; i++) {
//        if (i-2<0) {
//            [allAveArrayNum addObject:[NSNumber numberWithFloat:min]];
//        }else{
//            [allAveArrayNum addObject:_eleFeePaymentDict.allAverage[i-2]];
//        }
//    }
//    NSMutableArray * allAveArray = [NSMutableArray array];
//
//    for (NSNumber * number in allAveArrayNum) {
//        CGFloat fFlag = (_height-xiuzhen)*(1/6.0)+(max-[number floatValue])/((max-min)/((_height-xiuzhen)*(2/3.0)));
//        [allAveArray addObject:[NSNumber numberWithFloat:fFlag]];
//    }
//    UIBezierPath *path3 = [UIBezierPath bezierPath];
//    path3.lineWidth = 4.0;
//    [path3 moveToPoint:CGPointMake(toSide,[allAveArray[0] floatValue])];
//    [path3 addLineToPoint:CGPointMake((_width-xiuzhen-toSide)/4.0+toSide,[allAveArray[1] floatValue])];
//    [path3 addLineToPoint:CGPointMake(2*(_width-xiuzhen-toSide)/4.0+toSide,[allAveArray[2] floatValue])];
//    [[UIColor colorWithRed:204/255.0 green:203/255.0 blue:55/255.0 alpha:1] setStroke];
//    [path3 stroke];
    
    //我的用电量
    NSMutableArray * allAveArrayNum2 = [NSMutableArray array];
    for (NSInteger i=_index; i<_index+3; i++) {
        if (i-2<0) {
            [allAveArrayNum2 addObject:[NSNumber numberWithFloat:min]];
        }else{
            [allAveArrayNum2 addObject:_eleFeePaymentDict.elecSum[i-2]];
        }
    }
    NSMutableArray * elecArray = [NSMutableArray array];
    
    for (NSNumber * number in allAveArrayNum2) {
        CGFloat fFlag = (_height-xiuzhen)*(1/6.0)+(max-[number floatValue])/((max-min)/((_height-xiuzhen)*(2/3.0)));
        [elecArray addObject:[NSNumber numberWithFloat:fFlag]];
    }

    UIBezierPath *path4 = [UIBezierPath bezierPath];
    path4.lineWidth = 4.0;
    [path4 moveToPoint:CGPointMake(toSide,[elecArray[0] floatValue])];
    [path4 addLineToPoint:CGPointMake((_width-xiuzhen-toSide)/4.0+toSide,[elecArray[1] floatValue])];
    [path4 addLineToPoint:CGPointMake(2*(_width-xiuzhen-toSide)/4.0+toSide,[elecArray[2] floatValue])];
    [[UIColor colorWithRed:148/255.0 green:255/255.0 blue:254/255.0 alpha:1] setStroke];
    [path4 stroke];
    
//    //放置button
//    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(2*(_width-xiuzhen-toSide)/4.0+toSide, [allAveArray[2] floatValue], 20, 20)];
//    button1.center = CGPointMake(2*(_width-xiuzhen-toSide)/4.0+toSide,[allAveArray[2] floatValue]);
//    [button1 setImage:[UIImage imageNamed:@"point2"] forState:UIControlStateNormal];
//    [self addSubview:button1];
    
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(2*(_width-xiuzhen-toSide)/4.0+toSide, [elecArray[2] floatValue], 20, 20)];
    button2.center = CGPointMake(2*(_width-xiuzhen-toSide)/4.0+toSide,[elecArray[2] floatValue]);
    [button2 setImage:[UIImage imageNamed:@"point2"] forState:UIControlStateNormal];
    [self addSubview:button2];
    
    //画文字
    [self drawText:@"最高值" point:CGPointMake(_width-xiuzhen+2, (_height-xiuzhen)/6-6) color:[UIColor whiteColor]];
     [self drawText:@"最低值" point:CGPointMake(_width-xiuzhen+2, 5*(_height-xiuzhen)/6-6) color:[UIColor whiteColor]];
    for (int i=1; i<=5; i++) {
        
        NSInteger month = [_eleFeePaymentDict.ElectricInfoList[_index].month integerValue]-2+i-1;
        if (month<1) {
            month += 12;
        }else if (month>12){
            month-=12;
        }
        
        NSString * str = [NSString stringWithFormat:@"%d月",(int)month];
        UIColor * color;
        if (i!=3) {
            color = [UIColor colorWithRed:124/255.0 green:169/255.0 blue:206/255.0 alpha:1];
        }else{
            color = [UIColor whiteColor];
        }
        [self drawText:str point:CGPointMake((i-1)*(_width-xiuzhen-toSide)/4.0+toSide-5, _height-xiuzhen+10) color:color];

    }
}

-(void)drawText:(NSString*)text point:(CGPoint)point color:(UIColor*)color{
    /*写文字*/
    UIFont  *font = [UIFont boldSystemFontOfSize:12.0];//定义默认字体
    if (IOS7) {
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中：发现只能水平居中，而无法垂直居中
        NSDictionary* attribute = @{
                                    NSForegroundColorAttributeName:color,//设置文字颜色
                                    NSFontAttributeName:font,//设置文字的字体
                                    NSKernAttributeName:@1,//文字之间的字距
                                    NSParagraphStyleAttributeName:paragraphStyle,//设置文字的样式
                                    };
        
        //计算文字的宽度和高度：支持多行显示
        CGSize sizeText = [text boundingRectWithSize:self.bounds.size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName:font,//设置文字的字体
                                                        NSKernAttributeName:@1,//文字之间的字距
                                                        }
                                              context:nil].size;
        
        CGRect rect = CGRectMake(point.x, point.y, sizeText.width, sizeText.height);
        [text drawInRect:rect withAttributes:attribute];
    }
}

//- (void)clicked:(id)sender
//{
//    @try {
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//        lbl.backgroundColor = [UIColor clearColor];
//        UIButton *btn = (UIButton *)sender;
//        NSUInteger tag = btn.tag;
//        
////        SHPlot *_plot = objc_getAssociatedObject(btn, @"kAssociatedPlotObject");
//        NSString *text = @"25°";
//        
//        lbl.text = text;
//        lbl.textColor = [UIColor whiteColor];
//        lbl.textAlignment = NSTextAlignmentCenter;
//        lbl.font = [UIFont systemFontOfSize:15];
//        [lbl sizeToFit];
//        lbl.frame = CGRectMake(0, 0, lbl.frame.size.width + 5, lbl.frame.size.height);
//        
//        CGPoint point =((UIButton *)sender).center;
//        point.y -= 15;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [PopoverView showPopoverAtPoint:point
//                                     inView:self
//                            withContentView:lbl
//                                   delegate:nil];
//        });
//    }
//    @catch (NSException *exception) {
//        NSLog(@"plotting label is not available for this point");
//    }
//}
//

@end
