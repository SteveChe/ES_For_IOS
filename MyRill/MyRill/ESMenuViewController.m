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
#import "GetNotificationStatusDataParse.h"
#import "DeviceInfo.h"
#import "PushDefine.h"

#define ES_VERSION 0.8

@interface ESMenuViewController () <UITabBarControllerDelegate,GetAppVersionDelegate,UIAlertViewDelegate,GetNotificationStatusDelegate>

@property (nonatomic,strong) GetAppversionDataParse* getAppVersionDataParse;
@property (nonatomic,strong) GetNotificationStatusDataParse* getNotificationStatusDataParse;
@property (nonatomic,strong) UILabel* professionRedbadage;
@property (nonatomic,strong) UILabel* subscriptionRedbadage;
@property (nonatomic,strong) UILabel* contactRedbadage;
@property (nonatomic,strong) UILabel* assignmentRedbadage;

-(void)getNotificationStatus1;

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
    [businessVC.tabBarController.tabBar addSubview:self.professionRedbadage];
    [contactsVC.tabBarController.tabBar addSubview:self.contactRedbadage];

    [taskVC.tabBarController.tabBar addSubview:self.assignmentRedbadage];

    [self setSelectedIndex:0];
    self.delegate = self;
    [self loginRongCloud];
    
    _getAppVersionDataParse = [[GetAppversionDataParse alloc] init];
    _getAppVersionDataParse.delegate = self;
    [_getAppVersionDataParse getAppVersion];
    
    _getNotificationStatusDataParse = [[GetNotificationStatusDataParse alloc]init];
    _getNotificationStatusDataParse.delegate = self;
    [_getNotificationStatusDataParse getNotificationStatus];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationStatus:)
                                                 name:NOTIFICATION_STATUS_UPDATE
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotificationStatus1)
                                                 name:NOTIFICATION_ENTER_FOREGROUD
                                               object:nil];
    

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

-(void)getNotificationStatus1
{
    [_getNotificationStatusDataParse getNotificationStatus];
}

-(void)updateNotificationStatus:(id)notification
{
//    NSLog(@"updateNotificationStatus");
    NSDictionary *notificationStatusDic = (NSDictionary *)[notification object];
    [self getNotificationStatusSucceed:notificationStatusDic];
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
#pragma mark-- GetNotificationStatusDelegate
-(void)getNotificationStatusSucceed:(NSDictionary*)notificationStatus
{
//    NSLog(@"notificationStatus = %@",notificationStatus);
    NSNumber* bProfessionUp = [notificationStatus objectForKey:@"profession"];
    if (bProfessionUp != nil && ![bProfessionUp isEqual:[NSNull null]])
    {
        self.professionRedbadage.hidden = ![bProfessionUp boolValue];
    }
    NSNumber* bAssignment = [notificationStatus objectForKey:@"assignment"];
    if (bAssignment != nil && ![bAssignment isEqual:[NSNull null]])
    {
        self.assignmentRedbadage.hidden = ![bAssignment boolValue];
    }
    
    NSNumber* bContact = [notificationStatus objectForKey:@"contact"];
    if (bContact != nil && ![bContact isEqual:[NSNull null]])
    {
        self.contactRedbadage.hidden = ![bContact boolValue];
    }
    
}
-(void)getNotificationStatusFailed:(NSString*)errorMessage
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

#pragma mark -- setter&getter
- (UILabel*)professionRedbadage{
    if (!_professionRedbadage)
    {
        _professionRedbadage = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 10, 10)];
        _professionRedbadage.font = [UIFont systemFontOfSize:8];
//        _professionRedbadage.textColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _professionRedbadage.backgroundColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _professionRedbadage.clipsToBounds = YES;
        _professionRedbadage.layer.cornerRadius = 5;
        _professionRedbadage.hidden = YES;
    }
    return _professionRedbadage;
}

-(UILabel*)subscriptionRedbadage{
    if (!_subscriptionRedbadage)
    {
        _subscriptionRedbadage = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/5 + 50, 5, 10, 10)];
        _subscriptionRedbadage.font = [UIFont systemFontOfSize:8];
        //        _professionRedbadage.textColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _subscriptionRedbadage.backgroundColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _subscriptionRedbadage.clipsToBounds = YES;
        _subscriptionRedbadage.layer.cornerRadius = 5;
        _subscriptionRedbadage.hidden = YES;
    }
    return _subscriptionRedbadage;
}


-(UILabel*)contactRedbadage{
    if (!_contactRedbadage)
    {
        _contactRedbadage = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/5 * 2 + 50, 5, 10, 10)];
        _contactRedbadage.font = [UIFont systemFontOfSize:8];
        //        _professionRedbadage.textColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _contactRedbadage.backgroundColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _contactRedbadage.clipsToBounds = YES;
        _contactRedbadage.layer.cornerRadius = 5;
        _contactRedbadage.hidden = YES;
    }
    return _contactRedbadage;
}

-(UILabel*)assignmentRedbadage{
    if (!_assignmentRedbadage)
    {
        _assignmentRedbadage = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/5 * 3 + 50, 5, 10, 10)];
        _assignmentRedbadage.font = [UIFont systemFontOfSize:8];
        //        _professionRedbadage.textColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _assignmentRedbadage.backgroundColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        _assignmentRedbadage.clipsToBounds = YES;
        _assignmentRedbadage.layer.cornerRadius = 5;
        _assignmentRedbadage.hidden = YES;
    }
    return _assignmentRedbadage;
}


@end

