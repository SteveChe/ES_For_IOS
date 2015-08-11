//
//  EnterpriseChatViewController.m
//  MyRill
//
//  Created by Steve on 15/8/6.
//
//

#import "EnterpriseChatViewController.h"
#import "SimpleMessage.h"
#import "SimpleMessageCell.h"
#import "GetEnterpriseMessageDataParse.h"
#import "ESEnterpriseInfo.h"
#import "ESEnterpriseMessage.h"
#import "ESEnterpriseMessageContent.h"
#import "ESUserInfo.h"
#import "CustomShowMessage.h"
#import "RCDAddressBookEnterpriseDetailViewController.h"
#import "RCDAddressBookDetailViewController.h"

@interface EnterpriseChatViewController ()<GetRILLMessageListDelegate,ReplyToRILLMessageDelegate,GetOneEnterpriseMessageListDelegate,ReplyToOneEnterpriseMessageDelegate>
@property (nonatomic,strong)GetEnterpriseMessageDataParse *getEnterpriseMessageDataParse;
@property (nonatomic,strong)ESEnterpriseInfo * enterprise;
@property (nonatomic,strong)ESUserInfo * userInfo;
@property (nonatomic,strong)NSString* lastInputText;
-(void)updateEnterpriseChatInfoList;

@end

@implementation EnterpriseChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
//    [self initEnterpriseChatInfoList];
//    self.isNeedToShowCustomMessage = YES;
    self.enableSaveNewPhotoToLocalSystem = NO;

    [self.pluginBoardView setHidden:YES];
    [self.emojiBoardView setHidden:YES];
    [self registerClass:SimpleMessageCell.class forCellWithReuseIdentifier:@"SimpleMessageCell"];
    
    _getEnterpriseMessageDataParse = [[GetEnterpriseMessageDataParse alloc] init];
    _getEnterpriseMessageDataParse.getRillMessageListDelegate = self;
    _getEnterpriseMessageDataParse.replyToRillMessageDelegate = self;
    _getEnterpriseMessageDataParse.getOneEnterpriseMessageListDelegate = self;
    _getEnterpriseMessageDataParse.replyToOneEnterpriseMessageDelegate = self;
//    [self initEnterpriseChatInfoList];
//    self.defaultHistoryMessageCountOfChatRoom = 50;
//    self.conversationMessageCollectionView.alwaysBounceVertical = YES;
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"duihua_liaotianxiangqing"]style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(rightBarButtonItemPressed:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    //    self.title = self.conversation.conversationTitle;
//    [self initEnterpriseChatInfoList];
    [self updateEnterpriseChatInfoList];
    
}
-(void)updateEnterpriseChatInfoList
{
    if (_chatType == e_Enterprise_Chat_Riil)
    {
        [_getEnterpriseMessageDataParse getRillMessageList];
    }
    else if(_chatType == e_Enterprise_Chat_Enterprise)
    {
        [_getEnterpriseMessageDataParse getOneEnterpriseMessage:_enterpriseId];
    }
        
}


-(void)initEnterpriseChatInfoList
{
//    [self.conversationDataRepository removeAllObjects];
    SimpleMessage* messageContent = [SimpleMessage messageWithContent:@"hsafasfasfasasfasdasfdadasdhsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdelloello"];
//    RCUserInfo *senderUserInfo = [[RCUserInfo alloc] init];
//    senderUserInfo.userId = @"2";
//    senderUserInfo.name = @"18601929217";
//    senderUserInfo.portraitUri = @"http://120.25.249.144/media/avatar_img/0S/20150726134208.png";
//    messageContent.senderUserInfo = senderUserInfo;
    
    
    RCMessage * rcMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:@"3" direction:MessageDirection_RECEIVE messageId:12345679 content:messageContent];
    RCMessageModel *model1 = [[RCMessageModel alloc] initWithMessage:rcMessage];
    model1.receivedTime = 1438868551;
    model1.objectName = @"RC:TxtMsg";
    
    [self.conversationDataRepository insertObject:model1 atIndex:0];

    
    SimpleMessage* messageContent2 = [SimpleMessage messageWithContent:@"hello\n hello \n lllhsafasfasfasasfasdasfdadasdhsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdellohsafasfasfasasfasdasfdadasdelloello"];
    RCMessage * rcMessage2 = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:@"3" direction:MessageDirection_RECEIVE messageId:12345679 content:messageContent2];

    RCMessageModel *model2 = [[RCMessageModel alloc] initWithMessage:rcMessage2];
    model2.receivedTime = 1438868558;
    model2.objectName = @"RC:TxtMsg";
    
