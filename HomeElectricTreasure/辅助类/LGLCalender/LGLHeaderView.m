//
//  LGLHeaderView.m
//  LGLProgress
//
//  Created by 李国良 on 2016/10/11.
//  Copyright © 2016年 李国良. All rights reserved.
//  https://github.com/liguoliangiOS/LGLCalender.git

#import "LGLHeaderView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define LGLColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@implementation LGLHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dateL = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, WIDTH-130, frame.size.height)];
        self.dateL.textAlignment = NSTextAlignmentLeft;
        self.dateL.textColor = [UIColor blackColor];
        self.dateL.font = [UIFont systemFontOfSize:13];
//        self.dateL.backgroundColor = LGLColor(236, 236, 236);
        [self addSubview:self.dateL];
        
        UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 120, 30, 60, 30)];
        [button1 setTitle:@" 用电量" forState:UIControlStateNormal];
        [button1.titleLabel setFont: [UIFont systemFontOfSize:13.0]];
        [button1 setTitleColor:[UIColor colorWithRed:0/255.0 green:167/255.0 blue:255/255.0 alpha:1.0]  forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"home_list_icon_electric"] forState:UIControlStateNormal];
        
        UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 60, 30, 60, 30)];
        [button2 setTitle:@" 电费" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button2.titleLabel setFont: [UIFont systemFontOfSize:13.0]];
        [button2 setImage:[UIImage imageNamed:@"home_list_icon_money"] forState:UIControlStateNormal];
        
        [self addSubview:button1];
        [self addSubview:button2];
        
    }
    return self;
}


@end
