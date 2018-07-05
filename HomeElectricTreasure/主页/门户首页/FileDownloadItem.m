//
//  FileDownloadItem.m
//  copooo
//
//  Created by kerwin on 2018/6/27.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import "FileDownloadItem.h"
#import "CopoooDBManager.h"
#import "UIColor+WB.h"
#import "FileBrowserViewController.h"

@implementation FileDownloadItem
{
    BOOL _isExist;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FileDownloadItem class])
                                         owner:self
                                       options:nil].lastObject;
    if (self) {
        self.frame = frame;
        [self.operationButton setTitleColor:[UIColor colorWithHex:0xc0c0c0] forState:UIControlStateNormal];
        self.operationButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        self.progressView.hintTextFont = [UIFont systemFontOfSize:12];
        self.progressView.hintTextColor = RGBA(0x00a7ff, 1);
        self.progressView.progressBarTrackColor = [UIColor clearColor];
        self.progressView.progressBarProgressColor = RGBA(0x00a7ff, 1);
        self.progressView.hintHidden = NO;
        self.progressView.hintViewSpacing = 1.0;
        [self.progressView setHintTextGenerationBlock:^NSString *(CGFloat progress) {
            return [NSString stringWithFormat:@"%.f%%", progress * 100];
        }];
    }
    return self;
}

- (void)setItem:(NewsAttatchmentFormItem *)item
{
    _item = item;
    self.fileNameLabel.text = item.originName;
    _isExist = [CopoooDBManager searchDB:item.originName type:FileTypePDF];
    self.downloadStateView.hidden = !_isExist;
    [self switchOperationStateWithFileExist:_isExist];
}

- (NSString *)filePathWithName:(NSString *)name {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [documentPath stringByAppendingPathComponent:name];
}

- (void)switchOperationStateWithFileExist:(BOOL)isExist
{
    if (isExist) {
        [self.operationButton setTitle:@"去查看" forState:UIControlStateNormal];
        [self.operationButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self.operationButton setImage:[UIImage imageNamed:@"news_icon_download"] forState:UIControlStateNormal];
        [self.operationButton setTitle:nil forState:UIControlStateNormal];
    }
}

- (void)startDownload
{
    self.isDownloading = YES;
    __weak typeof(self) weakSelf = self;
    [ZTHttpTool downloadWithURL:[NSString stringWithFormat:@"%@%@", BASE_URL2, self.item.download]
                     targetPath:[self filePathWithName:self.item.originName]
                         params:nil
                       progress:^(float progress) {
                           __strong typeof(weakSelf) strongSelf = weakSelf;
                           dispatch_async(dispatch_get_main_queue(), ^{
                              [strongSelf.progressView setProgress:progress animated:NO];
                           });
                       }
              completionHandler:^(NSString * _Nullable filePath, NSError * _Nullable error) {
                  __strong typeof(weakSelf) strongSelf = weakSelf;
                  strongSelf.isDownloading = NO;
                  strongSelf.operationButton.hidden = NO;
                  strongSelf.progressView.hidden = YES;
                  if (filePath && !error) {
                      _isExist = YES;
                      [strongSelf switchOperationStateWithFileExist:YES];
                      strongSelf.downloadStateView.hidden = NO;
                      [strongSelf saveToDatabaseWithPath:filePath];
                  } else {
                      [strongSelf switchOperationStateWithFileExist:NO];
                      strongSelf.downloadStateView.hidden = YES;
                      [MBProgressHUD showError:@"下载失败，无网络连接"];
                  }
              }];
}

- (void)saveToDatabaseWithPath:(NSString *)filePath
{
    CopoooDBDataModel *model = [[CopoooDBDataModel alloc] init];
    model.userId = [StorageUserInfromation storageUserInformation].userId;
    model.name = self.item.originName;
    model.time = [[NSDate date] timeIntervalSince1970];
    model.type = FileTypePDF;
    [CopoooDBManager saveDB:model];
}

- (IBAction)onAction:(id)sender {
    if (_isExist) {
        FileBrowserViewController *vc = [[FileBrowserViewController alloc] init];
        vc.fileURL = [NSURL fileURLWithPath:[self filePathWithName:self.item.originName]];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else {
        self.operationButton.hidden = YES;
        self.progressView.hidden = NO;
        [self startDownload];
    }
}


@end
