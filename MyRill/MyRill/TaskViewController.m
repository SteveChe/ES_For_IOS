//
//  TaskViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/6.
//
//
#import <RongIMKit/RongIMKit.h>
#import "TaskViewController.h"
#import "ColorHandler.h"
#import "Masonry.h"
#import "ESTask.h"
#import "EditTaskDataParse.h"
#import "ESContactor.h"
#import "MessageListViewController.h"
#import "ESTagViewController.h"
#import "CustomShowMessage.h"
#import "ESUserInfo.h"
#import "RCDSelectPersonViewController.h"
#import "ChatViewController.h"
#import "TaskContactorCollectionViewCell.h"

@interface TaskViewController () <EditTaskDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLbl;
@property (weak, nonatomic) IBOutlet UISwitch *taskStatusSwitch;
@property (nonatomic, strong) MessageListViewController *messageListVC;
@property (nonatomic, strong) EditTaskDataParse *editTaskDP;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray* tastObserversList;//关注人列表,ESUserInfo
@property (nonatomic,strong) NSMutableArray* tastRecipientsList;//负责人列表,ESUserInfo
@property (nonatomic, assign) BOOL isOpen;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"任务详情";
    
    UIBarButtonItem *startConversationItem = [[UIBarButtonItem alloc] initWithTitle:@"会话"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(startConversationEvent)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(saveBarItemOnClicked)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem, startConversationItem, nil];
    self.isOpen = YES;

    self.messageListVC.taskID = [self.taskModel.taskID stringValue];
    [self addChildViewController:self.messageListVC];
    [self.view addSubview:self.messageListVC.view];
    
    __weak UIView *weakHeaderView = self.headerView;
    __weak UIView *ws = self.view;
    [self.messageListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakHeaderView.mas_bottom);
        make.leading.equalTo(ws.mas_leading);
        make.trailing.equalTo(ws.mas_trailing);
        make.bottom.equalTo(ws.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *startDateStr = [self.taskModel.startDate substringToIndex:10];
    self.startDateLbl.text = [@"发起时间：" stringByAppendingString:[startDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    
    self.taskTitleLbl.text = self.taskModel.title;
    
    NSString *endDateStr = [self.taskModel.endDate substringToIndex:10];
    self.endDateLbl.text = [endDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    self.taskDescriptionLbl.text = [@"任务说明：" stringByAppendingString:self.taskModel.taskDescription];
    if (self.taskModel.status.integerValue == 0) {
        //任务状态为新
        self.taskStatusSwitch.on = NO;
    } else if (self.taskModel.status.integerValue == 1) {
        //任务状态为已关闭
        self.taskStatusSwitch.on = YES;
    } else {
        
    }
    
    if (self.dataSource == nil) {
        for (ESContactor *contactor in self.taskModel.observers) {
            [self.dataSource addObject:contactor];
        }
        [self.collectionView reloadData];
    }
    
    if (self.tastRecipientsList == nil) {
        self.tastRecipientsList = [NSMutableArray array];
    }
    if (self.tastObserversList == nil) {
        self.tastObserversList = [NSMutableArray array];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - response events methods
- (void)startConversationEvent {
    //发起会话功能
    if ([self.tastRecipientsList count] <=0 ) {
        [[CustomShowMessage getInstance] showNotificationMessage:@"缺少分配人!"];
        return;
    }
    if ([self.tastObserversList count] <=0 ) {
        [[CustomShowMessage getInstance] showNotificationMessage:@"缺少关注人!"];
        return;
    }
    NSMutableArray* selectedUsers = [NSMutableArray new];
    [selectedUsers addObjectsFromArray:self.tastRecipientsList];
    [selectedUsers addObjectsFromArray:self.tastObserversList];
    NSMutableString *discussionTitle = [NSMutableString string];
    NSMutableArray *userIdList = [NSMutableArray new];
    for (ESUserInfo *user in selectedUsers) {
        [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", user.userName,@","]];
        [userIdList addObject:user.userId];
    }
    [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
    __weak typeof(&*self)  weakSelf = self;

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

}

- (IBAction)chooseTagBtnOnClicked:(UIButton *)sender {
    //标签选择
    if (_taskModel == nil) {
        return;
    }
    ESTagViewController* tagVC = [[ESTagViewController alloc] init];
    tagVC.tagType = TAG_TYPE_ASSIGNMENT;
    tagVC.taskId = [NSString stringWithFormat:@"%d",[_taskModel.taskID intValue] ];
    [self.navigationController pushViewController:tagVC animated:YES];
}

- (IBAction)chooseContactorBtnOnClicked:(UIButton *)sender {
//    负责人btn的tag是1001，关注人是1002
    if (sender.tag == 1001) {
        __weak typeof(&*self)  weakSelf = self;
        RCDSelectPersonViewController* selectPersonVC = [[RCDSelectPersonViewController alloc] init];
        [selectPersonVC setSeletedUsers:self.tastRecipientsList];
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [self.tastRecipientsList removeAllObjects];
                [self.tastRecipientsList addObjectsFromArray:selectedUsers];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES ];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    else if (sender.tag == 1002){
        RCDSelectPersonViewController* selectPersonVC = [[RCDSelectPersonViewController alloc] init];
        [selectPersonVC setSeletedUsers:self.tastObserversList];
        __weak typeof(&*self)  weakSelf = self;

        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [self.tastObserversList removeAllObjects];
                [self.tastObserversList addObjectsFromArray:selectedUsers];
                weakSelf.dataSource = nil;
                for (ESUserInfo *user in self.tastObserversList) {
                    ESContactor *contactor = [[ESContactor alloc] init];
                    contactor.useID = [NSNumber numberWithInteger:[user.userId integerValue]];
                    contactor.name = user.userName;
                    contactor.imgURLstr = user.portraitUri;
                    contactor.enterprise = user.enterprise;
                    [weakSelf.dataSource addObject:contactor];
                }
                
            }
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [self.collectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    
}

- (void)saveBarItemOnClicked {
    ESTask *task = [[ESTask alloc] init];
    task.taskID = self.taskModel.taskID;
    task.title = self.taskTitleLbl.text;
    task.endDate = self.taskModel.endDate;
    task.chatID = self.taskModel.chatID;
    task.taskDescription = self.taskModel.taskDescription;
    task.status = [NSNumber numberWithInt:1];
    task.personInCharge = self.taskModel.personInCharge;
    task.observers = self.dataSource;
    
    [self.editTaskDP EditTaskWithTaskModel:task];
}

- (IBAction)headViewBtnOnClicked:(UIButton *)sender {
    CGFloat height = self.headerView.bounds.size.height;
    
    if (self.isOpen) {
        [UIView animateWithDuration:.5f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.headerViewTopConstraint.constant = 30 - height;
                             [self.view layoutIfNeeded];
                         } completion:nil];
    } else {
        [UIView animateWithDuration:.5f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.headerViewTopConstraint.constant = 0;
                             [self.messageListVC hideKeyboard];
                             [self.view layoutIfNeeded];
                         } completion:nil];
    }
    self.isOpen = !self.isOpen;
}


- (void)headViewAnotherBtnOnClicked:(BOOL)isOpen {
    CGFloat height = self.headerView.bounds.size.height;
    
    if (isOpen) {
        [UIView animateWithDuration:.5f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.headerViewTopConstraint.constant = 30 - height;
                             [self.view layoutIfNeeded];
                         } completion:nil];
    } else {
        [UIView animateWithDuration:.5f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.headerViewTopConstraint.constant = 0;
                             [self.view layoutIfNeeded];
                         } completion:nil];
    }
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskContactorCollectionViewCell *cell = (TaskContactorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TaskContactorCollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    ESContactor *contactor = (ESContactor *)self.dataSource[indexPath.row];
    [cell updateCell:contactor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(54,54);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置Cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - setters&getters
- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"eeeeee"].CGColor;
    }
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView.collectionViewLayout = layout;
    
    UINib *professionCell = [UINib nibWithNibName:@"TaskContactorCollectionViewCell" bundle:nil];
    [_collectionView registerNib:professionCell forCellWithReuseIdentifier:@"TaskContactorCollectionViewCell"];
    _collectionView.bounces = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (EditTaskDataParse *)editTaskDP {
    if (!_editTaskDP) {
        _editTaskDP = [[EditTaskDataParse alloc] init];
        _editTaskDP.delegate = self;
    }
    
    return _editTaskDP;
}

- (MessageListViewController *)messageListVC {
    if (!_messageListVC) {
        _messageListVC = [[MessageListViewController alloc] init];
    }
    
    return _messageListVC;
}

@end
