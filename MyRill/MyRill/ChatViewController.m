//
//  ChatViewController.m
//  MyRill
//
//  Created by Steve on 15/6/24.
//
//

#import "ChatViewController.h"
#import "ChatSettingViewController.h"
#import "RCDAddressBookDetailViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableSaveNewPhotoToLocalSystem = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"duihua_liaotianxiangqing"]style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(rightBarButtonItemPressed:)];

    self.navigationItem.rightBarButtonItem = rightButton;
//    self.title = self.conversation.conversationTitle;
    [self initConversationInfo];
}

-(void) initConversationInfo
{
    if (self.conversationType == ConversationType_DISCUSSION)
    {
        //        __weak RCSettingViewController* weakSelf = self;
        [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion* discussion) {
            if (discussion) {
                self.title = discussion.discussionName;
            }
        } error:^(RCErrorCode status){
            
        }];
    }

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
    ChatSettingViewController* chatSettingVC = [[ChatSettingViewController alloc] init];
    chatSettingVC.conversationType = self.conversationType;
    chatSettingVC.targetId = self.targetId;
    chatSettingVC.conversationTitle = self.userName;

    [self.navigationController pushViewController:chatSettingVC animated:YES];
}

/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId
{
    RCDAddressBookDetailViewController* addressDetailVC = [[RCDAddressBookDetailViewController alloc] init];
    addressDetailVC.userId = userId;
    [self.navigationController pushViewController:addressDetailVC animated:YES];

}

#pragma mark-setter&getter
- (NSMutableArray *)userIDList
{
    if (!_userIDList) {
        _userIDList = [[NSMutableArray alloc] init];
    }
    return _userIDList;
}


@end
