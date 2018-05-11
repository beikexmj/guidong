//
//  PGIndexBannerSubiew.m
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "PGIndexBannerSubiew.h"

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame dict:(ElectricityFeePaymentList *)eleFeePaymentDict index:(NSInteger)index {
    self = [super initWithFrame:frame];
    return self;
}
-(void)addviews:(ElectricityFeePaymentList *)eleFeePaymentDict index:(NSInteger)index{
    if ([self viewWithTag:100]) {
        return;
    }
    UIView *backImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH-60, SCREEN_HEIGHT -113-60)];
    backImageView2.backgroundColor = [UIColor clearColor];
    _efdfview = [[[NSBundle mainBundle] loadNibNamed:@"ElectricityFeeDisplayFrontView" owner:self options:nil] lastObject];
    _efdfview.frame = CGRectMake(0, 0,  SCREEN_WIDTH-60, SCREEN_HEIGHT -113-60);
    _efdfview.delegate= self;
//    [_efdfview addData:eleFeePaymentDict index:index];
    _efdbview = [[[NSBundle mainBundle] loadNibNamed:@"ElectricityFeeDisplayBackView" owner:self options:nil] lastObject];
    _efdbview.frame = CGRectMake(0, 0,  SCREEN_WIDTH-60, SCREEN_HEIGHT -113-60);
 //   [_efdbview addData:eleFeePaymentDict index:index];

    [backImageView2 addSubview:_efdfview];
    [backImageView2 insertSubview:_efdbview belowSubview:_efdfview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    _efdfview.layer.masksToBounds = YES;
    _efdfview.layer.cornerRadius = 10;
    _efdbview.layer.masksToBounds = YES;
    _efdbview.layer.cornerRadius = 10;
    backImageView2.userInteractionEnabled = YES;
    [backImageView2 addGestureRecognizer:tap];
    backImageView2.tag = 100;
    [self addSubview:backImageView2];
    
}


- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}
-(void)tapClick:(UITapGestureRecognizer*)tapView{
    UIView * myView = tapView.view;
    UIViewAnimationOptions option =  UIViewAnimationOptionTransitionFlipFromLeft;
    void (^update)(void) = ^ {
        // reload data
    };
    [UIView transitionWithView:myView
                      duration:0.5f
                       options:option
                    animations:^ {
                        [myView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                        
                    }
                    completion:^ (BOOL finished){
                        update();
                    }];
}
#pragma mark deleagte

-(void)payFeeBtnClickIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(payFeeBtnClickIndex:target:tag:)]) {
        [self.delegate payFeeBtnClickIndex:index target:self tag:self.tags];
    }

}

-(void)historyBillList{
    if ([self.delegate respondsToSelector:@selector(historyBillListTag:)]) {
        [self.delegate historyBillListTag:self.tags];
    }
}

@end
