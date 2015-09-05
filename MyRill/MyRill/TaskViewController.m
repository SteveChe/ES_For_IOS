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
#import "ESUserInfo.h"
#import "ESTagViewController.h"
#import "CustomShowMessage.h"
#import "ESUserInfo.h"
#import "ChatViewController.h"
#import "GetTaskCommentListDataParse.h"
#import "SendTaskCommentDataParse.h"
#import "TaskContactorCollectionViewCell.h"
#import "MessageListTableViewCell.h"
#import "ESTaskComment.h"
#import "MRProgress.h"
#import "GetTaskDetailDataParse.h"
#import "ChatViewController.h"
#import "UserDefaultsDefine.h"
#import "SendTaskImageDataParse.h"
#import "RCDRadioSelectPersonViewController.h"
#import "PushDefine.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ImageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UpdateObserverAndChatidDataParse.h"

@interface TaskViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GetTaskCommentListDelegate, SendTaskCommenDelegate, EditTaskDelegate, GetTaskDetailDelegate, SendTaskImageDelegate ,ELCImagePickerControllerDelegate, UpdateObserverAndChatidDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *txtHoldViews;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *startPersonAndDateLbl;
@property (weak, nonatomic) IBOutlet UITextField *taskTitleTxtField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptioinTextView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (nonatomic, strong) UIDatePicker *dateSelectedPicker;
@property (weak, nonatomic) IBOutlet UISwitch *taskStatusSwitch;
@property (weak, nonatomic) IBOutlet UICollectionView *assignerCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *followsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UITextView *sendTxtView;
@property (nonatomic, strong) MRProgressOverlayView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *personInChargeArrow;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *arrowImages;

@property (nonatomic, strong) NSMutableArray *assignerDataSource; //负责人列表,ESUserInfo
@property (nonatomic, strong) NSMutableArray *followsDataSource; //关注人列表,ESUserInfo
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) GetTaskDetailDataParse *getTaskDetailDP;
@property (nonatomic, strong) GetTaskCommentListDataParse *getTaskCommentListDP;
@property (nonatomic, strong) EditTaskDataParse *editTaskDP;
@property (nonatomic, strong) UpdateObserverAndChatidDataParse *updateObserverAndChatidDP;
@property (nonatomic, strong) SendTaskCommentDataParse *sendTaskCommentDP;
@property (nonatomic, strong) SendTaskImageDataParse *sendTaskImageDP;

@property (nonatomic, strong) ESTask *taskModel;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) UITableViewCell *prototypeCell;

@property (nonatomic, strong) ImageTableViewCell *onClickedCell;
@property (nonatomic, strong) ESTaskComment *cacheTaskComment;
@property (nonatomic, assign) CGRect oldframe;
@property (nonatomic, strong) NSMutableArray *imagesOld;

@end

@implementation TaskViewController
#pragma mark - lifeCycle methods
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView.tableHeaderView addGestureRecognizer:tap];
    //[self.sendTxtView addTarget:self action:@selector(send) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.view addSubview:self.dateSelectedPicker];
    __weak UIView *ws = self.view;
    [self.dateSelectedPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ws.mas_leading);
        make.trailing.equalTo(ws.mas_trailing);
        make.bottom.equalTo(ws.mas_bottom).with.offset(216);
        make.height.equalTo(@216);
    }];
    [self.view layoutIfNeeded];

    self.tableView.tableFooterView = nil;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImageTableViewCell"];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    self.userID = [userDefaultes stringForKey:DEFAULTS_USERID];
    //请求任务详情
    [self.getTaskDetailDP getTaskDetailWithTaskID:self.requestTaskID];
    //请求任务列表
    [self.getTaskCommentListDP getTaskCommentListWithTaskID:self.requestTaskID listSize:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePushTask)
                                                 name:NOTIFICATION_PUSH_ASSIGNMENT
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PUSH_ASSIGNMENT object:nil];
}

