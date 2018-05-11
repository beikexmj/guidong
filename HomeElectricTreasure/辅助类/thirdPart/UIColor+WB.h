//
//  UIColor+WB.h
//  Picasso
//
//  Created by 张玲玉 on 15/6/11.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WB)

/**
 *  16进制颜色值字符转换算
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
/**
 *  色值转换成UIColor
 *  @param hexColor:16进制色值
 *  @return UIColor类型
 */
+ (UIColor *)colorWithHex:(long)hexColor;
/**
 *  色值转换成UIColor
 *  @param hexColor:16进制色值
 *  @param opacity:颜色的透明度0~1
 *  @return UIColor类型
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
@end
