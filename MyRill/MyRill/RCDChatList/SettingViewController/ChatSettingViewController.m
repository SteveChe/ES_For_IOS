//
//  ChatSettingViewController.m
//  MyRill
//
//  Created by Steve on 15/7/21.
//
//

#import "ChatSettingViewController.h"
#import "ColorHandler.h"
#import "ChatSettingCollectionViewCell.h"
#import "ESUserInfo.h"
#import "RCDAddressBookDetailViewController.h"
#import "UserInfoDataSource.h"
#import "ESUserDetailInfo.h"
#import "RCDSelectPersonViewController.h"
#import "ChatViewController.h"
#import "RCDDiscussSettingCell.h"
#import "RCDUpdateNameViewController.h"
#import "UserDefaultsDefine.h"

@interface ChatSettingViewController ()<UIActionSheetDelegate>
//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) NSArray* members;
@property (nonatomic,strong) GetContactDetailDataParse* getContactDetailDataParse;
@property (nonatomic,weak) RCConversationSettingTableViewHeader* tableViewHeader ;
@end

@implementation ChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //显示顶部视图
    self.headerHidden = NO;
    _getContactDetailDataParse = [[GetContactDetailDataParse alloc] init];
    _getContactDetailDataParse.delegate = self;
    
    [self initUsersInfo];
    if(self.conversationType == ConversationType_PRIVATE)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        view.backgroundColor = [UIColor clearColor];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [ColorHandler colorFromHexRGB:@"FF5454"];
        CGRect rect = button.frame;
        rect.origin.x = 0;
        rect.origin.y = 80;
        rect.size.width = self.view.frame.size.width - 40;
        rect.size.height = 44;
        button.frame = rect;
        
        [button setTitle:@"清除聊天记录" forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setCenter:CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2)];
        [button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 20.0;
        [view addSubview:button];
        
        
        self.tableView.tableFooterView = view;
    }
    else if (self.conversationType == ConversationType_DISCUSSION)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        button1.backgroundColor = [ColorHandler colorFromHexRGB:@"FF5454"];
        CGRect rect1 = button1.frame;
        rect1.origin.x = 0;
        rect1.origin.y = 60;
        rect1.size.width = self.view.frame.size.width - 40;
        rect1.size.height = 44;
        button1.frame = rect1;
        
        [button1 setTitle:@"清除聊天记录" forState:UIControlStateNormal];
        button1.tintColor = [UIColor whiteColor];
        button1.titleLabel.font = [UIFont systemFontOfSize:18];
