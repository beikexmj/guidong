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

@implementation FileDownloadItem

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
        
        [self.progressView setHintAttributedGenerationBlock:^NSAttributedString *(CGFloat progress) {
            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.f%%", progress * 100]
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]}];
        }];
    }
    return self;
}

- (void)setItem:(NewsAttatchmentFormItem *)item
{
    _item = item;
    self.fileNameLabel.text = item.fileName;
    BOOL isExist = [CopoooDBManager searchDB:item.fileName type:FileTypePDF];
    self.downloadStateView.hidden = !isExist;
    [self switchOperationStateWithFileExist:isExist];
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
    [ZTHttpTool downloadWithURL:[NSString stringWithFormat:@"%@%@", DOWNLOAD_URL, self.item.download]
                     targetPath:[self filePathWithName:self.item.fileName]
                         params:nil
                       progress:^(float progress) {
                           __strong typeof(weakSelf) strongSelf = weakSelf;
                           [strongSelf.progressView setProgress:progress animated:YES];
                       }
              completionHandler:^(NSString * _Nullable filePath, NSError * _Nullable error) {
                  __strong typeof(weakSelf) strongSelf = weakSelf;
                  strongSelf.isDownloading = NO;
                  strongSelf.operationButton.hidden = NO;
                  strongSelf.progressView.hidden = YES;
                  if (filePath && !error) {
                      [strongSelf switchOperationStateWithFileExist:YES];
                      strongSelf.downloadStateView.hidden = NO;
                      [strongSelf saveToDatabaseWithPath:filePath];
                  } else {
                      [strongSelf switchOperationStateWithFileExist:NO];
                      strongSelf.downloadStateView.hidden = YES;
                  }
              }];
}

- (void)saveToDatabaseWithPath:(NSString *)filePath
{
    CopoooDBDataModel *model = [[CopoooDBDataModel alloc] init];
    model.userId = [StorageUserInfromation storageUserInformation].userId;
    model.name = self.item.fileName;
    model.time = [[NSDate date] timeIntervalSince1970];
    model.type = FileTypePDF;
    [CopoooDBManager saveDB:model];
}

- (IBAction)onAction:(id)sender {
    self.operationButton.hidden = YES;
    self.progressView.hidden = NO;
    [self startDownload];
}


@end
