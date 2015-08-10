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
#import "RCDChatListCell.h"
#import "UIImageView+WebCache.h"
#import "UserInfoDataSource.h"
#import "GetContactDetailDataParse.h"
#import "ESUserDetailInfo.h"
#import "EnterpriseChatViewController.h"
#import "GetEnterpriseMessageDataParse.h"
#import "ESEnterpriseMessage.h"
#import "ESEnterpriseMessageContent.h"
#import "DeviceInfo.h"
#import "EnterpriseChatListViewController.h"

void(^completionHandler)(RCUserInfo* userInfo);


@interface ChatListViewController ()<ContactDetailDataDelegate,GetLastestMessageDelegate>
@property (nonatomic,strong) GetContactDetailDataParse* getContactDetailDataParse;
@property (atomic,assign)NSInteger nUserDetailRequestNum;
@property (nonatomic,strong) NSMutableArray *myDataSource;
@property (nonatomic,strong) GetEnterpriseMessageDataParse* getEnterpriseMessageDataParse;

//-(void)initEnterpriseMessage;
-(void)updateEnterpriseMessage;
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_SYSTEM),@(ConversationType_APPSERVICE)]];
    //聚合会话类型
    [self setCollectionConversationType:@[@(ConversationType_SYSTEM),@(ConversationType_APPSERVICE)]];

    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"对话";

    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.conversationListTableView.tableFooterView = [UIView new];
    
    // 设置用户信息提供者。
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    _getContactDetailDataParse = [[GetContactDetailDataParse alloc] init];
    _getContactDetailDataParse.delegate = self;
    _nUserDetailRequestNum = 0;
    _myDataSource = [NSMutableArray new];
    
    _getEnterpriseMessageDataParse = [[GetEnterpriseMessageDataParse alloc] init];
    _getEnterpriseMessageDataParse.getLastestMessageDelegate = self;
//    [self initEnterpriseMessage];
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
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"lianxiren_tianjia"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;

    [self updateBadgeValueForTabBarItem];
    
    if (_nUserDetailRequestNum == 0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationListTableView reloadData];
            });
        });
    }
    [self updateEnterpriseMessage];
}

-(void)updateEnterpriseMessage
{
    [_getEnterpriseMessageDataParse getLastestMessage];
}

