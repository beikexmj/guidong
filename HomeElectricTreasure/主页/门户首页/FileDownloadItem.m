//
//  FileDownloadItem.m
//  copooo
//
//  Created by kerwin on 2018/6/27.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import "FileDownloadItem.h"

@implementation FileDownloadItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FileDownloadItem class])
                                         owner:self
                                       options:nil].lastObject;
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (IBAction)onAction:(id)sender {
    
}


@end
