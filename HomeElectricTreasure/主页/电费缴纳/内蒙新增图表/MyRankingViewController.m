//
//  MyRankingViewController.m
//  ChartDemo
//
//  Created by 夏明江 on 2017/7/10.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "MyRankingViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import "MyRankBottomView.h"
#import "ElectricUserRankingDataModel.h"
@interface MyRankingViewController ()
@property (nonatomic,strong)MyRankBottomView *myRankBottomView;
@property (nonatomic, strong) ElectricUserRankingForm *electricUserRankingForm;

@end

@implementation MyRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rankLabelWidth.constant = [self.rankLabel sizeThatFits:CGSizeMake(self.view.bounds.size.width - 31*2, 80)].width;
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-270)];
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 360);
    myScrollView.showsVerticalScrollIndicator = NO;
    _myRankBottomView = [[[NSBundle mainBundle] loadNibNamed:@"MyRankBottomView" owner:nil options:nil] lastObject];
    _myRankBottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 360);
    [myScrollView addSubview:_myRankBottomView];
    [_rankView addSubview:myScrollView];
    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
- (void)fetchData{
    [MBProgressHUD showMessage:@"数据加载中..."];
        NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"accountNo":_accountNo,@"type":[self.cardType integerValue] == 9?@"2":@"1"};
        [ZTHttpTool postWithUrl:@"user/electricUser/ranking" param:dict success:^(id responseObj) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",[responseObj mj_JSONObject]);
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSLog(@"%@",str);
            NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
            ElectricUserRankingDataModel * electricUserRanking = [ElectricUserRankingDataModel mj_objectWithKeyValues:str];
            if (electricUserRanking.rcode == 0) {
                _electricUserRankingForm = electricUserRanking.form;
                [self initViewFace];
            }else{
                [MBProgressHUD showError:electricUserRanking.msg];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"数据加载失败"];
        }];
}
- (void)initViewFace{
    _rankLabel.text = _electricUserRankingForm.rank;
    self.rankLabelWidth.constant = [self.rankLabel sizeThatFits:CGSizeMake(self.view.bounds.size.width - 31*2, 80)].width;
    if (_electricUserRankingForm.total) {
        _eleNum.text = _electricUserRankingForm.total;
        _myRankBottomView.avarageDistrictAndCountyElectUse.text = [NSString stringWithFormat:@"%@度",_electricUserRankingForm.rankCounty.avg ];
        _myRankBottomView.lastMonthDistrictAndCountyRank.text =[NSString stringWithFormat:@"%@名", _electricUserRankingForm.rankCounty.countyRank];
        _myRankBottomView.districtAndCountyBestRank.text = [NSString stringWithFormat:@"%@名", _electricUserRankingForm.rankCounty.minRank];
        
        _myRankBottomView.avaragerProvincesAndCitiesElectUse.text = [NSString stringWithFormat:@"%@度",_electricUserRankingForm.rankCity.avg];
        _myRankBottomView.lastMonthProvincesAndCitiesRank.text = [NSString stringWithFormat:@"%@名", _electricUserRankingForm.rankCity.cityRank];
        _myRankBottomView.provincesAndCitiesBestRank.text = [NSString stringWithFormat:@"%@名", _electricUserRankingForm.rankCity.minRank];
    }else{
        _eleNum.text = @"--";
        _myRankBottomView.avarageDistrictAndCountyElectUse.text = [NSString stringWithFormat:@"%@度",@"--" ];
        _myRankBottomView.lastMonthDistrictAndCountyRank.text = @"--名";
        _myRankBottomView.districtAndCountyBestRank.text = @"--名";
        
        _myRankBottomView.avaragerProvincesAndCitiesElectUse.text = [NSString stringWithFormat:@"%@度",@"--"];
        _myRankBottomView.lastMonthProvincesAndCitiesRank.text = @"--名";
        _myRankBottomView.provincesAndCitiesBestRank.text = @"--名";
    }
    
    
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareBtnClick:(id)sender {
    [self showShareActionSheet:self.view];
}
/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"];
    //    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    //    NSArray* imageArray = @[@"http://ww4.sinaimg.cn/bmiddle/005Q8xv4gw1evlkov50xuj30go0a6mz3.jpg",[UIImage imageNamed:@"shareImg.png"]];
    [shareParams SSDKSetupShareParamsByText:@"分享内容 http://www.mob.com"
                                     images:@"http://ww4.sinaimg.cn/bmiddle/005Q8xv4gw1evlkov50xuj30go0a6mz3.jpg"
                                        url:[NSURL URLWithString:@"http://www.mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    
//    //1.2、自定义分享平台（非必要）
//    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
//    //添加一个自定义的平台（非必要）
//    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
//                                                                                  label:@"自定义"
//                                                                                onClick:^{
//                                                                                    
//                                                                                    //自定义item被点击的处理逻辑
//                                                                                    NSLog(@"=== 自定义item被点击 ===");
//                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
//                                                                                                                                        message:nil
//                                                                                                                                       delegate:nil
//                                                                                                                              cancelButtonTitle:@"确定"
//                                                                                                                              otherButtonTitles:nil];
//                                                                                    [alertView show];
//                                                                                }];
//    [activePlatforms addObject:item];
    
    //设置分享菜单栏样式（非必要）
    //        [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
    //        [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //        [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //        [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    //        [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
    //        [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
    //        [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
    //        [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
    
//   NSArray * platforms =@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatSession)];
    //2、分享
    //    SSUIShareActionSheetController *sheet =
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin && state != SSDKResponseStateBeginUPLoad)
                   {
                   }
                   
               }];
    //设置 消息编辑UI中 不显示显示其他平台Icon
    //    sheet.noShowOtherPlatformOnEditorView = YES;
    
    //另附：设置跳过分享编辑页面，直接分享的平台。
    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
    //                                                                         items:nil
    //                                                                   shareParams:shareParams
    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    //                                                           }];
    //
    //        //删除和添加平台示例
    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}



@end