//        [button1 setCenter:CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2)];
        CGPoint centerPt1 = button1.center;
        centerPt1.x = view.bounds.size.width/2;
        [button1 setCenter:centerPt1];
        
        [button1 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        button1.layer.cornerRadius = 20.0;
        [view addSubview:button1];

        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [ColorHandler colorFromHexRGB:@"FF5454"];
        CGRect rect = button.frame;
        rect.origin.x = 0;
        rect.origin.y = 130;
        rect.size.width = self.view.frame.size.width - 40;
        rect.size.height = 44;
        button.frame = rect;
        
        [button setTitle:@"退出聊天" forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        CGPoint centerPt = button.center;
        centerPt.x = view.bounds.size.width/2;
        [button setCenter:centerPt];
//        [button setCenter:CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2)];
        [button addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 20.0;
        [view addSubview:button];
        self.tableView.tableFooterView = view;
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initConversationInfo];
}

-(void) initConversationInfo
{
    if (self.conversationType == ConversationType_DISCUSSION)
    {
        [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion* discussion) {
            if (discussion) {
                self.title = discussion.discussionName;
                self.conversationTitle = discussion.discussionName;

                NSInteger rowNum = [self tableView:self.tableView numberOfRowsInSection:0];
                if (rowNum > 0) {
                    [self.tableView reloadData];
                }
            }
        } error:^(RCErrorCode status){
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUsersInfo
{
    //添加当前聊天用户
    if (self.conversationType == ConversationType_PRIVATE)
    {
        [_getContactDetailDataParse getContactDetail:self.targetId];

//        ESUserInfo* userInfo = [[UserInfoDataSource shareInstance] getUserByUserId:self.targetId];
//        RCUserInfo* rcUserInfo = [[RCUserInfo alloc] init];
//        rcUserInfo.userId = userInfo.userId;
//        rcUserInfo.name = userInfo.userName;
//        rcUserInfo.portraitUri = userInfo.portraitUri;
//        if (rcUserInfo != nil && ![rcUserInfo isEqual:[NSNull null]])
//        {
//            [self.userIdList addObject:rcUserInfo];
//            [self addUsers:self.userIdList];
//        }
    }
    else if(self.conversationType == ConversationType_DISCUSSION)
    {
//        __weak RCSettingViewController* weakSelf = self;
        [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion* discussion) {
            if (discussion) {
                
                if([[RCIMClient sharedRCIMClient].currentUserInfo.userId isEqualToString:discussion.creatorId])
                {
                    [self disableDeleteMemberEvent:NO];
                    
                }else{
                    [self disableDeleteMemberEvent:YES];
                }
                
                for (NSString *userId in discussion.memberIdList)
                {
                    [_getContactDetailDataParse getContactDetail:userId];

//                    ESUserInfo* esUser = [[UserInfoDataSource shareInstance] getUserByUserId:userId];
//                    if (esUser == nil)
//                    {
//                        [_getContactDetailDataParse getContactDetail:userId];
//                        continue;
//                    }
//                    RCUserInfo* userInfo = [[RCUserInfo alloc] init];
//                    userInfo.userId = esUser.userId;
//                    userInfo.name = esUser.userName;
//                    userInfo.portraitUri = esUser.portraitUri;
//                    [self.userIdList addObject:userInfo];
                }
//                [self addUsers:self.userIdList];
                
            }
        } error:^(RCErrorCode status){
            
        }];

    }
}

-(void)updateUsersInfo
{
    if ([self.userIdList count] <= 0)
    {
        return;
    }
    [self.dataSource removeAllObjects];
    
    for (NSString* userId in self.userIdList)
    {
        if (userId == nil || [userId isEqual:[NSNull null] ] || [userId length] <=0  )
        {
            continue;
        }
        ESUserInfo* userInfo = [[UserInfoDataSource shareInstance] getUserByUserId:userId];
        if (userInfo != nil && ![userInfo isEqual:[NSNull null]])
        {
            [self.dataSource addObject:userInfo];
        }
    }
}


#pragma mark - private method
- (void)createDiscussionOrInvokeMemberWithSelectedUsers:(NSArray*)selectedUsers
{
//    __weak ChatSettingViewController *weakSelf = self;
        if (ConversationType_DISCUSSION == self.conversationType) {
            //invoke new member to current discussion

            NSMutableArray *addIdList = [NSMutableArray new];
            NSMutableArray* allUsers = [NSMutableArray array];
            

            for (ESUserInfo *user in selectedUsers) {
                [addIdList addObject:user.userId];
                RCUserInfo *rcdUser = [[RCUserInfo alloc] init];
                rcdUser.userId = user.userId;
                rcdUser.name = user.userName;
                rcdUser.portraitUri = user.portraitUri;
                [allUsers addObject:rcdUser];
            }
            
            //加入讨论组
            if(addIdList.count != 0){
                __weak typeof(&*self)  weakSelf = self;

                [[RCIMClient sharedRCIMClient] addMemberToDiscussion:self.targetId userIdList:addIdList success:^(RCDiscussion *discussion) {
//                    NSLog(@"成功");

                    dispatch_async(dispatch_get_main_queue(), ^{
                        RCUserInfo *myself = [[RCUserInfo alloc] init];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        myself.userId =  [userDefaults stringForKey:DEFAULTS_USERID];
                        myself.name =  [userDefaults stringForKey:DEFAULTS_USERNAME];
                        myself.portraitUri =  [userDefaults stringForKey:DEFAULTS_USERAVATAR];
                        [allUsers insertObject:myself atIndex:0];
                        [weakSelf addUsers:(NSArray *)allUsers];
                        [weakSelf.tableViewHeader reloadData];
                        
                    });
                } error:^(RCErrorCode status) {
                }];
            }
            [self.navigationController popViewControllerAnimated:YES];

            
        }else if (ConversationType_PRIVATE == self.conversationType)
        {
            //create new discussion with the new invoked member.
            NSUInteger _count = [selectedUsers count];
            if (_count > 1) {
                
                NSMutableString *discussionTitle = [NSMutableString string];
                NSMutableArray *userIdList = [NSMutableArray new];
                for (int i=0; i<_count; i++) {
                    ESUserInfo *_userInfo = (ESUserInfo *)selectedUsers[i];
                    [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", _userInfo.userName,@","]];
                    
                    [userIdList addObject:_userInfo.userId];
                }
                [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
//                self.conversationTitle = discussionTitle;
                
                __weak typeof(&*self)  weakSelf = self;
                [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle userIdList:userIdList success:^(RCDiscussion *discussion) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ChatViewController *chat =[[ChatViewController alloc]init];
                        chat.targetId                      = discussion.discussionId;
                        chat.userName                    = discussion.discussionName;
                        chat.conversationType              = ConversationType_DISCUSSION;
                        chat.title                         = discussionTitle;//[NSString stringWithFormat:@"讨论组(%lu)", (unsigned long)_count];
                        
                        UIViewController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                        [weakSelf.navigationController popToViewController:tabbarVC animated:YES];                        
                        [tabbarVC.navigationController  pushViewController:chat animated:YES];
                    });
                } error:^(RCErrorCode status) {
                    NSLog(@"create discussion Failed > %ld!", (long)status);
                }];
            }
            
        }
}


#pragma mark - button event
-(void)buttonAction1:(UIButton*)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"退出讨论组" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet setTag:0];
    [actionSheet showInView:self.view];
    
}

