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
#import "TaskListViewController.h"
#import "ESNavigationController.h"
#import "GetTaskDashboardDataParse.h"
#import "ESTaskDashboard.h"
#import "ESTaskOriginatorInfo.h"

@interface TaskOverviewViewController () <UITableViewDataSource, UITableViewDelegate, TaskDashboardDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) GetTaskDashboardDataParse *getTaskDashboardDP;

@property (weak, nonatomic) IBOutlet UILabel *totalTaskLbl;
@property (weak, nonatomic) IBOutlet UILabel *closedTaskLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTaskInSelfLbl;
@property (weak, nonatomic) IBOutlet UILabel *overdueTaskInSelfLbl;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.getTaskDashboardDP getTaskDashboard];
}

- (void)getTaskDashboardSuccess:(ESTaskDashboard *)taskDashboard {
    self.totalTaskLbl.text = [taskDashboard.totalTask stringValue];
    self.closedTaskLbl.text = [taskDashboard.closedTask stringValue];
    self.totalTaskInSelfLbl.text = [[taskDashboard.totalTaskInSelf stringValue] stringByAppendingString:@" 全部"];
    self.overdueTaskInSelfLbl.text = [[taskDashboard.overdueTaskInSelf stringValue] stringByAppendingString:@" 超期"];
    self.dataSource = nil;
    self.dataSource = [NSArray arrayWithArray:taskDashboard.TaskInOriginatorList];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskOverviewTableViewCell *cell = (TaskOverviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskOverviewTableViewCell" forIndexPath:indexPath];
    [cell updateTaskDashboardCell:self.dataSource[indexPath.row]];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    [cell.layer addSublayer:layer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    taskListVC.type = ESTaskListWithInitiatorId;
    ESTaskOriginatorInfo *task = (ESTaskOriginatorInfo *)self.dataSource[indexPath.row];
    taskListVC.identity = [task.initiatorId stringValue];
    taskListVC.title = [task.initiatorName stringByAppendingString:@"发起的任务"];
    [self.navigationController pushViewController:taskListVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"按发起人归属";
}

#pragma mark - response events
- (void)addTask {
//    AddTaskViewController *addTaskVC = [[AddTaskViewController alloc] init];
//    addTaskVC.modalPresentationStyle = UIModalPresentationCurrentContext;
//    ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:addTaskVC];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)allTaskBtnOnClicked:(UIButton *)sender {
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];

    [self.navigationController pushViewController:taskListVC animated:YES];
    taskListVC.title = @"分配给我的全部任务";
}

- (IBAction)overdueTaskBtnOnClicked:(UIButton *)sender {
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    taskListVC.title = @"分配给我的超期任务";
    [self.navigationController pushViewController:taskListVC animated:YES];
}

- (IBAction)allTaskInSelfBtnOnClicked:(UIButton *)sender {
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
    [self.navigationController pushViewController:taskListVC animated:YES];
}

- (IBAction)overdueTaskInSelfBtnOnClicked:(UIButton *)sender {
    TaskListViewController *taskListVC = [[TaskListViewController alloc] init];
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

- (GetTaskDashboardDataParse *)getTaskDashboardDP {
    if (!_getTaskDashboardDP) {
        _getTaskDashboardDP = [[GetTaskDashboardDataParse alloc] init];
        _getTaskDashboardDP.delegate = self;
    }
    
    return _getTaskDashboardDP;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    
    return _dataSource;
}

@end
