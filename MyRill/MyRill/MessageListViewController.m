//
//  MessageListViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "MessageListViewController.h"
#import "TaskViewController.h"
#import "MessageListSelfTableViewCell.h"
#import "MessageListTableViewCell.h"
#import "GetTaskCommentListDataParse.h"
#import "SendTaskCommentDataParse.h"
#import "ESContactor.h"
#import "ESTaskComment.h"

@interface MessageListViewController () <UITableViewDataSource, UITableViewDelegate, GetTaskCommentListDelegate, UITextFieldDelegate, SendTaskCommenDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UITextField *sendTxtfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomConstraint;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) GetTaskCommentListDataParse *getTaskCommentListDP;
@property (nonatomic, strong) SendTaskCommentDataParse *sendTaskCommentDP;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
//    [self.sendTxtfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListSelfTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageListSelfTableViewCell"];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    self.userID = [userDefaultes stringForKey:@"UserId"];
    
     [self.sendTxtfield addTarget:self action:@selector(send) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.getTaskCommentListDP getTaskCommentListWithTaskID:self.taskID listSize:nil];
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
    [self.sendTaskCommentDP sendTaskCommentWithTaskID:self.taskID
                                              comment:self.sendTxtfield.text];
    self.sendTxtfield.text = nil;
}

- (void)hideKeyboard {
    [self.sendTxtfield resignFirstResponder];
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
                         TaskViewController *taskVC = (TaskViewController *)self.parentViewController;
                         [taskVC headViewAnotherBtnOnClicked:YES];
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
//                         TaskViewController *taskVC = (TaskViewController *)self.parentViewController;
//                         [taskVC headViewAnotherBtnOnClicked:NO];
                         self.sendViewBottomConstraint.constant = 0.f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - setters&getters
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

- (SendTaskCommentDataParse *)sendTaskCommentDP {
    if (!_sendTaskCommentDP) {
        _sendTaskCommentDP = [[SendTaskCommentDataParse alloc] init];
        _sendTaskCommentDP.delegate = self;
    }
    
    return _sendTaskCommentDP;
}

@end
