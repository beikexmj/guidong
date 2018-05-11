//
//  NewElectricityFeePaymentDisplayUpCollectionViewCell.h
//  copooo
//
//  Created by 夏明江 on 2017/2/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewElectricityFeePaymentDisplayUpCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *monthElecFee;
@property (weak, nonatomic) IBOutlet UILabel *monthElecNum;
@property (weak, nonatomic) IBOutlet UILabel *elecFee;
@property (weak, nonatomic) IBOutlet UILabel *elecNum;
@property (weak, nonatomic) IBOutlet UIView *elecFeeAndElectNumView;
@property (weak, nonatomic) IBOutlet UIImageView *yearBackGuandView;
@property (weak, nonatomic) IBOutlet UIView *noBillView;
@property (weak, nonatomic) IBOutlet UILabel *noBillName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *electFeeToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *electNumToTop;


@end
