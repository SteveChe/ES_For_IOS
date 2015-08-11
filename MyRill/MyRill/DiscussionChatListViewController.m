//
//  DiscussionChatListViewController.m
//  MyRill
//
//  Created by Steve on 15/8/10.
//
//

#import "DiscussionChatListViewController.h"
#import "UIColor+RCColor.h"
#import "ChatViewController.h"

@interface DiscussionChatListViewController ()

@end

@implementation DiscussionChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"多人聊天组";
    
    [self setDisplayConversationTypes:@[@(ConversationType_DISCUSSION)]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.conversationListTableView.tableFooterView = [UIView new];
    
    CGRect frame = self.conversationListTableView.frame;
    frame.size.height += self.tabBarController.tabBar.frame.size.height;
    self.conversationListTableView.frame = frame;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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


    
}

@end
