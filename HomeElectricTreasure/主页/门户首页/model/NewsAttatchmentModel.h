//
//  NewsAttatchmentModel.h
//  copooo
//
//  Created by kerwin on 2018/6/29.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsAttatchmentForm, NewsAttatchmentFormItem;
@interface NewsAttatchmentModel : NSObject

@property (nonatomic) NSInteger rcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NewsAttatchmentForm *form;

@end

@interface NewsAttatchmentForm : NSObject

@property (nonatomic, strong) NSArray<NewsAttatchmentFormItem *> *list;

@end

@interface NewsAttatchmentFormItem : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *fileSize;

@end
