//
//  EnterpriseChatListViewController.m
//  MyRill
//
//  Created by Steve on 15/8/6.
//
//

#import "EnterpriseChatListViewController.h"
#import "GetEnterpriseMessageDataParse.m"
#import "RCDChatListCell.h"
#import "DeviceInfo.h"
#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import "RootViewController.h"


@interface EnterpriseChatListViewController ()<GetALLEnterpriseLastestMessageListDelegate>
@property (nonatomic,strong)GetEnterpriseMessageDataParse* getEnterpriseMessageDataParse;
@property (nonatomic,strong)NSMutableArray* myDataSource;
@property (nonatomic,strong)NSMutableArray* enterpriseMessageList;

-(void)updateEnterpriseLatestMessageList;
@end

@implementation EnterpriseChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业消息列表";

    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_SYSTEM),@(ConversationType_APPSERVICE)]];
    //聚合会话类型
//    [self setCollectionConversationType:@[@(ConversationType_SYSTEM),@(ConversationType_APPSERVICE)]];
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
//    self.conversationListTableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
    _getEnterpriseMessageDataParse = [[GetEnterpriseMessageDataParse alloc] init];
    _getEnterpriseMessageDataParse.getAllEnterpriseLastestMessageListDelegate = self;
    _myDataSource = [NSMutableArray new];
    _enterpriseMessageList = [NSMutableArray new];
    
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

    [self updateEnterpriseLatestMessageList];
}

-(void)updateEnterpriseLatestMessageList
{
    [_getEnterpriseMessageDataParse getAllEnterpriseLastestMessageList];
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
    ESEnterpriseMessage* enterpriseMessage = [self.enterpriseMessageList objectAtIndex:indexPath.row];
    //RCDChatListCell
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ESEnterpriseCell"];
    [cell setModel:model];
    if (enterpriseMessage.send_enterprise!=nil)
    {
        cell.lblName.text = enterpriseMessage.send_enterprise.enterpriseName;
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:enterpriseMessage.send_enterprise.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    }
    if (enterpriseMessage.bSuggestion)
    {
        cell.lblDetail.text = enterpriseMessage.suggetstionText;
    }
    else if (enterpriseMessage.enterprise_messageContent != nil)
    {
        
        cell.lblDetail.text = enterpriseMessage.enterprise_messageContent.title;

    }
    if (enterpriseMessage.message_time!=nil)
    {
        cell.timeLabel.text = [DeviceInfo getShowTime:enterpriseMessage.message_time];
    }


    return cell;
}

/**
 *  表格选中事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath
{
    ESEnterpriseMessage* enterpriseMessage = [self.enterpriseMessageList objectAtIndex:indexPath.row];
    RootViewController* enterpriseChatVC = [[RootViewController alloc] init];
    enterpriseChatVC.title = @"企业消息";
    if (enterpriseMessage.send_enterprise!=nil)
    {
        enterpriseChatVC.title = enterpriseMessage.send_enterprise.enterpriseName;
        enterpriseChatVC.enterpriseId = enterpriseMessage.send_enterprise.enterpriseId;
    }
    
    enterpriseChatVC.chatType = e_Enterprise_Chat_Enterprise;
    [self.navigationController pushViewController:enterpriseChatVC animated:YES];
}

//*********************插入自定义Cell*********************//

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    [dataSource removeAllObjects];
    if (_myDataSource == nil || [_myDataSource count] <= 0)
    {
        return dataSource;
    }
    for (int i=0; i<_myDataSource.count; i++)
    {
        RCConversationModel *customModel =[_myDataSource objectAtIndex:i];
        [dataSource addObject:customModel];
    }
    
    return dataSource;
}


#pragma mark-- GetALLEnterpriseLastestMessageListDelegate
-(void)getALLEnterpriseLastestMessageListSucceed:(NSArray*)enterpriseList
{
    if (enterpriseList == nil || [enterpriseList count] <= 0)
    {
        return;
    }
    [_myDataSource removeAllObjects];
    [_enterpriseMessageList removeAllObjects];
    for (ESEnterpriseMessage* enterpriseMessage in enterpriseList)
    {
        if (enterpriseMessage == nil)
        {
            continue;
        }
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

        [_myDataSource addObject:enterpriseModel ];
        [_enterpriseMessageList addObject:enterpriseMessage];
            
    }    
  
    [self refreshConversationTableViewIfNeeded];

}
-(void)getALLEnterpriseLastestMessageListFailed:(NSString*)errorMessage
{
    
}


@end
