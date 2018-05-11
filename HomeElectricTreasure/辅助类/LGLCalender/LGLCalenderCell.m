//
//  LGLCalenderCell.m
//  LGLProgress
//
//  Created by 李国良 on 2016/10/11.
//  Copyright © 2016年 李国良. All rights reserved.
//  https://github.com/liguoliangiOS/LGLCalender.git

#import "LGLCalenderCell.h"
#import "UIView+Frame.h"
#define LGLColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@implementation LGLCalenderCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 5, self.width, 16)];
        self.dateL.textAlignment = NSTextAlignmentCenter;
        self.dateL.backgroundColor = [UIColor clearColor];
        self.dateL.font = [UIFont systemFontOfSize:14];
        
        self.electNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, self.width, 16)];
        self.electNum.textAlignment = NSTextAlignmentCenter;
        self.electNum.backgroundColor = [UIColor clearColor];
        self.electNum.textColor = [UIColor colorWithRed:0 green:167.0/255 blue:255.0/255 alpha:1];
        self.electNum.font = [UIFont systemFontOfSize:10];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.width, 16)];
        self.priceL.textAlignment = NSTextAlignmentCenter;
        self.priceL.backgroundColor = [UIColor clearColor];
        self.priceL.textColor = [UIColor colorWithRed:255.0/255 green:180.0/255 blue:0 alpha:1];
        self.priceL.font = [UIFont systemFontOfSize:10];
        
        [self addSubview:self.dateL];
        [self addSubview:self.priceL];
        [self addSubview:self.electNum];
    }
    return self;
}


@end
