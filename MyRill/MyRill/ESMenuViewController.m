//
//  ESMenuViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "ESMenuViewController.h"
#import "ESNavigationController.h"
#import "ProfessionViewController.h"
//#import "ChatContainerViewController.h"
#import "ChatListViewController.h"
#import "ContactsContainerViewController.h"
#import "TaskOverviewViewController.h"
#import "UserMsgViewController.h"
#import "ColorHandler.h"
#import "RCDAddressBookViewController.h"
#import "GetAppversionDataParse.h"
#import "CustomShowMessage.h"

#define ES_VERSION 0.4

@interface ESMenuViewController () <UITabBarControllerDelegate,GetAppVersionDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) GetAppversionDataParse* getAppVersionDataParse;
@end

@implementation ESMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.barTintColor = [ColorHandler colorFromHexRGB:@"E5E5E5"];
    self.tabBar.tintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
    self.tabBar.layer.borderWidth = .5f;
    self.tabBar.layer.borderColor = [ColorHandler colorFromHexRGB:@"BBBBBB"].CGColor;

    ProfessionViewController *businessVC = [[ProfessionViewController alloc] init];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"业务"
                                                             image:[UIImage imageNamed:@"业务.png"]
                                                     selectedImage:[UIImage imageNamed:@"业务-选中.png"]];
    businessVC.tabBarItem = tabBarItem;
    
    ChatListViewController *chatVC = [[ChatListViewController alloc] initWithDisplayConversationTypes:nil collectionConversationType:nil];

    chatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                      image:[UIImage imageNamed:@"对话.png"]
                                              selectedImage:[UIImage imageNamed:@"对话-选中.png"]];

//    ContactsContainerViewController *contactsVC = [[ContactsContainerViewController alloc] init];
    RCDAddressBookViewController *contactsVC = [[RCDAddressBookViewController alloc] init];

    contactsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人"
                                                          image:[UIImage imageNamed:@"联系人.png"]
                                                  selectedImage:[UIImage imageNamed:@"联系人-选中.png"]];
    
    TaskOverviewViewController *taskVC = [[TaskOverviewViewController alloc] init];
    taskVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"任务"
                                                      image:[UIImage imageNamed:@"任务.png"]
                                              selectedImage:[UIImage imageNamed:@"任务-选中.png"]];
    
    UserMsgViewController *userVC = [[UserMsgViewController alloc] init];
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我"
                                                      image:[UIImage imageNamed:@"我.png"]
                                              selectedImage:[UIImage imageNamed:@"我-选中.png"]];
    
    self.viewControllers = [NSArray arrayWithObjects:
                                [[ESNavigationController alloc] initWithRootViewController:businessVC],
                                [[ESNavigationController alloc] initWithRootViewController:chatVC],
                                [[ESNavigationController alloc] initWithRootViewController:contactsVC],
                                [[ESNavigationController alloc] initWithRootViewController:taskVC],
                                [[ESNavigationController alloc] initWithRootViewController:userVC],nil];
    [self setSelectedIndex:0];
    self.delegate = self;
    [self loginRongCloud];
    
    _getAppVersionDataParse = [[GetAppversionDataParse alloc] init];
    _getAppVersionDataParse.delegate = self;
    [_getAppVersionDataParse getAppVersion];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)loginRongCloud
{
    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
    NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:@"RONG_CLOUD_KEY"];
    if (token == nil || [token isEqual:[NSNull null]] ||
        [token length]<=0 )
    {
        return;
    }
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId)
     {
         //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
         [[RCIM sharedRCIM] setUserInfoDataSource:self];
         [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
         NSLog(@"Login successfully with userId: %@.", userId);
         //         dispatch_async(dispatch_get_main_queue(), ^{
         //             RCConversationListViewController *chatListViewController = [[RCConversationListViewController alloc]init];
         //             [self.navigationController pushViewController:chatListViewController animated:YES];
         //         });
         
     }error:^(RCConnectErrorCode status)
     {
         NSLog(@"登录失败%d",(int)status);
     }
                         tokenIncorrect:^()
     {
         [[CustomShowMessage getInstance] showNotificationMessage:@"登录失效，请重新登录！"];
     }
     ];
    
}

#pragma mark-- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( 0 == buttonIndex)
    {
        NSURL *url = [[NSURL alloc ]initWithString:@"http://fir.im/sn1z"];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark-- GetAppVersionDelegate
-(void)getAppVersionSucceed:(NSString*)appVersionString
{
    float version = [appVersionString floatValue];
    if (version > (ES_VERSION + 0.01) )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                        message:@"有新版本更新啦!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)getAppVersionFailed:(NSString*)errorMessage
{
    
}

#pragma mark RCIMUserInfoDataSource
/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
}
@end
