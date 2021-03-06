//
//  TaskOverviewViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "TaskOverviewViewController.h"
#import "TaskOverviewTableViewCell.h"
#import "ColorHandler.h"
#import "AddTaskViewController.h"
#import "TaskListViewController.h"
#import "ESNavigationController.h"
#import "GetTaskDashboardDataParse.h"
#import "ESTaskDashboard.h"
#import "ESTaskOriginatorInfo.h"
#import "ESTaskMask.h"
#import "TaskListTableViewCell.h"
#import "UserDefaultsDefine.h"
#import "TaskViewController.h"
#import "ESTask.h"
#import "PushDefine.h"
#import "CustomShowMessage.h"
#import "SetNotificationStatusDataParse.h"


@interface TaskOverviewViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, TaskDashboardDelegate, TaskListDelegate,SetNotificationStatusDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *redBadgeLbls;
@property (weak, nonatomic) IBOutlet UILabel *redAllLbl;
@property (weak, nonatomic) IBOutlet UILabel *redEndLbl;
@property (weak, nonatomic) IBOutlet UILabel *redMeAllLbl;
@property (weak, nonatomic) IBOutlet UILabel *redMeOverLbl;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *searchResultDataSource;
@property (nonatomic, strong) GetTaskDashboardDataParse *getTaskDashboardDP;
@property (nonatomic, strong) GetTaskListDataParse *getTaskListDP;

@property (weak, nonatomic) IBOutlet UILabel *openTaskLbl;
@property (weak, nonatomic) IBOutlet UILabel *closedTaskLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTaskInSelfLbl;
@property (weak, nonatomic) IBOutlet UILabel *overdueTaskInSelfLbl;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayVC;
@property (nonatomic, strong) SetNotificationStatusDataParse* setNotificationStatusDataParse;

@end

@implementation TaskOverviewViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addTask)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self.view addSubview:self.tableView];
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    [self.tableView.tableHeaderView addSubview:searchBar];
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                             contentsController:self];
    
    self.searchDisplayVC.searchResultsDataSource = self;
    self.searchDisplayVC.searchResultsDelegate = self;
    self.searchDisplayVC.delegate = self;
    self.searchDisplayVC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayVC.searchResultsTableView.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"];
    [self.searchDisplayVC.searchResultsTableView registerNib:[UINib nibWithNibName:@"TaskListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TaskListTableViewCell"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.searchDisplayVC.searchBar.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePushTask)
                                                 name:NOTIFICATION_PUSH_ASSIGNMENT
                                               object:nil];
    
    [self.getTaskDashboardDP getTaskDashboard];
    [self.setNotificationStatusDataParse setNotificationStatus:@"assignment" notificationType:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_PUSH_ASSIGNMENT
                                                  object:nil];
}

#pragma mark - TaskDashboardDelegate methods
- (void)getTaskDashboardSuccess:(ESTaskDashboard *)taskDashboard {
    self.openTaskLbl.text = [taskDashboard.openTask.num stringValue];
    self.closedTaskLbl.text = [taskDashboard.closedTask.num stringValue];
    
    self.totalTaskInSelfLbl.text = [[taskDashboard.totalTaskInSelf.num stringValue] stringByAppendingString:@" 全部"];
    NSMutableAttributedString *attributeTotal = [[NSMutableAttributedString alloc] initWithString:self.totalTaskInSelfLbl.text];
    [attributeTotal addAttributes:@{NSForegroundColorAttributeName:[ColorHandler colorFromHexRGB:@"999999"]}
                       range:NSMakeRange(attributeTotal.length - 2, 2)];
    [attributeTotal addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                       range:NSMakeRange(attributeTotal.length - 2, 2)];
    self.totalTaskInSelfLbl.attributedText = attributeTotal;
    
    self.overdueTaskInSelfLbl.text = [[taskDashboard.overdueTaskInSelf.num stringValue] stringByAppendingString:@" 超期"];
    NSMutableAttributedString *attributeOverdue = [[NSMutableAttributedString alloc] initWithString:self.overdueTaskInSelfLbl.text];
    [attributeOverdue addAttributes:@{NSForegroundColorAttributeName:[ColorHandler colorFromHexRGB:@"999999"]}
                        range:NSMakeRange(attributeOverdue.length - 2, 2)];
    [attributeOverdue addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                        range:NSMakeRange(attributeOverdue.length - 2, 2)];
    self.overdueTaskInSelfLbl.attributedText = attributeOverdue;
    
    self.redAllLbl.hidden = !taskDashboard.totalTask.isUpdate;
    self.redEndLbl.hidden = !taskDashboard.closedTask.isUpdate;
    self.redMeAllLbl.hidden = !taskDashboard.totalTaskInSelf.isUpdate;
    self.redMeOverLbl.hidden = !taskDashboard.overdueTaskInSelf.isUpdate;
    self.dataSource = nil;
    self.dataSource = [NSArray arrayWithArray:taskDashboard.TaskInOriginatorList];
    [self.tableView reloadData];
}

- (void)getTaskDashboardFailure:(NSString *)errorMsg {
    [[CustomShowMessage getInstance] showNotificationMessage:@"获取任务信息失败!"];
}

#pragma mark - TaskListDelegate methods
- (void)getTaskListSuccess:(NSArray *)taskList {
    [self.searchResultDataSource removeAllObjects];
    [self.searchResultDataSource addObjectsFromArray:taskList];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)getTaskListFailure:(NSString *)errorMsg {
    [[CustomShowMessage getInstance] showNotificationMessage:@"搜索任务失败!"];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self.getTaskListDP getTaskListWithIdentify:searchString type:ESTaskListQ];

    return YES;
}