-(void)initEnterpriseMessage
{
    RCConversationModel *esModel = [RCConversationModel new];
    esModel.isTop = YES;
    esModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//    esModel.extend = nil;
//    esModel.sentTime = 1438868551;
//    esModel.receivedTime = 1438868551;
//    [self.conversationListDataSource insertObject:esModel atIndex:0];
//    [self refreshConversationTableViewWithConversationModel:esModel];
    [_myDataSource addObject:esModel];
    
    RCConversationModel *enterpriseModel = [RCConversationModel new];
    enterpriseModel.isTop = YES;
    enterpriseModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//    enterpriseModel.extend = nil;
//    enterpriseModel.sentTime = 1438868551;
//    enterpriseModel.receivedTime = 1438868551;
    [_myDataSource addObject:enterpriseModel];
//    [self.conversationListDataSource insertObject:enterpriseModel atIndex:1];
//    
//    [self willReloadTableData:self.conversationListDataSource];
//    调用父类刷新未读消息数
//    [self refreshConversationTableViewWithConversationModel:enterpriseModel];
//    [super didReceiveMessageNotification:notification];
//    [self refreshConversationTableViewIfNeeded];
//    [self updateBadgeValueForTabBarItem];
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
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION)
    {
        if (indexPath.row == 0)
        {
            EnterpriseChatViewController* enterpriseChatVC = [[EnterpriseChatViewController alloc] init];
            enterpriseChatVC.title = @"ES系统消息";//ES系统消息
            enterpriseChatVC.chatType = e_Enterprise_Chat_Riil;
            [self.navigationController pushViewController:enterpriseChatVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            EnterpriseChatListViewController* enterpriseChatlistVC = [[EnterpriseChatListViewController alloc] init];
            [self.navigationController pushViewController:enterpriseChatlistVC animated:YES];
        }

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  重载右边导航按钮的事件
 *
 *  @param sender
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    KxMenuItem* k1 = [KxMenuItem menuItem:@"发起对话"
                                    image:[UIImage imageNamed:@"duihua_faqiduihua"]
                                   target:self
                                   action:@selector(pushChat:)];
    k1.foreColor = [UIColor colorWithHexString:@"333333" alpha:1.0f];
    
    KxMenuItem* k2 = [KxMenuItem menuItem:@"添加联系人"
                                          image:[UIImage imageNamed:@"duihua_tianjialianxiren"]
                                         target:self
                                         action:@selector(pushAddFriend:)];
    k2.foreColor = [UIColor colorWithHexString:@"333333" alpha:1.0f];

    NSArray *menuItems =
    @[ k1, k2,];
    CGRect targetFrame = self.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 15;
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
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
            ESUserInfo *user = selectedUsers[0];
            ChatViewController *chat =[[ChatViewController alloc]init];
            chat.targetId                      = user.userId;
            chat.userName                    = user.userName;
            chat.conversationType              = ConversationType_PRIVATE;
            chat.title                         = user.userName;
            
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
            for (ESUserInfo *user in selectedUsers) {
                [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", user.userName,@","]];
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
                    chat.userIDList = userIdList;
                    
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

//*********************插入自定义Cell*********************//

//插入自定义会话model
//-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
//{
//    
////    for (int i=0; i<_myDataSource.count; i++) {
////        RCConversationModel *customModel =[_myDataSource objectAtIndex:i];
////        [dataSource insertObject:customModel atIndex:0];
////    }
//    
//    return dataSource;
//}

//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    //[_myDataSource removeObject:model];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willDisplayConversationTableCell");
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}

//自定义cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    //RCDChatListCell
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ESEnterpriseCell"];

    [cell setModel:model];
    if(indexPath.row == 0)
    {
        cell.lblName.text = @"ES系统消息";
        cell.lblDetail.text = model.conversationTitle;
        cell.timeLabel.text = [DeviceInfo getShowTime:[NSDate dateWithTimeIntervalSince1970:model.sentTime]];
        [cell.ivAva setImage:[UIImage imageNamed:@"duihua_xitongxiaoxi"]];
    }
    else if ( indexPath.row == 1)
    {
        cell.lblName.text = @"企业消息";
        cell.lblDetail.text = model.conversationTitle;
        cell.timeLabel.text = [DeviceInfo getShowTime:[NSDate dateWithTimeIntervalSince1970:model.sentTime]];
        [cell.ivAva setImage:[UIImage imageNamed:@"duihua_qiyexiaoxi"]];
        
    }

    return cell;
}

//*********************插入自定义Cell*********************//

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    if (_myDataSource == nil || [_myDataSource count] <= 0)
    {
        return dataSource;
    }
    for (int i=0; i<_myDataSource.count; i++)
    {
        RCConversationModel *customModel =[_myDataSource objectAtIndex:i];
//        [dataSource replaceObjectAtIndex:i withObject:customModel];
        [dataSource insertObject:customModel atIndex:i];
    }
    
    return dataSource;
}


#pragma mark -- ContactDetailDataDelegate
- (void)getContactDetail:(ESUserDetailInfo *)userDetailInfo
{
    RCUserInfo* user = [[RCUserInfo alloc] init];
    user.userId = userDetailInfo.userId;
    user.name = userDetailInfo.userName;
    user.portraitUri = userDetailInfo.portraitUri;
    completionHandler(user);
    _nUserDetailRequestNum -- ;
    if (_nUserDetailRequestNum == 0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationListTableView reloadData];
            });
        });
    }
}
- (void)getContactDetailFailed:(NSString*)errorMessage
{
    _nUserDetailRequestNum -- ;
    if (_nUserDetailRequestNum == 0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationListTableView reloadData];
            });
        });
    }
}

