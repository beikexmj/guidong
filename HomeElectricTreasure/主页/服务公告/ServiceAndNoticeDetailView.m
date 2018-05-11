//
//  ServiceAndNoticeDetailView.m
//  copooo
//
//  Created by 夏明江 on 2016/11/9.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "ServiceAndNoticeDetailView.h"

@implementation ServiceAndNoticeDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.type.layer.cornerRadius = 5;
    self.type.layer.masksToBounds = YES;

}
@end
