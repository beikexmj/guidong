//
//  UpdateCheckDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/7/10.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UpdateCheckDataForm;
@interface UpdateCheckDataModel : NSObject
@property (nonatomic) NSInteger rcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) UpdateCheckDataForm *form;
@end
@interface UpdateCheckDataForm : NSObject
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *downUrl;
@property (nonatomic, assign) NSInteger iosUpdate;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger versionCode;
@property (nonatomic, copy) NSString *iosVersionName;

@end
