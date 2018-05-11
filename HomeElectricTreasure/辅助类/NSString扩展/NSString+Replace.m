//
//  NSString+Replace.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/15.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "NSString+Replace.h"

@implementation NSString (Repalce)
- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length {
    NSString *replaceStr = self;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}
@end
