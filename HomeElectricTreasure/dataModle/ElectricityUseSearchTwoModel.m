//
//  qqq.m
//  SubmitAPPStore
//
//  Created by 刘欣 on 16/11/3.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import "ElectricityUseSearchTwoModel.h"

@implementation ElectricityUseSearchTwoModel

@end

@implementation ElectricityUseSearchTwoForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ElectricityUseSearchTwoList class]};
}

@end
@implementation ElectricityUseSearchTwoList

+ (NSDictionary *)objectClassInArray{
    return @{@"detail" : [ElectricityUseSearchTwoDetail class]};
}

@end

@implementation ElectricityUseSearchTwoDetail

@end


