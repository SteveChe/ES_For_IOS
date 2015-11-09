//
//  AppDelegate.m
//  MyRill
//
//  Created by Siyuan Wang on 15/5/24.
//
//
#import <RongIMLib/RongIMLib.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ESMenuViewController.h"
#import "ESNavigationController.h"
#import "APService.h"
#import "ESPushManager.h"
#import "AFHttpTool.h"
#import "PushDefine.h"
#import "ESUserDetailInfo.h"
#import "ChatViewController.h"

//#define RONGCLOUD_IM_APPKEY @"x18ywvqf8hzqc" //online key
#define RONGCLOUD_IM_APPKEY @"x4vkb1qpvr9qk" //online key


#define kDeviceToken @"RongCloud_SDK_DeviceToken"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *_deviceTokenCache = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
     
    //初始化融云SDK，
//    [[RCIM sharedRCIM ]initWithAppKey:RONGCLOUD_IM_APPKEY deviceToken:_deviceTokenCache];
    [[RCIM sharedRCIM ]initWithAppKey:RONGCLOUD_IM_APPKEY ];

    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    [self initRootWindow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:RCKitDispatchMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveErrorMessage:)
                                                 name:@"NOTIFICATION_ERROR_MESSAGE"
                                               object:nil];
    
    //----------push-------------
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0)
    {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    NSDictionary *userInfo =[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"userInfo = %@",userInfo);
    return YES;
}

- (void)initRootWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController* rootViewCtrl = nil;
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        BOOL bLogined = FALSE;
        for (cookie in cookies) {
            if ([cookie.name  isEqual: @"sessionid"] )
            {
                if([cookie.value length])
                    bLogined = TRUE;
            }
        }
        if (bLogined){
            rootViewCtrl = [[ESMenuViewController alloc] init];
        }
        else{
            rootViewCtrl = [[LoginViewController alloc] init];
        }
    }
    else{
        rootViewCtrl = [[LoginViewController alloc] init];
    }
    if ([rootViewCtrl isKindOfClass:[LoginViewController class]]) {
        ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:rootViewCtrl];
        self.window.rootViewController = nav;
    } else {
        self.window.rootViewController = rootViewCtrl;
    }
    
    [self.window makeKeyAndVisible];

}

- (void)changeWindow:(UIViewController *)sender {

    if ([sender isKindOfClass:[LoginViewController class]])
    {
        [UIView transitionFromView:self.window.rootViewController.view
                            toView:sender.view
                          duration:1
                           options:UIViewAnimationOptionTransitionCurlUp
                        completion:^(BOOL finished)
         {
             self.window.rootViewController = sender;
         }];
    }
    else
    {
        self.window.rootViewController = sender;
    }

    [self.window makeKeyAndVisible];
}

//打印crash的栈信息
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;
    [APService setBadge:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENTER_FOREGROUD object:nil];
    
    NSLog(@"applicationDidBecomeActive");

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push Method

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", token]);
    [APService registerDeviceToken:deviceToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userInfo= %@",userInfo);

    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    NSLog(@"userInfo= %@",notification);
    NSDictionary* locDic = notification.userInfo;
    if (locDic != nil )
    {
        NSDictionary* rcDic = [locDic objectForKey:@"rc"];
        if (rcDic != nil)
        {
            ESMenuViewController* rootViewCtrl = (ESMenuViewController*)self.window.rootViewController;
            [rootViewCtrl.navigationController popToRootViewControllerAnimated:NO];
            [rootViewCtrl setSelectedIndex:1];
            
        }
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"userInfo= %@",userInfo);
    [ESPushManager parsePushJsonDic:userInfo applicationState:application.applicationState];

    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
    
    [APService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
//    ESMenuViewController* rootViewCtrl = (ESMenuViewController*)self.window.rootViewController;
//    if ([rootViewCtrl.tabBarController isKindOfClass:[ESMenuViewController class]])
//    {
//        [rootViewCtrl setSelectedIndex:1];
//
//    }
//    else
//    {
//        [rootViewCtrl setSelectedIndex:1];
//    }
}

-(void)didReceiveErrorMessage:(id)notification
{
    NSString* errorMessage = [notification object];
    if (errorMessage == nil || [errorMessage isEqual:[NSNull null]] ||
        [errorMessage length] <= 0)
    {
        return;
    }
    if ([errorMessage isEqualToString:@"403"])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        loginVC.eStatus = e_login_status_invalid;
        ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:loginVC];
        [self changeWindow:nav];
    }
}



