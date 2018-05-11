//
//  SignView.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/9.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarView.h"

@interface SignView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *signDay;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIButton *sevenDayGiftBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifteenGiftBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirtyGiftBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signViewHight;
@property (nonatomic,strong)YXCalendarView *calendar;
- (void)setDataArry:(NSArray *)dataArray;
@end
