//
//  BMCResourceDetailViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/25.
//
//

#import "BMCResourceDetailViewController.h"
#import "Masonry.h"
#import "BMCGetMainResourceMetricListDataParse.h"
#import "EventVO.h"
#import "CustomShowMessage.h"
#import "ColorHandler.h"
#import "BMCSubResourceListViewController.h"

@interface BMCResourceDetailViewController () <UITableViewDataSource, UITableViewDelegate, BMCGetMainResourceMetricListDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) BMCGetMainResourceMetricListDataParse *getMainResourceMetricListDP;

@end

@implementation BMCResourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"资源详情";
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.getMainResourceMetricListDP getMainResourceMetricListWithResId:self.eventVO.resId];
}

#pragma mark - BMCGetMainResourceMetricListDelegate methods
- (void)getMainResourceMetricListSucceed:(NSArray *)resultList {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:resultList];
    [self.tableView reloadData];
}

- (void)getMainResourceMetricListFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:@"获取资源详情失败!"];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)onAddBtnClicked:(UIButton *)sender {
    BMCSubResourceListViewController *subResourceListVC = [[BMCSubResourceListViewController alloc] init];
    subResourceListVC.eventVO = self.eventVO;
    [self.navigationController pushViewController:subResourceListVC animated:YES];
}

#pragma mark - setters&getters
- (UITableView *)tableView {
    if (!_tableView) {
        //此处不明，为什么使用allocinit方式初始的tableview，进入不到编辑模式
        _tableView = [UITableView new];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BMCSubResourceDetailTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"BMCSubResourceDetailTableViewCell"];
    }
    
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, _footerView.bounds.size.height - 1, _footerView.bounds.size.width, 1);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
        [_footerView.layer addSublayer:layer];
        
        UIButton *addBtn = [UIButton new];
        [addBtn setTitle:@"子资源列表" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:addBtn];
        
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView);
        }];
    }
    
    return _footerView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (BMCGetMainResourceMetricListDataParse *)getMainResourceMetricListDP {
    if (!_getMainResourceMetricListDP) {
        _getMainResourceMetricListDP = [[BMCGetMainResourceMetricListDataParse alloc] init];
        _getMainResourceMetricListDP.delegate = self;
    }
    
    return _getMainResourceMetricListDP;
}

@end
