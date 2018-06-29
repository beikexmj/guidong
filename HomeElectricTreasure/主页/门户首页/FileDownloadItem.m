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
        [self.operationButton setTitle:nil forState:UIControlStateNormal];
        [self.operationButton setImage:[UIImage imageNamed:@"news_icon_download"] forState:UIControlStateNormal];
        [self.operationButton setTitle:@"去查看" forState:UIControlStateSelected];
        [self.operationButton setImage:nil forState:UIControlStateSelected];
        self.operationButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.progressView setHintAttributedGenerationBlock:^NSAttributedString *(CGFloat progress) {
            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%", progress * 100]
                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]}];
        }];
    }
    return self;
}

- (void)setItem:(NewsAttatchmentFormItem *)item
{
    _item = item;
    self.fileNameLabel.text = item.fileName;
    BOOL isExist = [CopoooDBManager searchDB:[self filePathWithName:item.fileName] type:FileTypePDF];
    self.downloadStateView.hidden = !isExist;
    self.operationButton.selected = isExist;
}

- (NSString *)filePathWithName:(NSString *)name {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [documentPath stringByAppendingPathComponent:name];
}

- (void)startDownload
{
    __weak typeof(self) weakSelf = self;
    [ZTHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@", DOWNLOAD_URL, self.item.download]
                     param:nil
        myDownloadProgress:^(NSProgress *progress) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.progressView setProgress:progress.completedUnitCount / progress.totalUnitCount animated:YES];
        }
                   success:^(id responseObj) {
                       __strong typeof(weakSelf) strongSelf = weakSelf;
                       
                   }
                   failure:^(NSError *error) {
                       
                   }];
}

- (IBAction)onAction:(id)sender {
    self.operationButton.hidden = YES;
    self.progressView.hidden = NO;
    [self startDownload];
}


@end