#pragma mark - GetLastestMessageDelegate
-(void)getLastestMessageSucceed:(NSDictionary*)enterpriseMessageDic
{
    if (enterpriseMessageDic == nil)
    {
        return;
    }
    
    ESEnterpriseMessage* riilMessage = [enterpriseMessageDic objectForKey:@"riil"];
    if (riilMessage != nil)
    {
        RCConversationModel *esModel = [RCConversationModel new];
        esModel.isTop = YES;
        esModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        
        if (!riilMessage.bRead) {
            esModel.unreadMessageCount = 1;
        }
        if (riilMessage.bSuggestion)
        {
            esModel.conversationTitle = riilMessage.suggetstionText;
        }
        else
        {
            if(riilMessage.enterprise_messageContent != nil)
            {
                esModel.conversationTitle = riilMessage.enterprise_messageContent.title;
            }
        }
        if (riilMessage.message_time!=nil)
        {
            esModel.sentTime = [riilMessage.message_time timeIntervalSince1970];
            esModel.receivedTime = [[NSDate date] timeIntervalSince1970];
        }
        if ([_myDataSource count] >1)
        {
            [_myDataSource replaceObjectAtIndex:0 withObject:esModel];

        }
        else
        {
            [_myDataSource insertObject:esModel atIndex:0];
        }
    }
    
    ESEnterpriseMessage* enterpriseMessage = [enterpriseMessageDic objectForKey:@"enterprise"];
    if (enterpriseMessage != nil)
    {
        RCConversationModel *enterpriseModel = [RCConversationModel new];
        enterpriseModel.isTop = YES;
        enterpriseModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        if (!enterpriseMessage.bRead) {
            enterpriseModel.unreadMessageCount = 1;
        }
        if (enterpriseMessage.enterprise_messageContent != nil)
        {
            enterpriseModel.conversationTitle = enterpriseMessage.enterprise_messageContent.title;
        }
        else
        {
            if (enterpriseMessage.bSuggestion)
            {
                enterpriseModel.conversationTitle = enterpriseMessage.suggetstionText;
            }
        }
        if (enterpriseMessage.message_time!=nil)
        {
            enterpriseModel.sentTime = [enterpriseMessage.message_time timeIntervalSince1970];
            enterpriseModel.receivedTime = [[NSDate date] timeIntervalSince1970];
        }
        if ([_myDataSource count] >1)
        {
            [_myDataSource replaceObjectAtIndex:1 withObject:enterpriseModel];

        }
        else
        {
            [_myDataSource insertObject:enterpriseModel atIndex:1];

        }
    }
    [self refreshConversationTableViewIfNeeded];
}
-(void)getLastestMessageFailed:(NSString*)errorMessage
{
    
}

#pragma mark override
/**
 *  点击头像事件
 *
 *  @param model 会话model
 */
- (void)didTapCellPortrait:(RCConversationModel *)model
{
    ChatViewController *chat =[[ChatViewController alloc]init];
    chat.targetId                      = model.targetId;
    chat.userName                    = model.conversationTitle;
    chat.conversationType              = model.conversationType;
    chat.title                         = model.conversationTitle;
    [self.navigationController pushViewController:chat animated:YES];
}


#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
//        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        
//        //该接口需要替换为从消息体获取好友请求的用户信息
//        [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
//                              completion:^(RCUserInfo *user) {
//                                  RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
//                                  rcduserinfo_.userName = user.name;
//                                  rcduserinfo_.userId = user.userId;
//                                  rcduserinfo_.portraitUri = user.portraitUri;
//                                  
//                                  RCConversationModel *customModel = [RCConversationModel new];
//                                  customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//                                  customModel.extend = rcduserinfo_;
//                                  customModel.senderUserId = message.senderUserId;
//                                  customModel.lastestMessage = _contactNotificationMsg;
//                                  //[_myDataSource insertObject:customModel atIndex:0];
//                                  
//                                  //local cache for userInfo
//                                  NSDictionary *userinfoDic = @{@"username": rcduserinfo_.userName,
//                                                                @"portraitUri":rcduserinfo_.portraitUri
//                                                                };
//                                  [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
//                                  [[NSUserDefaults standardUserDefaults]synchronize];
//                                  
//                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                      //调用父类刷新未读消息数
//                                      [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
//                                      //[super didReceiveMessageNotification:notification];
//                                      [blockSelf_ resetConversationListBackgroundViewIfNeeded];
//                                      [blockSelf_ updateBadgeValueForTabBarItem];
//                                  });
//                              }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [blockSelf_ updateBadgeValueForTabBarItem];
        });
    }
}


// 获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
    ESUserInfo* userInfo = [[UserInfoDataSource shareInstance] getUserByUserId:userId];
    if(userInfo == nil || [userInfo isEqual:[NSNull null]])
    {
        completionHandler = completion;
        [_getContactDetailDataParse getContactDetail:userId];
        _nUserDetailRequestNum ++ ;
    }
    else
    {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = userInfo.userId;
        user.name = userInfo.userName;
        user.portraitUri = userInfo.portraitUri;
        return completion(user);
    }
    return completion(nil);
}

@end
