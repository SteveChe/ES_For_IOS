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

@interface EnterpriseChatViewController ()

@end

@implementation EnterpriseChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
//    [self initEnterpriseChatInfoList];
//    self.isNeedToShowCustomMessage = YES;
    self.enableSaveNewPhotoToLocalSystem = YES;
    
    [self registerClass:SimpleMessageCell.class forCellWithReuseIdentifier:@"SimpleMessageCell"];
    

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
    [self initEnterpriseChatInfoList];
}

-(void)initEnterpriseChatInfoList
{
    [self.conversationDataRepository removeAllObjects];
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
    [self.conversationDataRepository addObject:model1];

    
    SimpleMessage* messageContent2 = [SimpleMessage messageWithContent:@"hello"];
    RCMessage * rcMessage2 = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:@"3" direction:MessageDirection_RECEIVE messageId:12345679 content:messageContent2];

    RCMessageModel *model2 = [[RCMessageModel alloc] initWithMessage:rcMessage2];
    model2.receivedTime = 1438868558;
    model2.objectName = @"RC:TxtMsg";
    
    [self.conversationDataRepository addObject:model2];
    [self.conversationMessageCollectionView reloadData];


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
    return cell;
}

-(CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回自定义cell的实际高度
    return CGSizeMake(380, 200);
}
- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent
{
    //    RCUserInfo *senderUserInfo = [[RCUserInfo alloc] init];
    //    senderUserInfo.userId = @"2";
    //    senderUserInfo.name = @"18601929217";
    //    senderUserInfo.portraitUri = @"http://120.25.249.144/media/avatar_img/0S/20150726134208.png";
    //    messageContent.senderUserInfo = senderUserInfo;
    //    NSString* jsonStr = @"{'content':'hello!' }";
    //    NSData *aData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
    //    messageContent.rawJSONData = aData;
    RCMessage * rcMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:@"3" direction:MessageDirection_SEND messageId:12345678 content:messageContent];
    RCMessageModel *model = [[RCMessageModel alloc] initWithMessage:rcMessage];
    model.sentTime = 1438868551;
    [self.conversationDataRepository addObject:model];
    [self.conversationMessageCollectionView reloadData];
    
    NSLog(@"sendMessage");
}


@end
