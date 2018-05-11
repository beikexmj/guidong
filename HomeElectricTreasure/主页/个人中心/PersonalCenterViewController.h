//
//  PersonalCenterViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *banlance;


- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBackImageToTop;
- (IBAction)QRCodeBtnClick:(id)sender;


@end
