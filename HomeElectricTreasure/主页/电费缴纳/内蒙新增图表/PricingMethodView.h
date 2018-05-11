//
//  PricingMethodView.h
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PricingMethodView : UIView
@property (weak, nonatomic) IBOutlet UILabel *sharpTime;
@property (weak, nonatomic) IBOutlet UILabel *sharpTimeSection;
@property (weak, nonatomic) IBOutlet UILabel *sharpTimeRate;
@property (weak, nonatomic) IBOutlet UILabel *sharpTimeMark;
@property (weak, nonatomic) IBOutlet UILabel *peakTime;
@property (weak, nonatomic) IBOutlet UILabel *peakTimeSection;
@property (weak, nonatomic) IBOutlet UILabel *peakTimeRate;
@property (weak, nonatomic) IBOutlet UILabel *peakTimeMark;
@property (weak, nonatomic) IBOutlet UILabel *peaceTime;
@property (weak, nonatomic) IBOutlet UILabel *peaceTimeSection;
@property (weak, nonatomic) IBOutlet UILabel *peaceTimeRate;
@property (weak, nonatomic) IBOutlet UILabel *peaceTimeMark;
@property (weak, nonatomic) IBOutlet UILabel *valleyTime;
@property (weak, nonatomic) IBOutlet UILabel *valleyTimeSection;
@property (weak, nonatomic) IBOutlet UILabel *valleyTimeRate;
@property (weak, nonatomic) IBOutlet UILabel *valleyTimeMark;
@property (weak, nonatomic) IBOutlet UILabel *firstStep;
@property (weak, nonatomic) IBOutlet UILabel *firstStepSection;
@property (weak, nonatomic) IBOutlet UILabel *firstStepElectricityPriceStandard;
@property (weak, nonatomic) IBOutlet UILabel *firstStepMark;
@property (weak, nonatomic) IBOutlet UILabel *secondStep;
@property (weak, nonatomic) IBOutlet UILabel *secondStepSection;
@property (weak, nonatomic) IBOutlet UILabel *secondStepElectricityPriceStandard;
@property (weak, nonatomic) IBOutlet UILabel *secondStepMark;
@property (weak, nonatomic) IBOutlet UILabel *thirdStep;
@property (weak, nonatomic) IBOutlet UILabel *thirdStepElectricityPriceStandard;
@property (weak, nonatomic) IBOutlet UILabel *thirdStepSection;
@property (weak, nonatomic) IBOutlet UILabel *thirdStepMark;

@end
