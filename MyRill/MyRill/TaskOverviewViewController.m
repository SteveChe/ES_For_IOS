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

@interface TaskOverviewViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, TaskDashboardDelegate, TaskListDelegate>

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
    [self.searchDisplayVC.searchResultsTableView registerNib:[UINib nibWithNibName:@"TaskListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TaskListTableViewCell"];
}

//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
//    controller.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
//}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.searchDisplayVC.searchBar.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePushTask)
                                                 name:NOTIFICATION_PUSH_ASSIGNMENT
                                               object:nil];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.getTaskDashboardDP getTaskDashboard];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_PUSH_ASSIGNMENT
                                                  object:nil];
}

- (void)getTaskDashboardSuccess:(ESTaskDashboard *)taskDashboard {
    self.openTaskLbl.text = [taskDashboard.openTask.num stringValue];
    self.closedTaskLbl.text = [taskDashboard.closedTask.num stringValue];
    
    self.totalTaskInSelfLbl.text = [[taskDashboard.totalTaskInSelf.num stringValue] stringByAppendingString:@" 全部"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.totalTaskInSelfLbl.text];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[ColorHandler colorFromHexRGB:@"999999"]}
                       range:NSMakeRange(attribute.length - 2, 2)];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                       range:NSMakeRange(attribute.length - 2, 2)];
    self.totalTaskInSelfLbl.attributedText = attribute;
    
    self.overdueTaskInSelfLbl.text = [[taskDashboard.overdueTaskInSelf.num stringValue] stringByAppendingString:@" 超期"];
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:self.overdueTaskInSelfLbl.text];
    [attribute1 addAttributes:@{NSForegroundColorAttributeName:[ColorHandler colorFromHexRGB:@"999999"]}
                       range:NSMakeRange(attribute.length - 2, 2)];
    [attribute1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                       range:NSMakeRange(attribute.length - 2, 2)];
    self.overdueTaskInSelfLbl.attributedText = attribute1;
    
    self.redAllLbl.hidden = !taskDashboard.totalTask.isUpdate;
    self.redEndLbl.hidden = !taskDashboard.closedTask.isUpdate;
    self.redMeAllLbl.hidden = !taskDashboard.totalTaskInSelf.isUpdate;
    self.redMeOverLbl.hidden = !taskDashboard.overdueTaskInSelf.isUpdate;
    self.dataSource = nil;
    self.dataSource = [NSArray arrayWithArray:taskDashboard.TaskInOriginatorList];
    [self.tableView reloadData];
}

- (void)getTaskListSuccess:(NSArray *)taskList {
    [self.searchResultDataSource removeAllObjects];
    [self.searchResultDataSource addObjectsFromArray:taskList];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self.getTaskListDP getTaskListWithIdentify:searchString type:ESTaskListQ];

    return YES;
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        TaskListTableViewCell *cell = (TaskListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell" forIndexPath:indexPath];
        [cell updateTackCell:self.searchResultDataSource[indexPath.row]];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchDisplayVC.searchResultsTableView]) {
        return nil;
    }
    return @"按发起人归属";
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

@end
