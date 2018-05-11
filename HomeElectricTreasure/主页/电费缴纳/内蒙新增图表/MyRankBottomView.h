//
//  MyRankBottomView.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/10.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRankBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *avarageDistrictAndCountyElectUse;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthDistrictAndCountyRank;
@property (weak, nonatomic) IBOutlet UILabel *districtAndCountyBestRank;
@property (weak, nonatomic) IBOutlet UILabel *avaragerProvincesAndCitiesElectUse;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthProvincesAndCitiesRank;
@property (weak, nonatomic) IBOutlet UILabel *provincesAndCitiesBestRank;

@end