//    [self.conversationDataRepository addObject:model2];
    [self.conversationDataRepository insertObject:model2 atIndex:0];
    [self.conversationMessageCollectionView reloadData];
//    NSIndexPath* index =  [NSIndexPath indexPathWithIndex:self.conversationDataRepository.count];
}

/**
 *  重写方法实现自定义消息的显示
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    NSString * cellIndentifier = @"SimpleMessageCell";
    SimpleMessageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier           forIndexPath:indexPath];
//    cell.messageTimeLabel.text = @"123456";
//    cell.messageDirection = MessageDirection_RECEIVE;
    [cell setDataModel:model];
    
//    [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    return cell;
}

-(CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessageModel *messageModel = self.conversationDataRepository[indexPath.row];
    if (messageModel == nil) {
        return CGSizeMake(0, 0);
    }
    
//    CGSize oneLineSysSize = [@"测试" sizeWithFont:[UIFont systemFontOfSize:Text_Message_Font_Size]];
    NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:Text_Message_Font_Size], NSFontAttributeName,
                                          nil];
    
    // 通过系统绘制
    SimpleMessage* messageContent = (SimpleMessage*)messageModel.content;
    CGSize sysSize = [messageContent.content boundingRectWithSize:CGSizeMake(200, 10000) options:option attributes:attributesDictionary context:nil].size;

    //返回自定义cell的实际高度
    CGSize size = CGSizeMake(380, sysSize.height+50);
    return size;
}
- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent
{
//       NSLog(@"%@",_inputView.text);

    if (_chatType == e_Enterprise_Chat_Riil)
    {
        [_getEnterpriseMessageDataParse replyToRillMessage:_lastInputText];
    }
    else if (_chatType == e_Enterprise_Chat_Enterprise)
    {
        [_getEnterpriseMessageDataParse replyToOneEnterpriseMessage:_enterpriseId content:_lastInputText];
    }
    RCMessage * rcMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:_userInfo.userId direction:MessageDirection_SEND messageId:[[NSDate date] timeIntervalSince1970] content:messageContent];
    RCMessageModel *model = [[RCMessageModel alloc] initWithMessage:rcMessage];
    [self.conversationDataRepository addObject:model];
    [self.conversationMessageCollectionView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversationDataRepository.count-1 inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    
//    NSLog(@"sendMessage");
}

- (void)sendImageMessage:(RCImageMessage *)imageMessage pushContent:(NSString *)pushContent
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"图片功能暂不支持"];
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

#pragma mark-  GetRILLMessageListDelegate
-(void)getRILLMessageSucceed:(NSArray*)enterpriseMessageList
{
    if (enterpriseMessageList == nil || [enterpriseMessageList count] <= 0)
    {
        return;
    }
    
    for (ESEnterpriseMessage* enterpriseMessage in enterpriseMessageList)
    {
        _enterprise = enterpriseMessage.send_enterprise;
        _userInfo = enterpriseMessage.receiver_userInfo;
        if (enterpriseMessage == nil)
        {
            continue;
        }
        NSString* contentString = nil;
        RCMessage * rcMessage = nil;
        SimpleMessage* messageContent = nil;
        NSString* nickName = nil;
        if (enterpriseMessage.bSuggestion)
        {
            contentString = enterpriseMessage.suggetstionText;
            messageContent = [SimpleMessage messageWithContent:contentString];
            rcMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:enterpriseMessage.receiver_userInfo.userId direction:MessageDirection_SEND messageId:[enterpriseMessage.message_id intValue] content:messageContent];
            nickName = enterpriseMessage.receiver_userInfo.userName;

        }
        else
        {
            if(enterpriseMessage.enterprise_messageContent != nil)
            {
                contentString = enterpriseMessage.enterprise_messageContent.content;
                messageContent = [SimpleMessage messageWithContent:contentString];
                rcMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:enterpriseMessage.receiver_userInfo.userId direction:MessageDirection_RECEIVE messageId:[enterpriseMessage.message_id intValue] content:messageContent];
                nickName = enterpriseMessage.send_enterprise.enterpriseName;
            }
        }
        RCMessageModel *templeModel = [[RCMessageModel alloc] initWithMessage:rcMessage];
        templeModel.isDisplayNickname = YES;
        templeModel.isDisplayMessageTime = NO;
        templeModel.objectName = @"RC:TxtMsg";

        if (enterpriseMessage.message_time!=nil)
        {
            templeModel.receivedTime = [enterpriseMessage.message_time timeIntervalSince1970];
        }
        [self.conversationDataRepository insertObject:templeModel atIndex:0];

    }
    if ([self.conversationDataRepository count] > 0)
    {
        [self.conversationMessageCollectionView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversationDataRepository.count-1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}
-(void)getRILLMessageFailed:(NSString*)errorMessage
{
    
}
#pragma mark-  ReplyToRILLMessageDelegate
-(void)replyToRillMessageSucceed
{
    
}
-(void)replyToRillMessageFailed:(NSString*)errorMessage
{
    
}

#pragma mark - GetOneEnterpriseMessageListDelegate
-(void)getOneEnterpriseMessageListSucceed:(NSArray*)enterpriseMessageList
{
    if (enterpriseMessageList == nil || [enterpriseMessageList count] <= 0)
    {
        return;
    }
    
    for (ESEnterpriseMessage* enterpriseMessage in enterpriseMessageList)
    {
        _enterprise = enterpriseMessage.send_enterprise;
        _userInfo = enterpriseMessage.receiver_userInfo;
        if (enterpriseMessage == nil)
        {
            continue;
        }
        NSString* contentString = nil;
        RCMessage * rcMessage = nil;
        SimpleMessage* messageContent = nil;
        NSString* nickName = nil;
        NSString* portraitImageUrl = nil;
        NSString* userId = nil;
        if (enterpriseMessage.bSuggestion)
        {
            contentString = enterpriseMessage.suggetstionText;
            messageContent = [SimpleMessage messageWithContent:contentString];
            rcMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:enterpriseMessage.receiver_userInfo.userId direction:MessageDirection_SEND messageId:[enterpriseMessage.message_id intValue] content:messageContent];
            nickName = enterpriseMessage.receiver_userInfo.userName;
            portraitImageUrl = enterpriseMessage.receiver_userInfo.portraitUri;
            userId = enterpriseMessage.receiver_userInfo.userId;
        }
        else
        {
            if(enterpriseMessage.enterprise_messageContent != nil)
            {
                contentString = enterpriseMessage.enterprise_messageContent.content;
                messageContent = [SimpleMessage messageWithContent:contentString];
                rcMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:enterpriseMessage.receiver_userInfo.userId direction:MessageDirection_RECEIVE messageId:[enterpriseMessage.message_id intValue] content:messageContent];
                nickName = enterpriseMessage.send_enterprise.enterpriseName;
                portraitImageUrl = enterpriseMessage.send_enterprise.portraitUri;
                userId = enterpriseMessage.send_enterprise.enterpriseId;
            }
        }
        RCMessageModel *templeModel = [[RCMessageModel alloc] initWithMessage:rcMessage];

        templeModel.isDisplayNickname = YES;
        templeModel.isDisplayMessageTime = NO;
        templeModel.objectName = @"RC:TxtMsg";
        
        RCUserInfo* userInfo = [[RCUserInfo alloc] init];
        userInfo.name = nickName;
        userInfo.portraitUri = portraitImageUrl;
        userInfo.userId = userId;
        templeModel.userInfo = userInfo;
        templeModel.content.senderUserInfo = userInfo;
        
        if (enterpriseMessage.message_time!=nil)
        {
            templeModel.receivedTime = [enterpriseMessage.message_time timeIntervalSince1970];
        }
        [self.conversationDataRepository insertObject:templeModel atIndex:0];
        
    }
    if ([self.conversationDataRepository count] > 0)
    {
        [self.conversationMessageCollectionView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversationDataRepository.count-1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }

}
-(void)getOneEnterpriseMessageListFailed:(NSString*)errorMessage
{
    
}
#pragma mark - ReplyToOneEnterpriseMessageDelegate
-(void)replyOneEnterpriseMessageSucceed
{
    
}
-(void)replyOneEnterpriseMessageFailed:(NSString*)errorMessage
{
    
}



#pragma mark - response events
/**
 *  重载右边导航按钮的事件
 *
 *  @param sender
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    if (_enterpriseId == nil || [_enterpriseId length] <= 0)
    {
        return;
    }
    RCDAddressBookEnterpriseDetailViewController* addressBookEnterpriseDetailVC = [[RCDAddressBookEnterpriseDetailViewController alloc] init];
    addressBookEnterpriseDetailVC.enterpriseId = _enterpriseId;
    [self.navigationController pushViewController:addressBookEnterpriseDetailVC animated:YES];
}
/**
 *  重写方法，输入框监控方法
 *
 *  @param inputTextView inputTextView 输入框
 *  @param range         range 范围
 *  @param text          text 文本
 */
- (void)inputTextView:(UITextView *)inputTextView
shouldChangeTextInRange:(NSRange)range
      replacementText:(NSString *)text
{
    _lastInputText = inputTextView.text;
//    NSLog(@"%@",inputTextView.text);
}



@end
