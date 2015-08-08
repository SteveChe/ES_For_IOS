//
//  TaskListViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import "TaskListViewController.h"
#import "TaskListTableViewCell.h"
#import "ColorHandler.h"
#import "ESNavigationController.h"
#import "TaskViewController.h"

@interface TaskListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TaskListDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) GetTaskListDataParse *getTaskListDP;

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *addTaskItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addTask)];
    self.navigationItem.rightBarButtonItem = addTaskItem;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.getTaskListDP getTaskListWithIdentify:self.identity type:self.type];
}

- (void)getTaskListSuccess:(NSArray *)taskList {
    self.dataSource = nil;
    self.dataSource = [NSArray arrayWithArray:taskList];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListTableViewCell *cell = (TaskListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell" forIndexPath:indexPath];
    [cell updateTackCell:self.dataSource[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, cell.bounds.size.height - 10, cell.bounds.size.width, 10);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [cell.layer addSublayer:layer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskViewController *taskVC = [[TaskViewController alloc] init];
    taskVC.taskModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:taskVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"设置提醒";
}

- (void)addTask {
//    AddTaskViewController *addTaskVC = [[AddTaskViewController alloc] init];
//    addTaskVC.modalPresentationStyle = UIModalPresentationCurrentContext;
//    ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:addTaskVC];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - setters&getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索";
        _tableView.tableHeaderView = searchBar;
        UINib *nib = [UINib nibWithNibName:@"TaskListTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"TaskListTableViewCell"];
    }
    
    return _tableView;
}

- (GetTaskListDataParse *)getTaskListDP {
    if (!_getTaskListDP) {
        _getTaskListDP = [[GetTaskListDataParse alloc] init];
        _getTaskListDP.delegate = self;
    }
    
    return _getTaskListDP;
}

@end