-(void)buttonAction2:(UIButton*)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"清除聊天记录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet setTag:1];
    [actionSheet showInView:self.view];
}

#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:self.clearMsgHistoryActionSheet]) {
        [self clearHistoryMessage];
    }else{
        if (actionSheet.tag == 0)
        {
            if (0 == buttonIndex) {
                __weak typeof(&*self)  weakSelf = self;
                [[RCIMClient sharedRCIMClient] quitDiscussion:self.targetId success:^(RCDiscussion *discussion) {
                    NSLog(@"退出讨论组成功");
                    UIViewController *temp = nil;
                    NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                    temp = viewControllers[viewControllers.count -1 -2];
                    if (temp) {
                        //切换主线程
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popToViewController:temp animated:YES];
                        });
                    }
                } error:^(RCErrorCode status) {
                    NSLog(@"quit discussion status is %ld",(long)status);
                    
                }];
                
            }
        }
        else if (actionSheet.tag == 1)
        {
            if (0 == buttonIndex)
            {
                [self clearHistoryMessage];
                [self.conversationDataRepository removeAllObjects];
            }
        }
        
    }
}

/**
 *  点击上面头像列表的头像
 *
 *  @param userId 用户id
 */
- (void)didTipHeaderClicked:(NSString*)userId
{
    RCDAddressBookDetailViewController* addressDetailVC = [[RCDAddressBookDetailViewController alloc] init];
    addressDetailVC.userId = userId;
    [self.navigationController pushViewController:addressDetailVC animated:YES];
}



