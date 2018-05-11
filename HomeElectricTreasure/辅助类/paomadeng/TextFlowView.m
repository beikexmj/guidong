//
//  TextFlowView.m
//  Paoma
//
//  Created by wu wxj on 11-9-7.
//  Copyright 2011年 tt. All rights reserved.
//

#import "TextFlowView.h"


@implementation TextFlowView

#pragma mark -
#pragma mark 内部调用

#define SPACE_WIDTH 50
#define LABEL_NUM 2

//改变一个TRect的起始点位置，但是其终止店点的位置不变，因此会导致整个框架大小的变化
- (CGRect)moveNewPoint:(CGPoint)point rect:(CGRect)rect
{
    CGSize tmpSize;
    tmpSize.height = rect.size.height + (rect.origin.y - point.y);
    tmpSize.width = rect.size.width + (rect.origin.x - point.x);
    return CGRectMake(point.x, point.y, tmpSize.width, tmpSize.height);
}
//开启定时器
- (void)startRun
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

//关闭定时器
- (void)cancelRun
{
    if (_timer) 
    {
        [_timer invalidate];
    }
}

//定时器执行的操作
- (void)timerAction
{
    static CGFloat offsetOnce = -1;
    _XOffset += offsetOnce;
    if (_XOffset +  _textSize.width <= 0) 
    {
        _XOffset += _textSize.width;
        _XOffset += SPACE_WIDTH;
    }
    [self setNeedsDisplay];
    
}

//计算在给定字体下，文本仅显示一行需要的框架大小
- (CGSize)computeTextSize:(NSString *)text
{
    if (text == nil) 
    {
        return CGSizeMake(0, 0);
    }
    CGSize boundSize = CGSizeMake(10000, 100);
//    CGSize stringSize = [_text sizeWithFont:_font constrainedToSize:boundSize lineBreakMode:UILineBreakModeWordWrap];
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary*attribute = @{NSFontAttributeName:_font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName :[UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1]};
   CGSize stringSize= [_text boundingRectWithSize:boundSize options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return stringSize;
}


- (id)initWithFrame:(CGRect)frame Text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _text = [text copy];
        _frame = frame;
        //默认的字体大小
        _font = [UIFont systemFontOfSize:13.0F];
        self.backgroundColor = [UIColor clearColor];
        //初始化标签
        //判断是否需要滚动效果
        _textSize = [self computeTextSize:text];
        //需要滚动效果
        if (_textSize.width > frame.size.width) 
        {
            _needFlow = YES;
            [self startRun];
        }
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    // Drawing code
    CGFloat startYOffset = (rect.size.height - _textSize.height)/2;
    CGPoint origin = rect.origin;
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    UIColor *color;
    if(self.tag==1010){
        color = [UIColor whiteColor];
    }else if(self.tag == 1011){
        color = RGBACOLOR(231, 182, 47, 1);
    }else{
        color = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1];
    }
    NSDictionary*attribute = @{NSFontAttributeName:_font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName :color};
    if (_needFlow == YES)
    {
//        NSLog(@"OFFSETX:%f", _XOffset);
//        NSLog(@"textwidth:%f",_textSize.width);
        rect = [self moveNewPoint:CGPointMake(_XOffset, startYOffset) rect:rect];
//        NSLog(@"rect X:%f  Y:%f",rect.origin.x, rect.origin.y);
//        NSLog(@"rect W:%f  H:%f", rect.size.width, rect.size.height);
        while (rect.origin.x <= rect.size.width+rect.origin.x) 
        {
//            [_text drawInRect:rect withFont:_font];
            [_text drawInRect:rect withAttributes:attribute];
            rect = [self moveNewPoint:CGPointMake(rect.origin.x+_textSize.width+SPACE_WIDTH, rect.origin.y) rect:rect];
//            NSLog(@"inner->rect X:%f  Y:%f",rect.origin.x, rect.origin.y);
//            NSLog(@"inner->rect W:%f  H:%f", rect.size.width, rect.size.height);
        }
        
    }
    else
    {
        //在控件的中间绘制文本
        origin.x = 0;//(rect.size.width - _textSize.width)/2;
        origin.y = (rect.size.height - _textSize.height)/2;
        rect.origin = origin;
//        [_text drawInRect:rect withFont:_font];
       
        [_text drawInRect:rect withAttributes:attribute];
    }
}




#pragma mark -
#pragma mark 外部调用
- (void)setFont:(UIFont *)font
{
    _font = font;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];

}
@end