- (void)getTaskDetailSuccess:(ESTask *)task {
    self.taskModel = task;
    
    //如果是发起人进入任务详情，则提供修改接口
    if ([self.userID isEqualToString:self.taskModel.initiator.userId]) {
        
        self.taskTitleTxtField.enabled = YES;
        self.taskDescriptioinTextView.editable = YES;
        self.taskStatusSwitch.enabled = YES;
        
        [self.arrowImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *arrow = (UIImageView *)obj;
            arrow.hidden = NO;
        }];
    }
    
    NSString *startDateStr = [self.taskModel.startDate substringToIndex:16];
    self.startPersonAndDateLbl.text = [NSString stringWithFormat:@"由%@发起于:%@",self.taskModel.initiator.userName,[startDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    
    self.taskTitleTxtField.text = self.taskModel.title;
    self.taskDescriptioinTextView.text = self.taskModel.taskDescription;
    NSString *endDateStr = [self.taskModel.endDate substringToIndex:16];
    self.endDateLbl.text = [endDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    if (self.taskModel.status.integerValue == 0) {
        //任务状态为新
        self.taskStatusSwitch.on = NO;
    } else {
        //任务状态为已关闭status=1
        self.taskStatusSwitch.on = YES;
    }
    
    [self.assignerDataSource removeAllObjects];
    [self.assignerDataSource addObject:self.taskModel.personInCharge];
    
    [self.followsDataSource removeAllObjects];
    [self.followsDataSource addObjectsFromArray:self.taskModel.observers];
    
    [self.assignerCollectionView reloadData];
    [self.followsCollectionView reloadData];
}

#pragma mark - EditTaskDelegate methods
- (void)editTaskSuccess {
    [self showTips:@"修改成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES isSucceuss:YES];
}

- (void)editTaskFailed:(NSString *)errorMessage {
    [self showTips:@"修改失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES isSucceuss:NO];
}

- (void)updateObserverAndChatidSuccess {
    [self showTips:@"修改成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES isSucceuss:YES];
}

- (void)updateObserverAndChatidFailed:(NSString *)errorMessage {
    [self showTips:@"修改失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES isSucceuss:NO];
}

- (void)getTaskCommentListSuccess:(NSArray *)taskCommentList {
    self.dataSource = [NSMutableArray arrayWithArray:[[taskCommentList reverseObjectEnumerator] allObjects]];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}

- (void)sendTaskImageSuccess:(NSString *)imageURL {
    [self.imagesOld addObject:imageURL];
    [self.images removeObject:[self.images firstObject]];
    if (self.images.count > 0) {
        [self.sendTaskImageDP sendTaskCommentWithTaskID:[self.taskModel.taskID stringValue]
                                                comment:self.cacheTaskComment
                                              imageData:[self.images firstObject]];
    }
    
    if (self.images.count == 0) {
        self.cacheTaskComment.images = self.imagesOld;
        [self dismissProgress:YES];
        [self.dataSource insertObject:self.cacheTaskComment atIndex:0];

        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

- (void)sendTaskCommentSuccess:(ESTaskComment *)taskComment {
    self.cacheTaskComment = taskComment;
    
    if ([taskComment.content isEqualToString:@""]) {
        [self.sendTaskImageDP sendTaskCommentWithTaskID:[self.taskModel.taskID stringValue]
                                                comment:taskComment
                                              imageData:[self.images firstObject]];
        return;
    }
    
    [self.sendTxtView resignFirstResponder];
    [self.dataSource insertObject:taskComment atIndex:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.prototypeCell  isKindOfClass:[MessageListTableViewCell class]]) {

        MessageListTableViewCell *cell = (MessageListTableViewCell *)self.prototypeCell;
        ESTaskComment *taskComment = (ESTaskComment *)self.dataSource[indexPath.row];
        cell.contentLbl.text = taskComment.content;
        if ([cell.contentLbl systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
            return [cell.contentLbl systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        } else {
            return 108;
        }
        
    } else if ([self.prototypeCell isKindOfClass:[ImageTableViewCell class]]){
        return 108;
    } else {
        return 108;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"评论(%lu)",(unsigned long)self.dataSource.count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell  = nil;
    ESTaskComment *taskComment = (ESTaskComment *)self.dataSource[indexPath.row];
    if (taskComment.images == nil) {
        MessageListTableViewCell *normalCell = (MessageListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCell" forIndexPath:indexPath];
        [normalCell updateMessage:self.dataSource[indexPath.row]];
        self.prototypeCell = normalCell;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 1);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
        [self.prototypeCell.layer addSublayer:layer];
        [self.prototypeCell layoutIfNeeded];
    } else {
        ImageTableViewCell *imgCell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell" forIndexPath:indexPath];
        [imgCell updateMessage:self.dataSource[indexPath.row]];
        self.prototypeCell = imgCell;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 1);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
        [self.prototypeCell.layer addSublayer:layer];
        [self.prototypeCell layoutIfNeeded];
    }
    
    return self.prototypeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideKeyboard];
    ESTaskComment *taskComment = (ESTaskComment *)self.dataSource[indexPath.row];
    if (taskComment.images != nil) {
        if (taskComment.images.count > 0) {
            self.onClickedCell = (ImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            //[self showImage:taskComment.images];
        }
    }
}


- (void)showImage:(NSArray *)images {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //        [self.navigationController preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    NSString *imageURL = [images firstObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.oldframe = [self.onClickedCell.placeholderImg convertRect:self.onClickedCell.placeholderImg.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.oldframe];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    imageView.tag = 101;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-imageView.image.size.height*[UIScreen mainScreen].bounds.size.width/imageView.image.size.width)/2, [UIScreen mainScreen].bounds.size.width, imageView.image.size.height*[UIScreen mainScreen].bounds.size.width/imageView.image.size.width);
        backgroundView.alpha=1;
    } completion:nil];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:101];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = self.oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
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
    
    ESUserInfo *user = nil;
    
    if ([collectionView isEqual:self.assignerCollectionView]) {
        user = (ESUserInfo *)self.assignerDataSource[indexPath.row];
        [cell updateCell:user];
        return cell;
    } else if ([collectionView isEqual:self.followsCollectionView]) {
        user = (ESUserInfo *)self.followsDataSource[indexPath.row];
        [cell updateCell:user];
        return cell;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(54,54);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
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

#pragma mark - UITextViewDelegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //textView的发送事件
    if ([text isEqualToString:@"\n"]) {

        [self.sendTaskCommentDP sendTaskCommentWithTaskID:[self.taskModel.taskID stringValue]
                                                  comment:self.sendTxtView.text];
        self.sendTxtView.text = nil;
        
        if (self.sendViewHeightConstraint.constant > 50) {
            [UIView animateWithDuration:.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.sendViewHeightConstraint.constant = 50;
                                 [self.view layoutIfNeeded];
                             }
                             completion:nil];
        }
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView isEqual:self.sendTxtView]) {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.sendViewHeightConstraint.constant = textView.contentSize.height + 6 * 2;
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //    self.tabBarController.tabBarItem.enabled = NO;
    //    [self.tabBarController.tabBar.items makeObjectsPerformSelector:@selector(setEnabled:) withObject:@NO];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //获取编辑框内部的图片，作为上传对象(上传图片不歪了也就)
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //先把图片转成NSData
//        UIImage *img = [self scaleToSize:image size:CGSizeMake(300, 300)];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        [self.images removeAllObjects];
        [self.images addObject:data];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    //    MRActivityIndicatorView
   // [self showTips:@"正在上传..." mode:MRProgressOverlayViewModeIndeterminateSmallDefault isDismiss:NO isSucceuss:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - response events methods
- (void)hideKeyboard {
    [self.taskTitleTxtField resignFirstResponder];
    [self.taskDescriptioinTextView resignFirstResponder];
    [self.sendTxtView resignFirstResponder];
    
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
    if ([self.assignerDataSource count] <=0 ) {
        [[CustomShowMessage getInstance] showNotificationMessage:@"没有分配人不能发起会话!"];
        return;
    }

    //创建set过滤分配和关注中的重复联系人
    
    NSMutableArray *totolContractorArr = [[NSMutableArray alloc] initWithCapacity:self.assignerDataSource.count + self.followsDataSource.count];
    [totolContractorArr addObjectsFromArray:self.assignerDataSource];
    [totolContractorArr addObjectsFromArray:self.followsDataSource];
    
    NSMutableString *discussionTitle = [NSMutableString string];
    NSMutableArray *userIdList = [NSMutableArray new];
    for (ESUserInfo *contactor in totolContractorArr) {
        if (![discussionTitle containsString:contactor.userName]) {
            [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", contactor.userName,@","]];
        }
        [userIdList addObject:contactor.userId];
    }
    NSSet *set = [NSSet setWithArray:userIdList];
    NSMutableArray *tempArr = [NSMutableArray new];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [tempArr addObject:obj];
    }];
    [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
    __weak typeof(&*self)  weakSelf = self;

    if ([self.taskModel.chatID isKindOfClass:[NSNull class]] || self.taskModel.chatID == nil || [self.taskModel.chatID isEqualToString:@""]) {
        [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle userIdList:tempArr success:^(RCDiscussion *discussion) {
            NSLog(@"create discussion ssucceed!");
            dispatch_async(dispatch_get_main_queue(), ^{
                ChatViewController *chat =[[ChatViewController alloc]init];
                chat.targetId                      = discussion.discussionId;
                chat.userName                    = discussion.discussionName;
                chat.conversationType              = ConversationType_DISCUSSION;
                chat.title                         = @"讨论组";
                chat.userIDList = tempArr;
                
                //保存chat_id请求
                weakSelf.taskModel.chatID = chat.targetId;
                [weakSelf saveBarItemOnClicked];
                
                UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                [weakSelf.navigationController popToViewController:tabbarVC animated:YES];
                [tabbarVC.navigationController  pushViewController:chat animated:YES];
            });
        } error:^(RCErrorCode status) {
            NSLog(@"create discussion Failed > %ld!", (long)status);
        }];
    } else {
        //如果有chat_id直接进入会话界面
        NSString* chat_id = self.taskModel.chatID;
        
        [[RCIMClient sharedRCIMClient] getDiscussion:chat_id success:^(RCDiscussion* discussion) {
            if (discussion) {
                ChatViewController *chatViewController = [[ChatViewController alloc] init];
                chatViewController.conversationType = ConversationType_DISCUSSION;
                chatViewController.targetId = chat_id;
                chatViewController.title = discussion.discussionName;
                
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
        } error:^(RCErrorCode status){
            NSLog(@"直接进入会话界面失败");
            NSLog(@"%ld",(long)status);
        }];
    }
}

- (IBAction)chooseTagBtnOnClicked:(UIButton *)sender {
    //标签选择
    if (![self.taskModel.initiator.userId isEqualToString:self.userID] && ![self.userID isEqualToString:self.taskModel.personInCharge.userId]) {
        return;
    }
    
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
        if (![self.taskModel.initiator.userId isEqualToString:self.userID] && ![self.userID isEqualToString:self.taskModel.personInCharge.userId]) {
            return;
        }
        
        __weak typeof(&*self)  weakSelf = self;
        RCDRadioSelectPersonViewController* selectPersonVC = [[RCDRadioSelectPersonViewController alloc] init];
        selectPersonVC.type = e_Selected_Person_Radio;
        [selectPersonVC setSeletedUsers:self.assignerDataSource];
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDRadioSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count) {
                [weakSelf.assignerDataSource removeAllObjects];
                [weakSelf.assignerDataSource addObjectsFromArray:selectedUsers];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [weakSelf.assignerCollectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    else if (sender.tag == 1002){
        RCDRadioSelectPersonViewController* selectPersonVC = [[RCDRadioSelectPersonViewController alloc] init];
        selectPersonVC.type = e_Selected_Check_Box;
        [selectPersonVC setSeletedUsers:self.followsDataSource];
        __weak typeof(&*self)  weakSelf = self;

        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDRadioSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [weakSelf.followsDataSource removeAllObjects];
                [weakSelf.followsDataSource addObjectsFromArray:selectedUsers];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [weakSelf.followsCollectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    
}

- (void)saveBarItemOnClicked {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSDate *commitDate = [dateFormatter dateFromString:self.taskModel.endDate];
    if ([commitDate compare:[NSDate date]] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"结束日期需要晚于当前日期!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ESTask *task = [[ESTask alloc] init];
    task.taskID = self.taskModel.taskID;
    task.title = self.taskTitleTxtField.text;
    
    task.endDate = [self.taskModel.endDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    task.chatID = self.taskModel.chatID;
    task.taskDescription = self.taskDescriptioinTextView.text;
    
    if (self.taskStatusSwitch.on == NO) {
        task.status = [NSNumber numberWithInt:0];
    } else {
        task.status = [NSNumber numberWithInt:1];
    }
    
    task.personInCharge = [self.assignerDataSource firstObject];
    task.observers = self.followsDataSource;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault stringForKey:DEFAULTS_USERID];
    
    if ([userID isEqualToString:self.taskModel.initiator.userId]) {
        [self.editTaskDP EditTaskWithTaskModel:task];
    } else if ([userID isEqualToString:self.taskModel.personInCharge.userId]) {
        
    } else {
        [self.updateObserverAndChatidDP updateObserverAndChatidWith:task];
    }
}

- (void)dateChanged:(UIDatePicker *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSDate *date = self.dateSelectedPicker.date;
    self.taskModel.endDate = [dateFormatter stringFromDate:date];
    self.endDateLbl.text = [self.taskModel.endDate substringToIndex:16];
}

- (IBAction)dateBtnOnClicked:(UIButton *)sender {
    if (![self.taskModel.initiator.userId isEqualToString:self.userID] && ![self.userID isEqualToString:self.taskModel.personInCharge.userId]) {
        return;
    }
    
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

- (IBAction)sendImg:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          //处理点击拍照
                                                          UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                                                          //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                          //    }
                                                          //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
                                                          //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
                                                          //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
                                                          UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
                                                          picker.delegate = self;
                                                          picker.allowsEditing = YES;//设置可编辑
                                                          picker.sourceType = sourceType;
                                                          if([[[UIDevice
                                                                currentDevice] systemVersion] floatValue]>=8.0) {
                                                              
                                                              self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                                                              
                                                          }
                                                          [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          //处理点击从相册选取
//                                                          UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
//                                                          if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//                                                              pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                                                              //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//                                                              pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
//                                                              
//                                                          }
//                                                          pickerImage.delegate = self;
//                                                          pickerImage.allowsEditing = YES;
//                                                          if([[[UIDevice
//                                                                currentDevice] systemVersion] floatValue]>=8.0) {
//                                                              
//                                                              self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//                                                              
//                                                          }
//                                                          
//                                                          pickerImage.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
//                                                          //item颜色
//                                                          pickerImage.navigationBar.tintColor = [UIColor whiteColor];
//                                                          //设定title颜色
//                                                          [pickerImage.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//                                                          //取消translucent效果
//                                                          pickerImage.navigationBar.translucent = NO;
//                                                          [self presentViewController:pickerImage animated:YES completion:nil];//进入照相界面
                                                          ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
                                                          ELCImagePickerController *pickImage = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
                                                          [albumController setParent:pickImage];
                                                          [pickImage setDelegate:self];
                                                          
//                                                          ELCImagePickerController *pickImage= [[ELCImagePickerController alloc] init];
                                                          pickImage.maximumImagesCount = 9; //Set the maximum number of images to select, defaults to 4
                                                          pickImage.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
                                                          pickImage.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                                                          pickImage.onOrder = YES; //For multiple image selection, display and return selected order of images
                                                          pickImage.imagePickerDelegate = self;
                                                          if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                                                           self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                                                          }
                                                          
                                                          pickImage.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
                                                          //item颜色
                                                          pickImage.navigationBar.tintColor = [UIColor whiteColor];
                                                          //设定title颜色
                                                          [pickImage.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                                                          //取消translucent效果
                                                          pickImage.navigationBar.translucent = NO;
                                                          //Present modally
                                                          [self presentViewController:pickImage animated:YES completion:nil];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
   [self.images removeAllObjects];
    [info enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        UIImage *image = dic[@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        
        [self.images addObject:data];
    }];
    
    [self.sendTaskCommentDP sendTaskCommentWithTaskID:[self.taskModel.taskID stringValue] comment:@" "];
    [self showTips:@"正在上传..." mode:MRProgressOverlayViewModeIndeterminateSmallDefault isDismiss:NO isSucceuss:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    
//    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"])
//    {
//        //获取编辑框内部的图片，作为上传对象(上传图片不歪了也就)
//        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//        //先把图片转成NSData
//        //        UIImage *img = [self scaleToSize:image size:CGSizeMake(300, 300)];
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil)
//        {
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//        else
//        {
//            data = UIImagePNGRepresentation(image);
//        }
//        
//        [self.images removeAllObjects];
//        [self.images addObject:data];
//        
//        //关闭相册界面
//        [picker dismissViewControllerAnimated:YES completion:nil];
//    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
                         self.sendViewBottomConstraint.constant = height;
                         [self.view layoutIfNeeded];
                         
                         if (self.dataSource.count > 0) {
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                       inSection:0]
                                                   atScrollPosition:UITableViewScrollPositionBottom
                                                           animated:YES];
                         }
                     }
                     completion:nil];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [UIView animateWithDuration:.1f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.sendViewBottomConstraint.constant = 0.f;
                         [self.view layoutIfNeeded];
                         
                         if (self.dataSource.count > 0) {
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                       inSection:0]
                                                   atScrollPosition:UITableViewScrollPositionBottom
                                                           animated:YES];
                         }
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)updatePushTask {
    //请求任务详情
    [self.getTaskDetailDP getTaskDetailWithTaskID:self.requestTaskID];
    //请求任务列表
    [self.getTaskCommentListDP getTaskCommentListWithTaskID:self.requestTaskID listSize:nil];
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
    if (self.progress) {
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

//- (void)setTableView:(UITableView *)tableView {
//    _tableView = tableView;
//    
//    _tableView.rowHeight = UITableViewAutomaticDimension;
//}

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

- (void)setSendTxtView:(UITextView *)sendTxtView {
    _sendTxtView = sendTxtView;
    
    _sendTxtView.layer.borderWidth = 1.f;
    _sendTxtView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    _sendTxtView.layer.cornerRadius = 5.f;
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

- (UpdateObserverAndChatidDataParse *)updateObserverAndChatidDP {
    if (!_updateObserverAndChatidDP) {
        _updateObserverAndChatidDP = [[UpdateObserverAndChatidDataParse alloc] init];
        _updateObserverAndChatidDP.delegate = self;
    }
    
    return _updateObserverAndChatidDP;
}

- (SendTaskCommentDataParse *)sendTaskCommentDP {
    if (!_sendTaskCommentDP) {
        _sendTaskCommentDP = [[SendTaskCommentDataParse alloc] init];
        _sendTaskCommentDP.delegate = self;
    }
    
    return _sendTaskCommentDP;
}

- (SendTaskImageDataParse *)sendTaskImageDP {
    if (!_sendTaskImageDP) {
        _sendTaskImageDP = [[SendTaskImageDataParse alloc] init];
        _sendTaskImageDP.delegate = self;
    }
    return _sendTaskImageDP;
}

- (GetTaskDetailDataParse *)getTaskDetailDP {
    if (!_getTaskDetailDP) {
        _getTaskDetailDP = [[GetTaskDetailDataParse alloc] init];
        _getTaskDetailDP.delegate = self;
    }
    
    return _getTaskDetailDP;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (NSMutableArray *)imagesOld {
    if (!_imagesOld) {
        _imagesOld = [[NSMutableArray alloc] init];
    }
    return _imagesOld;
}

@end
