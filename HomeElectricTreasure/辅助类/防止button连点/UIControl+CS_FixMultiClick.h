//
//  UIControl+CS_FixMultiClick.h
//  copooo
//
//  Created by XiaMingjiang on 2017/9/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (CS_FixMultiClick)
@property (nonatomic, assign) NSTimeInterval cs_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval cs_acceptEventTime;

@end
