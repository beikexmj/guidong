//
//  CopoooDBDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/6/26.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger FileTypePDF;
extern NSInteger FileTypeImage;
extern NSInteger FileTypeVideo;

@interface CopoooDBDataModel : NSObject
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)long long time;
@property (nonatomic,assign)NSInteger type;//1 ==pdf 2 == 图片 3 == 视频
@end