#pragma mark -- RCIMUserInfoDataSource
// 获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    if (userId == nil || [userId isEqual:[NSNull null]] || [userId length]<=0)
    {
        return;
    }
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
    //    ESUserInfo* userInfo = [[UserInfoDataSource shareInstance] getUserByUserId:userId];
    //    if(userInfo == nil || [userInfo isEqual:[NSNull null]])
    //    {
    //        completionHandler = completion;
    //        [_getContactDetailDataParse getContactDetail:userId];
    //        _nUserDetailRequestNum ++ ;
    //    }
    //    else
    //    {
    //        RCUserInfo *user = [[RCUserInfo alloc]init];
    //        user.userId = userInfo.userId;
    //        user.name = userInfo.userName;
    //        user.portraitUri = userInfo.portraitUri;
    //        return completion(user);
    //    }
    
    [AFHttpTool getContactDetail:userId success:^(id response)
     {
         NSDictionary* reponseDic = (NSDictionary*)response;
         NSNumber* errorCodeNum = [reponseDic valueForKey:@"errorCode"];
         if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
         {
             return ;
         }
         int errorCode = [errorCodeNum intValue];
         switch (errorCode)
         {
             case 0:
             {
                 NSDictionary* temDic = [reponseDic valueForKey:@"data"];
                 if (temDic == nil || [temDic isEqual:[NSNull null]])
                 {
                     break;
                 }
                 
                 ESUserDetailInfo* userDetailInfo = [[ESUserDetailInfo alloc] init];
                 NSNumber* userId = [temDic valueForKey:@"id"];
                 if (userId != nil && ![userId isEqual:[NSNull null]])
                 {
                     userDetailInfo.userId = [NSString stringWithFormat:@"%d",[userId intValue]];
                 }
                 
                 NSString* userName = [temDic valueForKey:@"name"];
                 if (userName != nil && ![userName isEqual:[NSNull null]])
                 {
                     userDetailInfo.userName = userName;
                 }
                 
                 NSString* userDescription = [temDic valueForKey:@"description"];
                 if (userDescription != nil && ![userDescription isEqual:[NSNull null]])
                 {
                     userDetailInfo.contactDescription = userDescription;
                 }
                 
                 NSString* userPhoneNum = [temDic valueForKey:@"phone_number"];
                 if (userPhoneNum != nil && ![userPhoneNum isEqual:[NSNull null]])
                 {
                     userDetailInfo.phoneNumber = userPhoneNum;
                 }
                 NSDictionary* userEnterpriseDic = [temDic valueForKey:@"enterprise"];
                 if (userEnterpriseDic != nil && ![userEnterpriseDic isEqual:[NSNull null]] )//&& [userEnterpriseDic isKindOfClass:[NSDictionary class]]
                 {
                     ESEnterpriseInfo* userEnterprise = [[ESEnterpriseInfo alloc] init];
                     NSNumber* enterPriseIdNum = [userEnterpriseDic valueForKey:@"id"];
                     if (enterPriseIdNum!=nil && ![enterPriseIdNum isEqual:[NSNull null]]) {
                         userEnterprise.enterpriseId = [NSString stringWithFormat:@"%d",[enterPriseIdNum intValue]];
                     }
                     
                     NSString* enterPriseName = [userEnterpriseDic valueForKey:@"name"];
                     if (enterPriseName!=nil && ![enterPriseName isEqual:[NSNull null]] && [enterPriseName length] > 0) {
                         userEnterprise.enterpriseName = enterPriseName;
                     }
                     
                     NSString* enterPriseCategory = [userEnterpriseDic valueForKey:@"category"];
                     if (enterPriseCategory!=nil && ![enterPriseCategory isEqual:[NSNull null]] && [enterPriseCategory length]>0) {
                         userEnterprise.enterpriseCategory = enterPriseCategory;
                     }
                     
                     NSString* enterPriseDes = [userEnterpriseDic valueForKey:@"description"];
                     if(enterPriseDes!=nil && ![enterPriseDes isEqual:[NSNull null] ] && [enterPriseDes length] >0 )
                     {
                         userEnterprise.enterpriseDescription = enterPriseDes;
                     }
                     
                     NSString* enterPriseQRCode = [userEnterpriseDic valueForKey:@"qrcode"];
                     if(enterPriseQRCode!=nil && ![enterPriseQRCode isEqual:[NSNull null]] && [enterPriseQRCode length] >0 ){
                         userEnterprise.enterpriseQRCode = enterPriseQRCode;
                     }
                     
                     NSNumber* enterPriseVerified = [userEnterpriseDic valueForKey:@"verified"];
                     if (enterPriseVerified!=nil && ![enterPriseVerified isEqual:[NSNull null]]) {
                         userEnterprise.bVerified = [enterPriseVerified boolValue];
                     }
                     
                     NSString* enterPriseImg = [userEnterpriseDic valueForKey:@"avatar"];
                     if(enterPriseDes!=nil && ![enterPriseDes isEqual:[NSNull null] ] && [enterPriseDes length] >0 )
                     {
                         userEnterprise.portraitUri = enterPriseImg;
                     }
                     
                     userDetailInfo.enterprise = userEnterprise;
                 }
                 
                 NSString* userPortraitUri = [temDic valueForKey:@"avatar"];
                 if (userPortraitUri != nil && ![userPortraitUri isEqual:[NSNull null]])
                 {
                     userDetailInfo.portraitUri = userPortraitUri;
                 }
                 
                 NSString* userDepartment = [temDic valueForKey:@"department"];
                 if (userDepartment != nil && ![userDepartment isEqual:[NSNull null]])
                 {
                     userDetailInfo.department = userDepartment;
                 }
                 NSString* gender = [temDic valueForKey:@"gender"];
                 if (gender != nil && ![gender isEqual:[NSNull null]])
                 {
                     userDetailInfo.gender = gender;
                 }
                 
                 NSString* email = [temDic valueForKey:@"email"];
                 if (email != nil && ![email isEqual:[NSNull null]])
                 {
                     userDetailInfo.email = email;
                 }
                 
                 NSString* department = [temDic valueForKey:@"department"];
                 if (department != nil && ![department isEqual:[NSNull null]])
                 {
                     userDetailInfo.department = department;
                 }
                 
                 NSString* qrcode = [temDic valueForKey:@"qrcode"];
                 if (qrcode != nil && ![qrcode isEqual:[NSNull null]])
                 {
                     userDetailInfo.qrcode = qrcode;
                 }
                 
                 NSString* enterprise_qrcode = [temDic valueForKey:@"enterprise_qrcode"];
                 if (enterprise_qrcode != nil && ![enterprise_qrcode isEqual:[NSNull null]])
                 {
                     userDetailInfo.enterprise_qrcode = enterprise_qrcode;
                 }
                 
                 NSMutableArray* tag_data = [temDic valueForKey:@"tag_data"];
                 if (tag_data != nil && ![tag_data isEqual:[NSNull null]])
                 {
                     userDetailInfo.tagDataArray = tag_data;
                 }
                 
                 NSNumber* is_member = [temDic valueForKey:@"is_member"];
                 if (is_member != nil && ![is_member isEqual:[NSNull null]])
                 {
                     userDetailInfo.bMember = [is_member boolValue];
                 }
                 NSNumber* is_contact = [temDic valueForKey:@"is_contact"];
                 if (is_contact != nil && ![is_contact isEqual:[NSNull null]])
                 {
                     userDetailInfo.bContact = [is_contact boolValue];
                 }
                 RCUserInfo* user = [[RCUserInfo alloc] init];
                 user.userId = userDetailInfo.userId;
                 user.name = userDetailInfo.userName;
                 user.portraitUri = userDetailInfo.portraitUri;
                 
                 completion(user);
             }
                 break;
             default:
             {
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
     }];
}


@end
