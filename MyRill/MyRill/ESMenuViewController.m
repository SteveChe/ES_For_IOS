//
//  ESMenuViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "ESMenuViewController.h"
#import "ESNavigationController.h"
#import "BusinessContainerViewController.h"
//#import "ChatContainerViewController.h"
#import "ChatListViewController.h"
#import "ContactsContainerViewController.h"
#import "TaskContainerViewController.h"
#import "UserMsgViewController.h"
#import "ColorHandler.h"
#import "RCDAddressBookViewController.h"

@interface ESMenuViewController () <UITabBarControllerDelegate>

@end

@implementation ESMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [ColorHandler colorFromHexRGB:@"E9EEF2"];

    BusinessContainerViewController *businessVC = [[BusinessContainerViewController alloc] init];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"业务"
                                                             image:[UIImage imageNamed:@"icon"]
                                                     selectedImage:nil];
    businessVC.tabBarItem = tabBarItem;
    
    ChatListViewController *chatVC = [[ChatListViewController alloc] init];
    chatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                      image:[UIImage imageNamed:@"icon"]
                                              selectedImage:nil];

//    ContactsContainerViewController *contactsVC = [[ContactsContainerViewController alloc] init];
    RCDAddressBookViewController *contactsVC = [[RCDAddressBookViewController alloc] init];

    contactsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人"
                                                          image:[UIImage imageNamed:@"icon"]
                                                  selectedImage:nil];
    
    TaskContainerViewController *taskVC = [[TaskContainerViewController alloc] init];
    taskVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"任务"
                                                      image:[UIImage imageNamed:@"icon"]
                                              selectedImage:nil];
    
    UserMsgViewController *userVC = [[UserMsgViewController alloc] init];
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我"
                                                      image:[UIImage imageNamed:@"icon"]
                                              selectedImage:nil];
    
    self.viewControllers = [NSArray arrayWithObjects:
                                [[ESNavigationController alloc] initWithRootViewController:businessVC],
                                [[ESNavigationController alloc] initWithRootViewController:chatVC],
                                [[ESNavigationController alloc] initWithRootViewController:contactsVC],
                                [[ESNavigationController alloc] initWithRootViewController:taskVC],
                                [[ESNavigationController alloc] initWithRootViewController:userVC],nil];
    [self setSelectedIndex:0];
    self.delegate = self;
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
    [self loginRongCloud];
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
         NSLog(@"Login successfully with userId: %@.", userId);
         //         dispatch_async(dispatch_get_main_queue(), ^{
         //             RCConversationListViewController *chatListViewController = [[RCConversationListViewController alloc]init];
         //             [self.navigationController pushViewController:chatListViewController animated:YES];
         //         });
         
     }error:^(RCConnectErrorCode status)
     {
         NSLog(@"登录失败%d",(int)status);
     }
                         tokenIncorrect:^(id response)
     {
         
     }
     ];
    
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
