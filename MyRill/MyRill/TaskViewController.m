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
#import "ESTagViewController.h"
#import "CustomShowMessage.h"
#import "ESUserInfo.h"
#import "RCDSelectPersonViewController.h"
#import "ChatViewController.h"
#import "GetTaskCommentListDataParse.h"
#import "SendTaskCommentDataParse.h"
#import "TaskContactorCollectionViewCell.h"
#import "MessageListSelfTableViewCell.h"
#import "MessageListTableViewCell.h"
#import "ESTaskComment.h"
#import "CloseTaskDataParse.h"
#import "MRProgress.h"
#import "GetTaskDetailDataParse.h"
#import "ChatViewController.h"

@interface TaskViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, GetTaskCommentListDelegate, UITextFieldDelegate, SendTaskCommenDelegate, EditTaskDelegate, CloseTaskDelegate, GetTaskDetailDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *txtHoldViews;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *taskTitleTxtField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptioinTextView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (nonatomic, strong) UIDatePicker *dateSelectedPicker;
@property (weak, nonatomic) IBOutlet UISwitch *taskStatusSwitch;
@property (weak, nonatomic) IBOutlet UICollectionView *assignerCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *followsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UITextField *sendTxtfield;
@property (nonatomic, strong) MRProgressOverlayView *progress;

@property (nonatomic, strong) NSMutableArray *assignerDataSource;
@property (nonatomic, strong) NSMutableArray *followsDataSource;
@property (nonatomic,strong) NSMutableArray* tastObserversList;//关注人列表,ESUserInfo
@property (nonatomic,strong) NSMutableArray* tastRecipientsList;//负责人列表,ESUserInfo
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) GetTaskDetailDataParse *getTaskDetailDP;
@property (nonatomic, strong) GetTaskCommentListDataParse *getTaskCommentListDP;
@property (nonatomic, strong) EditTaskDataParse *editTaskDP;
@property (nonatomic, strong) SendTaskCommentDataParse *sendTaskCommentDP;
@property (nonatomic, strong) CloseTaskDataParse *closeTaskDP;

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, assign) BOOL isOpen;

@end

