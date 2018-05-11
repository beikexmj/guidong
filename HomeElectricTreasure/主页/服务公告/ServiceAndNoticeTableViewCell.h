//
//  ServiceAndNoticeTableViewCell.h
//  copooo
//
//  Created by 夏明江 on 16/9/13.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceAndNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *isReadFlag;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
