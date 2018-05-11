//
//  HomePageViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "HomePageViewController.h"
//#import "ServiceAndNoticeViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "ElectricityFeePaymentViewController.h"
#import "ServiceAndNoticeViewController.h"
@interface HomePageViewController ()<UITabBarDelegate>

@end
@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self.myTabBar setSelectedImageTintColor:RGBCOLOR(0, 167, 255)];
    self.myTabBar.tintColor=RGBCOLOR(0, 167, 255);
    //设置选中时字体的颜色(也可更改字体大小)
    [_myTabBar.items[0] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(0, 167, 255)} forState:UIControlStateSelected];
    [_myTabBar.items[1] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(0, 167, 255)} forState:UIControlStateSelected];
    [_myTabBar.items[2] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(0, 167, 255)} forState:UIControlStateSelected];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (delegate.comfromFlag
        == 1) {
        self.selectedIndex = 1;
    }else if (delegate.comfromFlag
              == 2){
        self.selectedIndex = 2;
    }else if (delegate.comfromFlag == 3){
        self.selectedIndex = 0;
    }else{
        self.selectedIndex = 0;
    }
    
//    [self fetchData];
//    self.myTabBar.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 初始化数据（未读消息等）
-(void)fetchData{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"app/initApp" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            HomePageViewController *vc = [delegate.window.rootViewController childViewControllers][0];
            NSInteger unreadCount = [[DictToJson dictionaryWithJsonString:str][@"form"][@"unreadCount"] integerValue];
            if (unreadCount <= 0) {
                [vc.myTabBar items][1].badgeValue = nil;
                
            }else{
                if (unreadCount<=99) {
                    [vc.myTabBar items][1].badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
                }else{
                    [vc.myTabBar items][1].badgeValue = @"99+";
                }
            }
            
        }else{
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (HomePageViewController *)homePageViewController
{
    static HomePageViewController *sharedAccountManagerInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    
    return sharedAccountManagerInstance;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    if ([item isEqual:[tabBar items][1]]) {
//        item.badgeValue = nil;
//        i=0;
//    }
}
+(void)addNotificationCount{
    
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([[delegate.window.rootViewController childViewControllers][0] isKindOfClass:[HomePageViewController class]]) {
//        HomePageViewController *vc = [delegate.window.rootViewController childViewControllers][0];
//        if ([vc.myTabBar items][1].badgeValue) {
//            if ([[vc.myTabBar items][1].badgeValue isEqual:@"99+"]) {
//                i=100;
//            }else{
//                i = [[vc.myTabBar items][1].badgeValue intValue]+1;
//            }
//        }else{
//            i=1;
//        }
//        if (i<=99) {
//            [vc.myTabBar items][1].badgeValue = [NSString stringWithFormat:@"%d",i];
//        }else{
//            [vc.myTabBar items][1].badgeValue = @"99+";
//        }
//        
////        ServiceAndNoticeViewController *page = [vc viewControllers][1];
////        [page.myTableView.mj_header beginRefreshing];
//    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.comfromFlag = 3;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNotificationCount" object:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
