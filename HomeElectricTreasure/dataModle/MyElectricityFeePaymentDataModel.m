//
//  qqqqq.m
//  Magic
//
//  Created by 夏明江 on 16/11/1.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "MyElectricityFeePaymentDataModel.h"

@implementation MyElectricityFeePaymentDataModel


+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [Data class]};
}
@end
@implementation Data

+ (NSDictionary *)objectClassInArray{
    return @{@"detail" : [Detail class]};
}
-(void)setBalance:(NSString *)balance{
    _balance = [NSString stringWithFormat:@"%0.2f",[balance floatValue]];
}

@end


@implementation Detail

@end


@implementation Index

@end


@implementation Year

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MonthList class]};
}

@end


@implementation MonthList
-(void)setElecNumber:(NSString*)elecNumber{
    _elecNumber = [NSString stringWithFormat:@"%0.2f",[elecNumber floatValue]];
}

@end


@implementation Month

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [DayList class]};
}

@end


@implementation DayList
-(void)setElecNumber:(NSString*)elecNumber{
    _elecNumber = [NSString stringWithFormat:@"%0.2f",[elecNumber floatValue]];
}

@end


