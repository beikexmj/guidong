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
#import "ProtalHomePageClassDataModel.h"
#import "UpdateCheckDataModel.h"
@interface PortalHomePageViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong)NSArray<ProtalHomePageClassFormList *> *data;
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
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        // 移除之前所有子控制器
//        [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
//
//        // 把对应标题保存到控制器中，并且成为子控制器，才能刷新
//        // 添加所有新的子控制器
//        [self setUpAllViewController];
//
//        self.selectIndex = 0;
//
//        // 注意：必须先确定子控制器
//        [self refreshDisplay];
//
//    });
    
    [self fetchData];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.comfromFlag == 3 &&[StorageUserInfromation storageUserInformation].token) {
        delegate.comfromFlag = 4;
        ServiceAndNoticeViewController *page = [[ServiceAndNoticeViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
    [self cheakUpdateApp];
    // Do any additional setup after loading the view from its nib.
}
- (void)cheakUpdateApp{
    [ZTHttpTool postWithUrl:@"anonymous/checkUpdate4IOS" param:@{} success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        UpdateCheckDataModel *data = [UpdateCheckDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            // app版本
            NSString *app_Version = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *versionName = [data.form.iosVersionName stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (versionName.integerValue > app_Version.integerValue) {
                if (data.form.iosUpdate == 1) {//可选择更新
                    UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"版本更新" message:data.form.message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 10;
                    [alert show];
                }else if (data.form.iosUpdate == 2){//强制更新
                    UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"版本更新" message:data.form.message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 20;
                    [alert show];
                  
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E6%A1%82%E4%B8%9C%E7%94%B5%E5%8A%9B%E5%B1%85%E5%AE%B6%E5%90%88/id1360103858?mt=8"]];
        }
    }else if (alertView.tag == 20){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E6%A1%82%E4%B8%9C%E7%94%B5%E5%8A%9B%E5%B1%85%E5%AE%B6%E5%90%88/id1360103858?mt=8"]];
    }
}
// 添加所有子控制器
- (void)setUpAllViewController
{
    for (int i = 0; i<_data.count; i++) {
        ProtalHomePageSubVC *wordVc1 = [[ProtalHomePageSubVC alloc] init];
        wordVc1.newsType = _data[i].code.integerValue;
        wordVc1.title = _data[i].name;
        [self addChildViewController:wordVc1];
    }
}
- (void)fetchData{
    NSString *url = @"news/getNewsType";
   
    [ZTHttpTool postWithUrl:url param:@{} success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ProtalHomePageClassDataModel *data = [ProtalHomePageClassDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _data = data.form.list;
            if (_data.count) {
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
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
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