#pragma mark - SetNotificationStatusDelegate
-(void)setNotificationStatusSucceed:(NSDictionary*)notificationStatus
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STATUS_UPDATE object:notificationStatus];
}
-(void)setNotificationStatusFailed:(NSString*)errorMessage
{
    
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, self.tableView.bounds.size.width - 40, 22)];
    title.text = @"按发起人归属";
    title.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [sectionHeader addSubview:title];
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchDisplayVC.searchResultsTableView]) {
      return 0;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        TaskListTableViewCell *cell = (TaskListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell" forIndexPath:indexPath];
        [cell updateTackCell:self.searchResultDataSource[indexPath.row]];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, cell.bounds.size.height - 10, cell.bounds.size.width, 10);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
        [cell.layer addSublayer:layer];
        return cell;
    } else {
        TaskOverviewTableViewCell *cell = (TaskOverviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskOverviewTableViewCell" forIndexPath:indexPath];
        [cell updateTaskDashboardCell:self.dataSource[indexPath.row]];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
        [cell.layer addSublayer:layer];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        TaskViewController *taskVC = [[TaskViewController alloc] init];
        ESTask *task = (ESTask *)self.searchResultDataSource[indexPath.row];
        taskVC.requestTaskID = [task.taskID stringValue];
        [self.navigationController pushViewController:taskVC animated:YES];
        return;
    }
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    taskListVC.type = ESTaskListWithInitiatorId;
    ESTaskOriginatorInfo *task = (ESTaskOriginatorInfo *)self.dataSource[indexPath.row];
    taskListVC.identity = [task.initiatorId stringValue];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if ([task.initiatorId.stringValue isEqualToString:[userDefaultes stringForKey:DEFAULTS_USERID]]) {
        taskListVC.title = @"我发起的任务";
    } else {
        taskListVC.title = [task.initiatorName stringByAppendingString:@"发起的任务"];
    }
    
    
    [self.navigationController pushViewController:taskListVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 150.f;
    } else {
        return 65.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return self.searchResultDataSource.count;
    } else {
        return self.dataSource.count;
    }
}

#pragma mark - response events
- (void)updatePushTask {
    [self.getTaskDashboardDP getTaskDashboard];
}

- (void)addTask {
    AddTaskViewController *addTaskVC = [[AddTaskViewController alloc] init];
    addTaskVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:addTaskVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)allTaskBtnOnClicked:(UIButton *)sender {
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    taskListVC.title = @"全部进行中任务";
    taskListVC.type = ESTaskListStatus;
    taskListVC.identity = @"0";
    [self.navigationController pushViewController:taskListVC animated:YES];
}

- (IBAction)overdueTaskBtnOnClicked:(UIButton *)sender {
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    taskListVC.title = @"结束归档任务";
    taskListVC.type = ESTaskListStatus;
    taskListVC.identity = @"1";
    [self.navigationController pushViewController:taskListVC animated:YES];
}

- (IBAction)allTaskInSelfBtnOnClicked:(UIButton *)sender {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    taskListVC.title = @"分配给我的全部任务";
    taskListVC.type = ESTaskListWithPersonInChargeId;
    taskListVC.identity = [userDefaultes stringForKey:DEFAULTS_USERID];
    [self.navigationController pushViewController:taskListVC animated:YES];
}

- (IBAction)overdueTaskInSelfBtnOnClicked:(UIButton *)sender {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    taskListVC.title = @"分配给我的已超期任务";
    taskListVC.type = ESTaskOverdue;
    taskListVC.identity = [userDefaultes stringForKey:DEFAULTS_USERID];
    [self.navigationController pushViewController:taskListVC animated:YES];
}

#pragma mark - setters&getters
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"TaskOverviewTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"TaskOverviewTableViewCell"];
}

- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    }
}

- (void)setRedBadgeLbls:(NSArray *)redBadgeLbls {
    _redBadgeLbls = redBadgeLbls;
    
    for (UILabel *lbl in _redBadgeLbls) {
        lbl.font = [UIFont systemFontOfSize:8];
        lbl.textColor = [ColorHandler colorFromHexRGB:@"F64F50"];
        lbl.clipsToBounds = YES;
        lbl.layer.cornerRadius = 5.f;
    }
}

- (GetTaskDashboardDataParse *)getTaskDashboardDP {
    if (!_getTaskDashboardDP) {
        _getTaskDashboardDP = [[GetTaskDashboardDataParse alloc] init];
        _getTaskDashboardDP.delegate = self;
    }
    
    return _getTaskDashboardDP;
}

- (GetTaskListDataParse *)getTaskListDP {
    if (!_getTaskListDP) {
        _getTaskListDP = [[GetTaskListDataParse alloc] init];
        _getTaskListDP.delegate = self;
    }
    
    return _getTaskListDP;
}

- (NSMutableArray *)searchResultDataSource {
    if (!_searchResultDataSource) {
        _searchResultDataSource = [[NSMutableArray alloc] init];
    }
    
    return _searchResultDataSource;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    
    return _dataSource;
}

- (SetNotificationStatusDataParse *)setNotificationStatusDataParse {
    if (!_setNotificationStatusDataParse) {
        _setNotificationStatusDataParse = [[SetNotificationStatusDataParse alloc] init];
        _setNotificationStatusDataParse.delegate = self;
    }
    return _setNotificationStatusDataParse;
}

@end
