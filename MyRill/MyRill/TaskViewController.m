//
//  TaskViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/6.
//
//

#import "TaskViewController.h"
#import "ColorHandler.h"
#import "Masonry.h"
#import "ESTask.h"
#import "EditTaskDataParse.h"
#import "ESContactor.h"
#import "MessageListViewController.h"

@interface TaskViewController () <EditTaskDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLbl;
@property (weak, nonatomic) IBOutlet UISwitch *taskStatusSwitch;
@property (nonatomic, strong) MessageListViewController *messageListVC;
@property (nonatomic, strong) EditTaskDataParse *editTaskDP;

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
    
    //增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    [self.view addGestureRecognizer:tap];

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
    
    self.taskTitleLbl.text = [@"任务名称：" stringByAppendingString:self.taskModel.title];
    
    NSString *endDateStr = [self.taskModel.endDate substringToIndex:10];
    self.endDateLbl.text = [@"截止时间：" stringByAppendingString:[endDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    
    self.taskDescriptionLbl.text = [@"任务说明：" stringByAppendingString:self.taskModel.taskDescription];
    if (self.taskModel.status.integerValue == 0) {
        //任务状态为新
        self.taskStatusSwitch.on = NO;
    } else if (self.taskModel.status.integerValue == 1) {
        //任务状态为已关闭
        self.taskStatusSwitch.on = YES;
    } else {
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (void)textFieldDidChange:(UITextField *)textField {
//    CGSize size = [textField.text sizeWithFont:textField.font];
//    if (size.width >= textField.bounds.size.width) {
//        [self.sendTxtfield mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@72);
//        }];
//        [self.view layoutIfNeeded];
//    }
//}

#pragma mark - response events methods
- (void)startConversationEvent {
    //发起会话功能
    
}

- (void)saveBarItemOnClicked {
    NSMutableArray *observerArray = [[NSMutableArray alloc] initWithCapacity:self.taskModel.observers.count];
//    for (ESContactor *contractor in ) {
//        [observerArray addObject:contractor.useID];
//    }
    ESTask *task = [[ESTask alloc] init];
    task.taskID = self.taskModel.taskID;
    task.title = self.taskTitleLbl.text;
    task.endDate = self.taskModel.endDate;
    task.chatID = self.taskModel.chatID;
    task.taskDescription = self.taskModel.taskDescription;
    task.status = [NSNumber numberWithInt:1];
    task.personInCharge = self.taskModel.personInCharge;
    task.observers = self.taskModel.observers;
    
    [self.editTaskDP EditTaskWithTaskModel:task];
}



////当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)aNotification
//{
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//    
//    [UIView animateWithDuration:.1f
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         [self headViewBtnOnClicked:nil];
//                         self.sendViewBottomConstraint.constant = height;
//                         [self.view layoutIfNeeded];
//                     } completion:nil];
//}
//
////当键退出时调用
//- (void)keyboardWillHide:(NSNotification *)aNotification {
//    [UIView animateWithDuration:.1f
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         self.sendViewBottomConstraint.constant = 0.f;
//                         [self.view layoutIfNeeded];
//                     } completion:^(BOOL finished) {
//                         
//                     }];
//}

- (IBAction)headViewBtnOnClicked:(UIButton *)sender {
    
    CGFloat height = self.headerView.bounds.size.height;
    [UIView animateWithDuration:.5f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.headerViewTopConstraint.constant = 30 - height;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

#pragma mark - setters&getters
- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"eeeeee"].CGColor;
    }
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
