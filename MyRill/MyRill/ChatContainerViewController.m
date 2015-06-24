//
//  ChatContainerViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "ChatContainerViewController.h"
#import <RongIMKit/RCConversationViewController.h>
#import "AppDelegate.h"

@interface ChatContainerViewController ()

@end

@implementation ChatContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"对话";
    [self loginRongCloud];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    //自定义导航左右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"单聊" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
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

-(void)loginRongCloud
{
    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
//    NSString*token=@"JFxGTunyLd41P2gbifk2o6ZMo/KVDHrEYcpc/b7q1zvRMx4J8NRKVdf3O3BAumPYR53P3Jh0fwo+cSWhr8lNwQ==";
    //getObject forKey:@"RONG_CLOUD_KEY"];NSString
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

/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.title = @"会话";
}



/**
 *  重载右边导航按钮的事件
 *
 *  @param sender
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = @"13";
    conversationVC.userName = @"myself";
    conversationVC.title = @"13";
//    [self.navigationController pushViewController:conversationVC animated:YES];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    ESMenuViewController *esVC = [[ESMenuViewController alloc] init];
    [appDelegate changeWindow:conversationVC];

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
