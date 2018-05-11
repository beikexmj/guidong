//
//  ServiceAndNoticeDetailView.h
//  copooo
//
//  Created by 夏明江 on 2016/11/9.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceAndNoticeDetailView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHight;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
