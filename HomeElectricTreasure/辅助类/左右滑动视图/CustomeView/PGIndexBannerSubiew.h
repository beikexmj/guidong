//
//  PGIndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>
#import "ElectricityFeeDisplayFrontView.h"
#import "ElectricityFeeDisplayBackView.h"
#import "ElectricityFeePaymentDataModel.h"
@class PGIndexBannerSubiew;
@protocol PGIndexBannerSubiewDelegate<NSObject>
-(void)historyBillListTag:(NSInteger)tag;
-(void)payFeeBtnClickIndex:(NSInteger)index target:(PGIndexBannerSubiew*)pgIndexView tag:(NSInteger)tag;
@end
@interface PGIndexBannerSubiew : UICollectionViewCell<ElectricityFeeDisplayFrontViewDelegate>
@property (nonatomic, strong) ElectricityFeePaymentList *eleFeePaymentDict;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic, assign) NSInteger tags;
/**
 *  标记
 */
/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) ElectricityFeeDisplayFrontView * efdfview;
@property (nonatomic, strong) ElectricityFeeDisplayBackView * efdbview;
@property (nonatomic,assign)id <PGIndexBannerSubiewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame dict:(ElectricityFeePaymentList*)eleFeePaymentDict index:(NSInteger)index;
-(void)addviews:(ElectricityFeePaymentList *)eleFeePaymentDict index:(NSInteger)index;

@end
