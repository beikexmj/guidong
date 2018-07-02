//
//  FileDownloadItem.h
//  copooo
//
//  Created by kerwin on 2018/6/27.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsAttatchmentModel.h"
#import "CircleProgressBar.h"

@interface FileDownloadItem : UIView

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet UIImageView *downloadStateView;
@property (nonatomic, strong) NewsAttatchmentFormItem *item;
@property (weak, nonatomic) IBOutlet CircleProgressBar *progressView;
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic) BOOL isDownloading;

@end
