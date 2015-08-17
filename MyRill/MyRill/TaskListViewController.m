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
#import "AddTaskViewController.h"
#import "SWTableViewCell.h"
#import "RemindDateViewController.h"
#import "ESTask.h"
#import "Masonry.h"

@interface TaskListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TaskListDelegate, SWTableViewCellDelegate>

@property (nonatomic, strong) UILabel *msgLbl;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.getTaskListDP getTaskListWithIdentify:self.identity type:self.type];
}

- (void)getTaskListSuccess:(NSArray *)taskList {
    if (taskList.count) {
        self.dataSource = nil;
        self.dataSource = [NSArray arrayWithArray:taskList];
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
    } else {
        [self.view addSubview:self.msgLbl];
        
        __weak UIView *ws = self.view;
        [self.msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.mas_centerX);
            make.centerY.equalTo(ws.mas_centerY).with.offset(-20);
            make.width.equalTo(ws.mas_width).with.offset(-60);
        }];
        [self.view layoutIfNeeded];
    }
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListTableViewCell *cell = (TaskListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell" forIndexPath:indexPath];
    [cell updateTackCell:self.dataSource[indexPath.row]];
    cell.rightUtilityButtons = [self rightButttons];
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, cell.bounds.size.height - 10, cell.bounds.size.width, 10);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [cell.layer addSublayer:layer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskViewController *taskVC = [[TaskViewController alloc] init];
    taskVC.taskModel = (ESTask *)self.dataSource[indexPath.row];
    [self.navigationController pushViewController:taskVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)addTask {
    AddTaskViewController *addTaskVC = [[AddTaskViewController alloc] init];
    if (self.type == ESTaskListWithChatId) {
        addTaskVC.chatID = self.identity;
    }
    addTaskVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:addTaskVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ESTask *task = (ESTask *)self.dataSource[indexPath.row];
    
    RemindDateViewController *remindDateVC = [[RemindDateViewController alloc] init];
    remindDateVC.taskTitle = task.title;
    remindDateVC.taskDescriptsion = task.taskDescription;
    remindDateVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    remindDateVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    [self presentViewController:remindDateVC animated:YES completion:nil];
}

#pragma mark - private methods
- (NSArray *)rightButttons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"设置提醒"];
    
    return rightUtilityButtons;
}

#pragma mark - setters&getters
- (UILabel *)msgLbl {
    if (!_msgLbl) {
        _msgLbl = [UILabel new];
        _msgLbl.numberOfLines = 2;
        _msgLbl.text = @"当前任务列表为空，可以通过点击右上角的加号创建新的任务~";
    }
    
    return _msgLbl;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 0)];
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