#pragma mark - RCConversationSettingTableViewHeader Delegate
//点击最后一个+号事件
- (void)settingTableViewHeader:(RCConversationSettingTableViewHeader*)settingTableViewHeader indexPathOfSelectedItem:(NSIndexPath*)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray*)users
{
    _tableViewHeader = settingTableViewHeader;
    //点击最后一个+号,调出选择联系人UI
    if (indexPathOfSelectedItem.row == settingTableViewHeader.users.count) {
        
        RCDSelectPersonViewController* selectPersonVC = [[RCDSelectPersonViewController alloc] init];
        [selectPersonVC setSeletedUsers:users];
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [self createDiscussionOrInvokeMemberWithSelectedUsers:selectedUsers];
            }
            
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    else if (indexPathOfSelectedItem.row == settingTableViewHeader.users.count + 1)
    {
        if (settingTableViewHeader.showDeleteTip)
        {
            settingTableViewHeader.showDeleteTip = NO;
        }
        else
        {
            settingTableViewHeader.showDeleteTip = YES;
        }
        [settingTableViewHeader reloadData];
    }

}


/**
 *  override 左上角删除按钮回调
 *
 *  @param indexPath indexPath description
 */
- (void)deleteTipButtonClicked:(NSIndexPath*)indexPath
{
    RCUserInfo* user = self.users[indexPath.row];
    if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        
        return;
    }
    [[RCIMClient sharedRCIMClient] removeMemberFromDiscussion:self.targetId
                                                       userId:user.userId
                                                      success:^(RCDiscussion *discussion) {
                                                          NSLog(@"踢人成功");
                                                      } error:^(RCErrorCode status) {
                                                          NSLog(@"踢人失败");
                                                      }];
}


#pragma mark -- ContactDetailDataDelegate
- (void)getContactDetail:(ESUserDetailInfo *)userDetailInfo
{
    RCUserInfo* rcUserInfo = [[RCUserInfo alloc] init];
    rcUserInfo.userId = userDetailInfo.userId;
    rcUserInfo.name = userDetailInfo.userName;
    rcUserInfo.portraitUri = userDetailInfo.portraitUri;
    if (rcUserInfo != nil && ![rcUserInfo isEqual:[NSNull null]])
    {
        [self.userIdList addObject:rcUserInfo];
    }
    [self addUsers:self.userIdList];
}
- (void)getContactDetailFailed:(NSString*)errorMessage
{
    
}


/**
 *  override
 *
 *  @param 添加顶部视图显示的user,必须继承以调用父类添加user
 */
- (void)addUsers:(NSArray*)users
{
    [super addUsers:users];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.defaultCells.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.row) {
        case 0:
        {
            RCDDiscussSettingCell *discussCell = [[RCDDiscussSettingCell alloc] initWithFrame:CGRectZero];
            discussCell.lblDiscussName.text = self.conversationTitle;
            discussCell.lblTitle.text = @"讨论组名称";
            cell = discussCell;
//            _discussTitle = discussCell.lblDiscussName.text;
        }
            break;
        case 1: {
            cell = self.defaultCells[0];
        } break;
        case 2: {
            cell = self.defaultCells[1];
            
        } break;
//        case 3: {
//            cell = self.defaultCells[2];
//            
//        } break;
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        RCDDiscussSettingCell* discussCell = (RCDDiscussSettingCell*)[tableView cellForRowAtIndexPath:indexPath];
        discussCell.lblTitle.text = @"讨论组名称";
        
        RCDUpdateNameViewController* updateNameViewController = [[RCDUpdateNameViewController alloc] init];
        updateNameViewController.targetId = self.targetId;
        updateNameViewController.displayText = discussCell.lblDiscussName.text;
//        updateNameViewController.setDisplayTextCompletion = ^(NSString* text) {
//            discussCell.lblDiscussName.text = text;
//            _discussTitle = text;
//        };
//        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:updateNameViewController];
//        [self.navigationController presentViewController:navi animated:YES completion:nil];
        [self.navigationController pushViewController:updateNameViewController animated:YES];

    }
}


#pragma mark - setters&getters

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)userIdList{
    if (!_userIdList) {
        _userIdList = [[NSMutableArray alloc] init];
    }
    return _userIdList;
    
}
@end