@implementation TaskViewController
#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"任务详情";
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.dateSelectedPicker];
    
    __weak UIView *ws = self.view;
    [self.dateSelectedPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ws.mas_leading);
        make.trailing.equalTo(ws.mas_trailing);
        make.bottom.equalTo(ws.mas_bottom).with.offset(216);
        make.height.equalTo(@216);
    }];
    
    [self.view layoutIfNeeded];
    
    if (self.tastRecipientsList == nil) {
        self.tastRecipientsList = [[NSMutableArray alloc] initWithObjects:self.taskModel.personInCharge, nil];
    }
    if (self.tastObserversList == nil) {
        self.tastObserversList = [[NSMutableArray alloc] initWithArray:self.taskModel.observers];
    }
    
    self.assignerDataSource = nil;
    [self.assignerDataSource addObject:self.taskModel.personInCharge];
    
    self.followsDataSource = nil;
    for (ESContactor *contactor in self.taskModel.observers) {
        [self.followsDataSource addObject:contactor];
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListSelfTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageListSelfTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageListTableViewCell"];
    
    [self.sendTxtfield addTarget:self action:@selector(send) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *startDateStr = [self.taskModel.startDate substringToIndex:10];
    self.startDateLbl.text = [@"发起时间：" stringByAppendingString:[startDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    
    self.taskTitleTxtField.text = self.taskModel.title;
    self.taskDescriptioinTextView.text = self.taskModel.taskDescription;
    NSString *endDateStr = [self.taskModel.endDate substringToIndex:16];
    self.endDateLbl.text = [endDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    if (self.taskModel.status.integerValue == 0) {
        //任务状态为新
        self.taskStatusSwitch.on = NO;
    } else if (self.taskModel.status.integerValue == 1) {
        //任务状态为已关闭
        self.taskStatusSwitch.on = YES;
    } else {
        
    }

    [self.assignerCollectionView reloadData];
    [self.followsCollectionView reloadData];
    
    [self.getTaskDetailDP getTaskDetailWithTaskID:[self.taskModel.taskID stringValue]];
    [self.getTaskCommentListDP getTaskCommentListWithTaskID:[self.taskModel.taskID stringValue] listSize:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)getTaskDetailSuccess:(ESTask *)task {
    NSLog(@"adsfafas");
}

#pragma mark - EditTaskDelegate methods
- (void)editTaskSuccess {
    [self showTips:@"修改成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES isSucceuss:YES];
}

- (void)editTaskFailed:(NSString *)errorMessage {
    [self showTips:@"修改失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES isSucceuss:NO];
}

- (void)getTaskCommentListSuccess:(NSArray *)taskCommentList {
    self.dataSource = [NSMutableArray arrayWithArray:taskCommentList];
    [self.tableView reloadData];
}

- (void)SendTaskCommentSuccess:(ESTaskComment *)taskComment {
    [self.dataSource addObject:taskComment];
    [self.tableView reloadData];
    //    [self.tableView scrollToRowAtIndexPath:nil atScrollPosition:nil animated:nil];
}

- (void)closeTaskSuccess {
    
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ESTaskComment *taskComment = (ESTaskComment *)self.dataSource[indexPath.row];
    
    UITableViewCell *cell = nil;
    if ([taskComment.user.useID.stringValue isEqualToString:self.userID]) {
        MessageListSelfTableViewCell *selfCell = (MessageListSelfTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageListSelfTableViewCell" forIndexPath:indexPath];
        [selfCell updateMessage:self.dataSource[indexPath.row]];
        cell = selfCell;
    } else {
        MessageListTableViewCell *normalCell = (MessageListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCell" forIndexPath:indexPath];
        [normalCell updateMessage:self.dataSource[indexPath.row]];
        cell = normalCell;
    }
    
    return cell;
}

- (void)send {
    [self.sendTaskCommentDP sendTaskCommentWithTaskID:[self.taskModel.taskID stringValue]
                                              comment:self.sendTxtfield.text];
    self.sendTxtfield.text = nil;
}

#pragma mark - response events methods
- (void)hideKeyboard {
    [self.taskTitleTxtField resignFirstResponder];
    [self.taskDescriptioinTextView resignFirstResponder];
    [self.sendTxtfield resignFirstResponder];
    
    if (self.dateSelectedPicker) {
        [UIView animateWithDuration:.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             __weak UIView *ws = self.view;
                             [self.dateSelectedPicker mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(ws.mas_bottom).with.offset(216);
                             }];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             self.dateSelectedPicker.hidden = YES;
                         }];
    }
}

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
    for (ESContactor *user in selectedUsers) {
        [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", user.name,@","]];
        [userIdList addObject:[user.useID stringValue]];
    }
    [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
    __weak typeof(&*self)  weakSelf = self;

    if ([self.taskModel.chatID isKindOfClass:[NSNull class]] || self.taskModel.chatID == nil || [self.taskModel.chatID isEqualToString:@""]) {
        [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle userIdList:userIdList success:^(RCDiscussion *discussion) {
            NSLog(@"create discussion ssucceed!");
            dispatch_async(dispatch_get_main_queue(), ^{
                ChatViewController *chat =[[ChatViewController alloc]init];
                chat.targetId                      = discussion.discussionId;
                chat.userName                    = discussion.discussionName;
                chat.conversationType              = ConversationType_DISCUSSION;
                chat.title                         = @"讨论组";
                chat.userIDList = userIdList;
                
                //保存chat_id请求
                self.taskModel.chatID = chat.targetId;
                [self saveBarItemOnClicked];
                
                UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                [weakSelf.navigationController popToViewController:tabbarVC animated:YES];
                [tabbarVC.navigationController  pushViewController:chat animated:YES];
            });
        } error:^(RCErrorCode status) {
            NSLog(@"create discussion Failed > %ld!", (long)status);
        }];
    } else {
        //如果有chat_id直接进入会话界面
        NSString* chat_id =self.taskModel.chatID;
        
        [[RCIMClient sharedRCIMClient] getDiscussion:chat_id success:^(RCDiscussion* discussion) {
            if (discussion) {
                ChatViewController *chatViewController = [[ChatViewController alloc] init];
                chatViewController.conversationType = ConversationType_DISCUSSION;
                chatViewController.targetId = chat_id;
                chatViewController.title = discussion.discussionName;
                
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
        } error:^(RCErrorCode status){
            
        }];
        

    }
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
                weakSelf.assignerDataSource = nil;
                for (ESUserInfo *user in self.tastRecipientsList) {
                    ESContactor *contactor = [[ESContactor alloc] init];
                    contactor.useID = [NSNumber numberWithInteger:[user.userId integerValue]];
                    contactor.name = user.userName;
                    contactor.imgURLstr = user.portraitUri;
                    contactor.enterprise = user.enterprise;
                    [weakSelf.assignerDataSource addObject:contactor];
                }
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [self.assignerCollectionView reloadData];
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
                weakSelf.followsDataSource = nil;
                for (ESUserInfo *user in self.tastObserversList) {
                    ESContactor *contactor = [[ESContactor alloc] init];
                    contactor.useID = [NSNumber numberWithInteger:[user.userId integerValue]];
                    contactor.name = user.userName;
                    contactor.imgURLstr = user.portraitUri;
                    contactor.enterprise = user.enterprise;
                    [weakSelf.followsDataSource addObject:contactor];
                }
                
            }
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [self.followsCollectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    
}

- (void)saveBarItemOnClicked {
    ESTask *task = [[ESTask alloc] init];
    task.taskID = self.taskModel.taskID;
    task.title = self.taskTitleTxtField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = self.dateSelectedPicker.date;
    task.endDate = [dateFormatter stringFromDate:date];
    task.chatID = self.taskModel.chatID;
    task.taskDescription = self.taskDescriptioinTextView.text;
    
    if (self.taskStatusSwitch.on == NO) {
        task.status = [NSNumber numberWithInt:0];
    } else {
        task.status = [NSNumber numberWithInt:1];
    }
    
    task.personInCharge = [self.assignerDataSource firstObject];
    task.observers = self.followsDataSource;
    
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
                             [self hideKeyboard];
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

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:.1f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self headViewAnotherBtnOnClicked:YES];
                         self.sendViewBottomConstraint.constant = height;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [UIView animateWithDuration:.1f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.sendViewBottomConstraint.constant = 0.f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.assignerCollectionView) {
        return self.assignerDataSource.count;
    } else if (collectionView == self.followsCollectionView) {
        return self.followsDataSource.count;
    } else {
        return 0;
    };
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskContactorCollectionViewCell *cell = (TaskContactorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TaskContactorCollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    ESContactor *contactor = nil;
    
    if (collectionView == self.assignerCollectionView) {
        contactor = (ESContactor *)self.assignerDataSource[indexPath.row];
        [cell updateCell:contactor];
        return cell;
    } else if (collectionView == self.followsCollectionView) {
        contactor = (ESContactor *)self.followsDataSource[indexPath.row];
        [cell updateCell:contactor];
        return cell;
    } else {
        return nil;
    }
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

- (void)dateChanged:(UIDatePicker *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    NSDate *date = self.dateSelectedPicker.date;
    self.endDateLbl.text = [dateFormatter stringFromDate:date];
}

- (IBAction)dateBtnOnClicked:(UIButton *)sender {
    if (self.dateSelectedPicker.hidden == YES) {
        self.dateSelectedPicker.hidden = NO;
        [UIView animateWithDuration:.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             __weak UIView *ws = self.view;
                             [self.dateSelectedPicker mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(ws.mas_bottom);
                             }];
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    }
}


- (IBAction)switchOnClicked:(UISwitch *)sender {
    if (sender.on == YES) {
        [self.closeTaskDP closeTaskWithTaskID:[self.taskModel.taskID stringValue]];
    }
}

#pragma mark - private methods
- (void)showTips:(NSString *)tip mode:(MRProgressOverlayViewMode)mode isDismiss:(BOOL)isDismiss isSucceuss:(BOOL)success {
    [self.navigationController.view addSubview:self.progress];
    [self.progress show:YES];
    self.progress.mode = mode;
    self.progress.titleLabelText = tip;
    if (isDismiss)
    {
        [self performSelector:@selector(dismissProgress:) withObject:@(success) afterDelay:1.8];
    }
}

//参数作为布尔对象传递，使用Bool会出问题
- (void)dismissProgress:(Boolean)isSuccess {
    if (self.progress)
    {
        [self.progress dismiss:YES];
    }
}

#pragma mark - setters&getters
- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"eeeeee"].CGColor;
    }
}

- (void)setTxtHoldViews:(NSArray *)txtHoldViews {
    _txtHoldViews = txtHoldViews;
    
    for (UIView *view in _txtHoldViews) {
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"EEEEEE"].CGColor;
        view.layer.borderWidth = .8f;
        view.layer.cornerRadius = 5.f;
    }
}

- (void)setAssignerCollectionView:(UICollectionView *)assignerCollectionView {
    _assignerCollectionView = assignerCollectionView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _assignerCollectionView.collectionViewLayout = layout;
    
    UINib *professionCell = [UINib nibWithNibName:@"TaskContactorCollectionViewCell" bundle:nil];
    [_assignerCollectionView registerNib:professionCell forCellWithReuseIdentifier:@"TaskContactorCollectionViewCell"];
    _assignerCollectionView.bounces = NO;
}

- (void)setFollowsCollectionView:(UICollectionView *)followsCollectionView {
    _followsCollectionView = followsCollectionView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _followsCollectionView.collectionViewLayout = layout;
    
    UINib *professionCell = [UINib nibWithNibName:@"TaskContactorCollectionViewCell" bundle:nil];
    [_followsCollectionView registerNib:professionCell forCellWithReuseIdentifier:@"TaskContactorCollectionViewCell"];
    _followsCollectionView.bounces = NO;
}

- (UIDatePicker *)dateSelectedPicker {
    if (!_dateSelectedPicker) {
        _dateSelectedPicker = [UIDatePicker new];
        _dateSelectedPicker.datePickerMode = UIDatePickerModeDateAndTime;
        _dateSelectedPicker.minuteInterval = 10;
        NSDate *dateNow = [NSDate date];
        _dateSelectedPicker.minimumDate = dateNow;
        _dateSelectedPicker.maximumDate = [[NSDate alloc] initWithTimeInterval:365 * 24 * 3600
                                                                     sinceDate:dateNow];
        _dateSelectedPicker.backgroundColor = [UIColor grayColor];
        _dateSelectedPicker.hidden = YES;
        [_dateSelectedPicker addTarget:self
                                action:@selector(dateChanged:)
                      forControlEvents:UIControlEventValueChanged ];
    }
    
    return _dateSelectedPicker;
}

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

- (NSMutableArray *)assignerDataSource {
    if (!_assignerDataSource) {
        _assignerDataSource = [[NSMutableArray alloc] init];
    }
    
    return _assignerDataSource;
}

- (NSMutableArray *)followsDataSource {
    if (!_followsDataSource) {
        _followsDataSource = [[NSMutableArray alloc] init];
    }
    
    return _followsDataSource;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (GetTaskCommentListDataParse *)getTaskCommentListDP {
    if (!_getTaskCommentListDP) {
        _getTaskCommentListDP = [[GetTaskCommentListDataParse alloc ] init];
        _getTaskCommentListDP.delegate = self;
    }
    return _getTaskCommentListDP;
}

- (EditTaskDataParse *)editTaskDP {
    if (!_editTaskDP) {
        _editTaskDP = [[EditTaskDataParse alloc] init];
        _editTaskDP.delegate = self;
    }
    
    return _editTaskDP;
}

- (SendTaskCommentDataParse *)sendTaskCommentDP {
    if (!_sendTaskCommentDP) {
        _sendTaskCommentDP = [[SendTaskCommentDataParse alloc] init];
        _sendTaskCommentDP.delegate = self;
    }
    
    return _sendTaskCommentDP;
}

- (CloseTaskDataParse *)closeTaskDP {
    if (!_closeTaskDP) {
        _closeTaskDP = [[CloseTaskDataParse alloc] init];
        _closeTaskDP.delegate = self;
    }
    return _closeTaskDP;
}

- (GetTaskDetailDataParse *)getTaskDetailDP {
    if (!_getTaskDetailDP) {
        _getTaskDetailDP = [[GetTaskDetailDataParse alloc] init];
        _getTaskDetailDP.delegate = self;
    }
    
    return _getTaskDetailDP;
}

@end
