//
//  SignView.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/9.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "SignView.h"
@implementation SignView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    
    _signBtn.layer.cornerRadius = 5;
    _sevenDayGiftBtn.layer.cornerRadius = 5;
    _fifteenGiftBtn.layer.cornerRadius = 5;
    _thirtyGiftBtn.layer.cornerRadius = 5;
    _headerImg.layer.cornerRadius = 38;
    _headerImg.layer.masksToBounds = YES;
    CGFloat height = [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Month];
    _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height) Date:[NSDate date] Type:CalendarType_Month];
//    _signViewHight.constant = height+20;
    __weak typeof(_calendar) weakCalendar = _calendar;
    _calendar.refreshH = ^(CGFloat viewH) {
        [UIView animateWithDuration:0.3 animations:^{
            weakCalendar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewH);
        }];
        
    };
    _calendar.sendSelectDate = ^(NSDate *selDate) {
        NSLog(@"%@",[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]);
    };
    [self.signView addSubview:_calendar];
    

}

- (void)setDataArry:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in dataArray) {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate date]];
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%@",[comp1 year],[comp1 month],str];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *oncedate = [formate dateFromString:dateStr];
        if ([[YXDateHelpObject manager] isSameDate:oncedate AnotherDate:[NSDate date]]) {
            self.signBtn.backgroundColor = RGBCOLOR(156, 156, 156);
            self.signBtn.userInteractionEnabled = NO;
            [self.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        }
        [array addObject:oncedate];
    }
    _calendar.selectDateArray = array;
}

@end
