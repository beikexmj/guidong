//
//  ServiceAndNoticeDataModle.m
//  copooo
//
//  Created by 夏明江 on 16/9/18.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ServiceAndNoticeDataModle.h"

@implementation ServiceAndNoticeDataModle

@end


@implementation ServiceAndNoticeForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [List class]};
}
@end


@implementation List
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end


