//
//  AppDelegate.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/15.
//  Copyright © 2016年 夏明江. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "HomePageViewController.h"
#import "EBForeNotification.h"
#import "LaunchIntroductionView.h"
//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//以下是ShareSDK必须添加的依赖库：
//1、libicucore.dylib
//2、libz.dylib
//3、libstdc++.dylib
//4、JavaScriptCore.framework

//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//以下是新浪微博SDK的依赖库：
//ImageIO.framework
//libsqlite3.dylib
//AdSupport.framework
#import "ServiceAndNoticeViewController.h"
#import "UIView+MJExtension.h"
@interface AppDelegate ()<JPUSHRegisterDelegate,WXApiDelegate>{
    UIBackgroundTaskIdentifier _bgTask;
    NSString *_registrationID;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.comfromFlag = 5;
    self.window.rootViewController = mainStoryboard.instantiateInitialViewController;
    
    [self.window makeKeyAndVisible];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    SDWebImageDownloader *sdmanager = [SDWebImageManager sharedManager].imageDownloader;
    [sdmanager setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sdmanager setValue:@"zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4" forHTTPHeaderField:@"Accept-Language"];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            _registrationID = registrationID;
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [JPUSHService crashLogON];
//    [JPUSHService setDebugMode];
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformSubTypeQQFriend),
                                        
                                        ]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                                         [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [ShareSDKConnector connectQQ:[QQApiInterface class]
                                                    tencentOAuthClass:[TencentOAuth class]];
                                         break;
                                     case SSDKPlatformTypeSinaWeibo:
                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                         break;
                                         
                                     default:
                                         break;
                                 }
                             }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                          
                          switch (platformType)
                          {
                              case SSDKPlatformTypeSinaWeibo:
                                  //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                  [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                            appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                                          redirectUri:@"http://www.sharesdk.cn"
                                                             authType:SSDKAuthTypeBoth];
                                  break;
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                                        appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                                  break;
                              case SSDKPlatformTypeQQ:
                                  [appInfo SSDKSetupQQByAppId:@"100371282"
                                                       appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                                     authType:SSDKAuthTypeBoth];
                                  break;
                                  
                                  
                                  
                                  
                              default:
                                  break;
                          }
                      }];
    

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        
        NSDate *lastModifiedDate = nil;
        
        if (fileAttr.count > 0) {
            if (fileAttr.count > 0) {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
            
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        
        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        
        return mutableHeaders;
    };
    [WXApi registerApp:@"wxbe76f795c324c785"];

//    [LaunchIntroductionView sharedWithImages:@[@"引导页1",@"引导页2",@"引导页3"]];
    [LaunchIntroductionView sharedWithStoryboardName:@"Main" images:@[@"引导页1",@"引导页2",@"引导页3"]];
    [self networkStateChange];
    
    return YES;
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:YES];
    }else{
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
    }
    
    NSLog(@"收到自定义消息:%@", [self logDic:userInfo]);

    [HomePageViewController addNotificationCount];

    
}

- (void)networkStateChange{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                [MBProgressHUD showError:@"无网络连接"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // Synchronize the cleanup call on the main thread in case
        // the task actually finishes at around the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_bgTask != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:_bgTask];
                _bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 获取当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    
    // iOS 8 系统要求设置通知的时候必须经过用户许可。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    [app registerUserNotificationSettings:settings];
    
    // 设置应用程序右上角的"通知图标"Badge
    app.applicationIconBadgeNumber = 0;  // 根据逻辑设置
    [JPUSHService resetBadge];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.comfromFlag == 3 && [StorageUserInfromation storageUserInformation].token) {
        delegate.comfromFlag = 4;
        ServiceAndNoticeViewController *page = [[ServiceAndNoticeViewController alloc]init];
        [self.window.currentViewController.navigationController pushViewController:page animated:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //没有值就代表去除
  //  [JPUSHService setTags:[NSSet set]callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    //[JPUSHService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
   // NSLog(@"%d %s",__LINE__,__PRETTY_FUNCTION__);
   // [self setAliasAndTags];
    [self saveContext];
    
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "abc.HomeElectricTreasure" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HomeElectricTreasure" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HomeElectricTreasure.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [MBProgressHUD hideHUD];
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                NSUserDefaults * defaut = [NSUserDefaults standardUserDefaults];
                if ([[defaut valueForKey:@"comfromFlag"] integerValue] != 0) {
                    [StorageUserInfromation storageUserInformation].accountBalance = [NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[[defaut valueForKey:@"moneyStr"] floatValue]-[[defaut valueForKey:@"rechargeValue"] floatValue]];
                }else{
                    [StorageUserInfromation storageUserInformation].accountBalance =[NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[[defaut valueForKey:@"moneyStr"] floatValue]];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
                [MBProgressHUD showSuccess:@"支付成功！"];

            }else{
                [MBProgressHUD showError:@"支付失败！"];
            }

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
    
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [MBProgressHUD hideHUD];
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                NSUserDefaults * defaut = [NSUserDefaults standardUserDefaults];
                if ([[defaut valueForKey:@"comfromFlag"] integerValue] == 1||[[defaut valueForKey:@"comfromFlag"] integerValue] == 2) {
                    [StorageUserInfromation storageUserInformation].accountBalance = [NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[[defaut valueForKey:@"moneyStr"] floatValue]-[[defaut valueForKey:@"rechargeValue"] floatValue]];
                }else{
                    [StorageUserInfromation storageUserInformation].accountBalance =[NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[[defaut valueForKey:@"moneyStr"] floatValue]];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
                [MBProgressHUD showSuccess:@"支付成功！"];
                
            }else{
                [MBProgressHUD showError:@"支付失败！"];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }else{
        return  [WXApi handleOpenURL:url delegate:self];
    }
}
//前面的两个方法被iOS9弃用了，如果是Xcode7.2网上的话会出现无法进入进入微信的onResp回调方法，就是这个原因。本来我是不想写着两个旧方法的，但是一看官方的demo上写的这两个，我就也写了。。。。

//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}


//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSLog(@"%@",payResoult);
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
            {
//                NSUserDefaults * defaut = [NSUserDefaults standardUserDefaults];
//                if ([[defaut valueForKey:@"comfromFlag"] integerValue] == 1||[[defaut valueForKey:@"comfromFlag"] integerValue] == 2) {
//                    [StorageUserInfromation storageUserInformation].accountBalance = [NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[[defaut valueForKey:@"moneyStr"] floatValue]-[[defaut valueForKey:@"rechargeValue"] floatValue]];
//                }else{
//                    [StorageUserInfromation storageUserInformation].accountBalance =[NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[[defaut valueForKey:@"moneyStr"] floatValue]];
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];

                payResoult = @"支付结果：成功！";

            }
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
    NSLog(@"%@",payResoult);
    [MBProgressHUD showSuccess:payResoult];
    if (resp.errCode != 0) {
        [self cancelOrder];
    }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinPaySuccess" object:nil];

    }
}
- (void)cancelOrder{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"payLogId":[[NSUserDefaults standardUserDefaults] valueForKey:@"payLogId"]};
    [ZTHttpTool postWithUrl:@"postPayBill/cancelPay" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    rootViewController.deviceTokenValueLabel.text =
//    [NSString stringWithFormat:@"%@", deviceToken];
//    rootViewController.deviceTokenValueLabel.textColor =
//    [UIColor colorWithRed:0.0 / 255
//                    green:122.0 / 255
//                     blue:255.0 / 255
//                    alpha:1];
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//        [HomePageViewController addNotificationCount];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//        
//        [HomePageViewController addNotificationCount];
//        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [HomePageViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



@end
