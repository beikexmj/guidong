//
//  ElectricUserRankingDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ElectricUserRankingForm,RankCity,RankCounty;

@interface ElectricUserRankingDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ElectricUserRankingForm *form;

@end

@interface ElectricUserRankingForm : NSObject

@property (nonatomic, copy)NSString *rank;

@property (nonatomic, strong) NSString *total;

@property (nonatomic, strong) RankCity *rankCity;

@property (nonatomic, strong) RankCounty *rankCounty;

@end

@interface RankCity : NSObject

@property (nonatomic, copy)NSString *avg;

@property (nonatomic, copy) NSString *cityRank;

@property (nonatomic, copy) NSString *minRank;

@end

@interface RankCounty : NSObject

@property (nonatomic, copy)NSString *avg;

@property (nonatomic, copy) NSString *countyRank;

@property (nonatomic, copy) NSString *minRank;

@end
