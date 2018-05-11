//
//  IntegralTableViewCell.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/2.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *integralImage;
@property (weak, nonatomic) IBOutlet UILabel *integralDescription;
@property (weak, nonatomic) IBOutlet UILabel *lackOfIntegration;
@property (weak, nonatomic) IBOutlet UIButton *changeIntegralBtn;

@end
