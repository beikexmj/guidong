//
//  MyRankingViewController.h
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/10.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRankingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *eleNum;
@property (weak, nonatomic) IBOutlet UIView *rankView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankLabelWidth;
@property (nonatomic,strong)NSString *accountNo;
@property (nonatomic,strong)NSString *cardType;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)shareBtnClick:(id)sender;
@end
