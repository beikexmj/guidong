//
//  NoElectricityCardView.m
//  copooo
//
//  Created by 夏明江 on 16/9/14.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "NoElectricityCardView.h"

@implementation NoElectricityCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.addElecCard.layer.cornerRadius = 5;
    self.backImage1Constant.constant = (SCREEN_WIDTH-87*2)*59/201.0;
    self.backImage2Constant.constant =(SCREEN_WIDTH-100)*253/275.0;
    [self.addElecCard setBackgroundImage:[UIImage imageNamed:@"button1_2"] forState:UIControlStateNormal];
    [self.addElecCard setBackgroundImage:[UIImage imageNamed:@"button1_1"] forState:UIControlStateHighlighted];
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NoElectricityCardView" owner:self options:nil] lastObject];
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, [self frame].size.width, [self frame].size.height)]; // frame's width and height already determined after loadNibNamed was called
    }
    return self;
}
@end
