//
//  AppDelegate.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/15.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
static NSString *appKey = @"b48a442d29524a7469822db9";
static NSString *channel = @"guidong_push_distribution";//@"push_develop";
static BOOL isProduction = YES;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,assign)NSInteger comfromFlag; //==1登陆来自电卡 ；  == 2登陆来自个人中心 ==3登录来自推送消息 ==4登录来自退出（跳转到首页） == 5 其他
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

