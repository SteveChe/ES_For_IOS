//
//  ChatListViewController.m
//  MyRill
//
//  Created by Steve on 15/6/24.
//
//

#import "ChatListViewController.h"
#import "KxMenu.h"
#import "UIColor+RCColor.h"
#import "ESUserInfo.h"
#import "ChatViewController.h"
#import "RCDSelectPersonViewController.h"
#import "RCDSearchFriendViewController.h"
@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"对话";

    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.conversationListTableView.tableFooterView = [UIView new];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"会话";
    self.tabBarController.navigationItem.titleView = titleView;
    
    //自定义rightBarButtonItem
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
//    [rightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"+" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTintColor:[UIColor whiteColor]];
//    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
//    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;

    [self updateBadgeValueForTabBarItem];
    
}

- (void)updateBadgeValueForTabBarItem
{
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
        if (count>0) {
            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        }else
        {
            __weakSelf.tabBarItem.badgeValue = nil;
        }
        
    });
}

/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        ChatViewController *_conversationVC = [[ChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    //聚合会话类型，此处自定设置。
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        ChatListViewController *temp = [[ChatListViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
    //自定义会话类型
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
        ESUserInfo *userinfo = [ESUserInfo new];
        
        NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
        if (_cache_userinfo) {
            userinfo.userName       = _cache_userinfo[@"username"];
            userinfo.portraitUri    = _cache_userinfo[@"portraitUri"];
            userinfo.userId         = _contactNotificationMsg.sourceUserId;
        }
        
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        RCDAddFriendTableViewController *temp = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddFriendTableViewController"];
//        temp.userInfo = userinfo;//model.extend;
//        [self.navigationController pushViewController:temp animated:YES];
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

/**
 *  重载右边导航按钮的事件
 *
 *  @param sender
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"发起对话"
                     image:[UIImage imageNamed:@"chat_icon"]
                    target:self
                    action:@selector(pushChat:)],
      
      [KxMenuItem menuItem:@"添加联系人"
                     image:[UIImage imageNamed:@"addfriend_icon"]
                    target:self
                    action:@selector(pushAddFriend:)],
      
      ];
//    CGRect targetFrame = self.tabBarController.navigationItem.rightBarButtonItem.customView.frame;
    CGRect targetFrame = self.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 15;
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
    //    [KxMenu showMenuInView:self.tabBarController.navigationController.navigationBar.superview
//                  fromRect:targetFrame
//                 menuItems:menuItems];

//    ChatViewController *_conversationVC = [[ChatViewController alloc]init];
//    _conversationVC.conversationType = ConversationType_PRIVATE;
//    _conversationVC.targetId = @"13";
//    _conversationVC.userName = @"cxs";
//    _conversationVC.title = @"聊天";
//    _conversationVC.conversation = model;
    
//    [self.navigationController pushViewController:_conversationVC animated:YES];
}

#pragma mark 导航按钮-方法

/**
 *  发起对话
 *
 *  @param sender sender description
 */
- (void) pushChat:(id) sender
{
    RCDSelectPersonViewController *selectPersonVC = [[RCDSelectPersonViewController alloc] init];
    
    //设置点击确定之后回传被选择联系人操作
    __weak typeof(&*self)  weakSelf = self;
    selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController *selectPersonViewController,NSArray *selectedUsers){
        if(selectedUsers.count == 1)
        {
            RCUserInfo *user = selectedUsers[0];
            ChatViewController *chat =[[ChatViewController alloc]init];
            chat.targetId                      = user.userId;
            chat.userName                    = user.name;
            chat.conversationType              = ConversationType_PRIVATE;
            chat.title                         = user.name;
            
            //跳转到会话页面
            dispatch_async(dispatch_get_main_queue(), ^{
                UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                [weakSelf.navigationController popToViewController:tabbarVC animated:YES];
                [tabbarVC.navigationController  pushViewController:chat animated:YES];
            });
            
        }
        //选择多人则创建讨论组
        else if(selectedUsers.count > 1)
        {
            
            NSMutableString *discussionTitle = [NSMutableString string];
            NSMutableArray *userIdList = [NSMutableArray new];
            for (RCUserInfo *user in selectedUsers) {
                [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", user.name,@","]];
                [userIdList addObject:user.userId];
            }
            [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
            
            [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle userIdList:userIdList success:^(RCDiscussion *discussion) {
                NSLog(@"create discussion ssucceed!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    ChatViewController *chat =[[ChatViewController alloc]init];
                    chat.targetId                      = discussion.discussionId;
                    chat.userName                    = discussion.discussionName;
                    chat.conversationType              = ConversationType_DISCUSSION;
                    chat.title                         = @"讨论组";
                    
                    
                    UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                    [weakSelf.navigationController popToViewController:tabbarVC animated:YES];
                    [tabbarVC.navigationController  pushViewController:chat animated:YES];
                });
            } error:^(RCErrorCode status) {
                NSLog(@"create discussion Failed > %ld!", (long)status);
            }];
            return;
        }
    };
    
    [self.navigationController showViewController:selectPersonVC sender:self.navigationController];
}

/**
 *  添加联系人
 *
 *  @param sender sender description
 */
- (void) pushAddFriend:(id) sender
{
    RCDSearchFriendViewController *searchFirendVC = [[RCDSearchFriendViewController alloc] init];
    [self.navigationController pushViewController:searchFirendVC  animated:YES];
    
}

@end
