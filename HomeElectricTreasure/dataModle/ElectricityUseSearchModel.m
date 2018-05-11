//
//  qqq.m
//  SubmitAPPStore
//
//  Created by 刘欣 on 16/11/3.
//  Copyright © 2016年 刘欣. All rights reserved.
//

#import "ElectricityUseSearchModel.h"

@implementation ElectricityUseSearchModel


+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [ElectricityUseSearchForm class]};
}
@end
@implementation ElectricityUseSearchForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ElectricityUseSearchList class]};
}

@end


@implementation ElectricityUseSearchList

@end


