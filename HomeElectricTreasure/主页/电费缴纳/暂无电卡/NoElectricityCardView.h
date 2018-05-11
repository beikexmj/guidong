//
//  NoElectricityCardView.h
//  copooo
//
//  Created by 夏明江 on 16/9/14.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoElectricityCardView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addElecCard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImage1Constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImage2Constant;
- (id)initWithFrame:(CGRect)frame;
@end
