//
//  RootViewController.m
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import "RootViewController.h"

#import "RootFunctionView.h"
#import "RootTimeCell.h"
#import "RootImageCell.h"
#import "RootOutChatCell.h"
#import "RootCardTopCell.h"
#import "RootCardMiddleCell.h"
#import "RootCardBottomCell.h"
#import "RootIncomeChatCell.h"

#import "ESEnterpriseInfo.h"
#import "ESEnterpriseMessage.h"
#import "ESEnterpriseMessageContent.h"
#import "ESUserInfo.h"
#import "CustomShowMessage.h"
#import "RCDAddressBookEnterpriseDetailViewController.h"
#import "RCDAddressBookDetailViewController.h"
#import "GetEnterpriseMessageDataParse.h"
#import "DeviceInfo.h"
#import "ProfessionWebViewController.h"
#import "PushDefine.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,GetRILLMessageListDelegate,ReplyToRILLMessageDelegate,GetOneEnterpriseMessageListDelegate,ReplyToOneEnterpriseMessageDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionPanelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardPanelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionPanelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *keyboard;
@property (nonatomic, weak) IBOutlet RootFunctionView *actionView;
@property (nonatomic, strong) UIButton *sender;
//----
@property (nonatomic,strong)GetEnterpriseMessageDataParse *getEnterpriseMessageDataParse;
@property (nonatomic,strong)ESEnterpriseInfo * enterprise;
@property (nonatomic,strong)ESUserInfo * userInfo;
@property (nonatomic,strong)NSString* lastInputText;
-(void)updateEnterpriseChatInfoList;
/**
 *  conversationDataRepository
 */
@property(nonatomic, strong) NSMutableArray *conversationDataRepository;


- (void)keyboardWillShow:(NSNotification *)notif;
- (void)keyboardWillHide:(NSNotification *)notif;
- (void)refreshData:(NSNotification *)notif;

- (IBAction)onClickOnShowFunctionPanel:(UIButton *)sender;
- (IBAction)onClickOnShowKeyboardPanel:(UIButton *)sender;

- (IBAction)showPanel:(UIButton *)sender;

@end

@implementation RootViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_PUSH_ENTERPRISE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFIACATION_PUSH_RIIL_MESSAGE object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_actionView setHidden:YES];
    [self.view addSubview:_actionView];
    [_actionView setData:@[@"123", @"123345", @"adsflk", @"123345"]];
    [_actionView setSelectionAction:^(NSString *stringData) {
        [_actionView dismiss];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:NOTIFICATION_PUSH_ENTERPRISE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:NOTIFIACATION_PUSH_RIIL_MESSAGE object:nil];

    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RootImageCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RootImageCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RootOutChatCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RootOutChatCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RootIncomeChatCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RootIncomeChatCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RootTimeCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RootTimeCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RootCardTopCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RootCardTopCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RootCardMiddleCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RootCardMiddleCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RootCardBottomCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RootCardBottomCell class])];
    [self.view bringSubviewToFront:_actionView];
    [self.view bringSubviewToFront:_functionView];
    
    _getEnterpriseMessageDataParse = [[GetEnterpriseMessageDataParse alloc] init];
    _getEnterpriseMessageDataParse.getRillMessageListDelegate = self;
    _getEnterpriseMessageDataParse.replyToRillMessageDelegate = self;
    _getEnterpriseMessageDataParse.getOneEnterpriseMessageListDelegate = self;
    _getEnterpriseMessageDataParse.replyToOneEnterpriseMessageDelegate = self;

    _conversationDataRepository = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;

    if(_chatType == e_Enterprise_Chat_Enterprise)
    {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"duihua_liaotianxiangqing"]style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(rightBarButtonItemPressed:)];
        
        self.navigationItem.rightBarButtonItem = rightButton;
    }

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



#pragma mark -- UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 4;

   return [self.conversationDataRepository count] * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    ESEnterpriseMessage* enterpriseMessage = [self.conversationDataRepository objectAtIndex:(indexPath.row / 2)];
    if (enterpriseMessage == nil)
    {
        return cell;
    }
    
    if (indexPath.row % 2 == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootTimeCell class])];

        [(RootTimeCell *)cell setCellData:[DeviceInfo getShowTime:enterpriseMessage.message_time]];
    }
    else
    {
        if (enterpriseMessage.bSuggestion)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootOutChatCell class])];
            [(RootOutChatCell *)cell setMsgData:enterpriseMessage.suggetstionText image:enterpriseMessage.receiver_userInfo.portraitUri];
        }
        else
        {
            if (enterpriseMessage.enterprise_messageContent.bLink)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootImageCell class])];
                
                [(RootImageCell *)cell setTitle:enterpriseMessage.enterprise_messageContent.title image:enterpriseMessage.enterprise_messageContent.imageUrl instruction:enterpriseMessage.enterprise_messageContent.content];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootIncomeChatCell class])];
                [(RootIncomeChatCell *)cell setMsgData:enterpriseMessage.enterprise_messageContent.title image:enterpriseMessage.send_enterprise.portraitUri];

            }
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    ESEnterpriseMessage* enterpriseMessage = [self.conversationDataRepository objectAtIndex:(indexPath.row / 2)];
    if (enterpriseMessage == nil)
    {
        return 0;
    }
    
    if (indexPath.row % 2 == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootTimeCell class])];
        
        [(RootTimeCell *)cell setCellData:[DeviceInfo getShowTime:enterpriseMessage.message_time]];
    }
    else
    {
        if (enterpriseMessage.bSuggestion)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootOutChatCell class])];
            [(RootOutChatCell *)cell setMsgData:enterpriseMessage.suggetstionText image:enterpriseMessage.receiver_userInfo.portraitUri];
        }
        else
        {
            if (enterpriseMessage.enterprise_messageContent.bLink)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootImageCell class])];
                
                [(RootImageCell *)cell setTitle:enterpriseMessage.enterprise_messageContent.title image:enterpriseMessage.enterprise_messageContent.imageUrl instruction:enterpriseMessage.enterprise_messageContent.content];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RootIncomeChatCell class])];
                [(RootIncomeChatCell *)cell setMsgData:enterpriseMessage.enterprise_messageContent.title image:enterpriseMessage.send_enterprise.portraitUri];
                
            }
        }
        
    }
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESEnterpriseMessage* enterpriseMessage = [self.conversationDataRepository objectAtIndex:(indexPath.row / 2)];
    if (enterpriseMessage == nil)
    {
        return ;
    }
    
    if (enterpriseMessage.enterprise_messageContent.bLink)
    {
        ProfessionWebViewController* professionWebVC = [[ProfessionWebViewController alloc] init];
        professionWebVC.urlString = enterpriseMessage.enterprise_messageContent.linkUrl;
        [self.navigationController pushViewController:professionWebVC animated:YES];
    }
}


- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = CGRectGetHeight(rect);
    [_functionViewBottomConstraint setConstant:y];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    [_functionViewBottomConstraint setConstant:0.0f];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)refreshData:(NSNotification *)notif
{
    [self updateEnterpriseChatInfoList];
}


- (IBAction)onClickOnShowFunctionPanel:(id)sender
{
    return;
    // 暂时不添加功能菜单
//    [_keyboard resignFirstResponder];
//    [_keyboardPanelTopConstraint setConstant:-_functionPanelHeightConstraint.constant];
//    [_functionPanelTopConstraint setConstant:0.0f];
//    [UIView animateWithDuration:0.3f animations:^{
//        [_functionView layoutSubviews];
//    }];
}

- (IBAction)onClickOnShowKeyboardPanel:(UIButton *)sender
{
    [_keyboardPanelTopConstraint setConstant:0.0f];
    [_functionPanelTopConstraint setConstant:-_functionPanelHeightConstraint.constant];
    [UIView animateWithDuration:0.3f animations:^{
        [_functionView layoutSubviews];
    }];
}

- (IBAction)showPanel:(UIButton *)sender
{
    if (sender != _sender || _actionView.hidden) {
        [self setSender:sender];
        CGRect pt = [self.view convertRect:sender.frame fromView:_functionView];
        [_actionView showInPoint:CGPointMake((CGRectGetMinX(pt) + CGRectGetWidth(pt) / 2), CGRectGetMinY(pt) + 10.0f)];
    } else {
        [_actionView dismiss];
    }
}

#pragma mark-  GetRILLMessageListDelegate
-(void)getRILLMessageSucceed:(NSArray*)enterpriseMessageList
{
    if (enterpriseMessageList == nil || [enterpriseMessageList count] <= 0)
    {
        return;
    }
    
    [self.conversationDataRepository removeAllObjects];
    for (ESEnterpriseMessage* enterpriseMessage in enterpriseMessageList)
    {
        [self.conversationDataRepository insertObject:enterpriseMessage atIndex:0];
    }
    
    if ([self.conversationDataRepository count] > 0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversationDataRepository.count-1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        });
        
    }
}
-(void)getRILLMessageFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"消息获取失败!"];
}
#pragma mark-  ReplyToRILLMessageDelegate
-(void)replyToRillMessageSucceed
{
    [self updateEnterpriseChatInfoList];
}
-(void)replyToRillMessageFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"抱歉消息没有发送成功!"];
}

#pragma mark - GetOneEnterpriseMessageListDelegate
-(void)getOneEnterpriseMessageListSucceed:(NSArray*)enterpriseMessageList
{
    if (enterpriseMessageList == nil || [enterpriseMessageList count] <= 0)
    {
        return;
    }
    
    if (enterpriseMessageList == nil || [enterpriseMessageList count] <= 0)
    {
        return;
    }
    
    [self.conversationDataRepository removeAllObjects];
    for (ESEnterpriseMessage* enterpriseMessage in enterpriseMessageList)
    {
        [self.conversationDataRepository insertObject:enterpriseMessage atIndex:0];
    }
    
    if ([self.conversationDataRepository count] > 0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversationDataRepository.count * 2 -1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        });
        
    }
}
-(void)getOneEnterpriseMessageListFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"消息获取失败!"];
}
#pragma mark - ReplyToOneEnterpriseMessageDelegate
-(void)replyOneEnterpriseMessageSucceed
{
    [self updateEnterpriseChatInfoList];
}
-(void)replyOneEnterpriseMessageFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"抱歉消息没有发送成功!"];
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


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversationDataRepository.count * 2 -1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_chatType == e_Enterprise_Chat_Riil)
    {
        [_getEnterpriseMessageDataParse replyToRillMessage:textField.text];
    }
    else if (_chatType == e_Enterprise_Chat_Enterprise)
    {
        [_getEnterpriseMessageDataParse replyToOneEnterpriseMessage:_enterpriseId content:textField.text];
    }
    
//    ESEnterpriseMessage* enterpriseMessage = [[ESEnterpriseMessage alloc] init];
//    enterpriseMessage.bSuggestion = YES;
//    enterpriseMessage.suggetstionText = textField.text;
//    
//    enterpriseMessage.message_time = [NSDate date];
//    
//    [self.conversationDataRepository addObject:enterpriseMessage];
//    [self.tableView reloadData];
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversationDataRepository.count-1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    [self textFieldShouldClear:textField];
    return YES;
}

@end