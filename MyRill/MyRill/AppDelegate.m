//
//  AppDelegate.m
//  MyRill
//
//  Created by Siyuan Wang on 15/5/24.
//
//
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ESMenuViewController.h"
#import "ESNavigationController.h"
#import "APService.h"

#define RONGCLOUD_IM_APPKEY @"pvxdm17jx871r" //online key

#define kDeviceToken @"RongCloud_SDK_DeviceToken"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *_deviceTokenCache = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
    
    //初始化融云SDK，
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY deviceToken:_deviceTokenCache];
    
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
//    ESMenuViewController *esVC = [[ESMenuViewController alloc] init];
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:sender.view
                      duration:1
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL finished)
     {
         self.window.rootViewController = sender;
     }];

//    self.window.rootViewController = sender;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push Method

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString* deviceTokenStr = [[[[deviceToken description]
//                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
//                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
//    [[BMPushModel getInstance] registPushWithToken:deviceTokenStr];
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
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"userInfo= %@",userInfo);
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


@end
