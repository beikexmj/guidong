//
//  PortalHomePageViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "PortalHomePageViewController.h"
#import "AppDelegate.h"
#import "ServiceAndNoticeViewController.h"
#import "ProtalHomePageSubVC.h"
@interface PortalHomePageViewController ()



@end

@implementation PortalHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        [_navTitle.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    }
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *titleScrollViewColor = RGBA(0x00a7ff, 1);
    }];
    /*  设置标题渐变：标题填充模式 */
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        // 标题填充模式
        *titleColorGradientStyle = YZTitleColorGradientStyleFill;
        *norColor = RGBA(0xffffff, 0.7);
        *selColor = RGBA(0xffffff, 1);
    }];
    
    [self setUpTitleScale:^(CGFloat *titleScale) {
        *titleScale = 1.2;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 移除之前所有子控制器
        [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
        
        // 把对应标题保存到控制器中，并且成为子控制器，才能刷新
        // 添加所有新的子控制器
        [self setUpAllViewController];
        
        self.selectIndex = 0;
        
        // 注意：必须先确定子控制器
        [self refreshDisplay];
        
    });
    
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.comfromFlag == 3 &&[StorageUserInfromation storageUserInformation].token) {
        delegate.comfromFlag = 4;
        ServiceAndNoticeViewController *page = [[ServiceAndNoticeViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
    
    // Do any additional setup after loading the view from its nib.
}
// 添加所有子控制器
- (void)setUpAllViewController
{
    for (int i = 0; i<3; i++) {
        ProtalHomePageSubVC *wordVc1 = [[ProtalHomePageSubVC alloc] init];
        wordVc1.newsType = i;
        wordVc1.title = @[@"桂东新闻",@"电价法规",@"公共新闻"][i];
        [self addChildViewController:wordVc1];
    }
}
//- (void)fetchData{
//    NSString *url = @"property/headlineHome/HeadlineTypeList";
//   
//    [ZTHttpTool postWithUrl:url param:@{} success:^(id responseObj) {
//        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
//        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
//        ProtalHomePageDataModel *protalData = [ProtalHomePageDataModel mj_objectWithKeyValues:str];
//        if (data.rcode == 0) {
//            _headerTitleArr = data.data;
//            if (_headerTitleArr.count) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    // 移除之前所有子控制器
//                    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
//                    
//                    // 把对应标题保存到控制器中，并且成为子控制器，才能刷新
//                    // 添加所有新的子控制器
//                    [self setUpAllViewController];
//                    
//                    self.selectIndex = 0;
//                    
//                    // 注意：必须先确定子控制器
//                    [self refreshDisplay];
//                    
//                });
//            }
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
