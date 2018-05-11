//
//  HomePageViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UITabBarController
@property (weak, nonatomic) IBOutlet UITabBar *myTabBar;
+ (HomePageViewController *)homePageViewController;
+(void)addNotificationCount;
@end
