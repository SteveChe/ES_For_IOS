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
#import "BMCResourceAndSubMetricTableViewCell.h"
#import "ResMetricPojo.h"

@interface BMCResourceDetailViewController () <UITableViewDataSource, UITableViewDelegate, BMCGetMainResourceMetricListDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) BMCResourceAndSubMetricTableViewCell *prototypeCell;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BMCResourceAndSubMetricTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"BMCResourceAndSubMetricTableViewCell"];
    
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BMCResourceAndSubMetricTableViewCell"];

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
    self.prototypeCell  = nil;
    BMCResourceAndSubMetricTableViewCell *cell = (BMCResourceAndSubMetricTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCResourceAndSubMetricTableViewCell" forIndexPath:indexPath];
    
    ResMetricPojo *resMetricPojo = (ResMetricPojo *)self.dataSource[indexPath.row];
    cell.titleLbl.text = resMetricPojo.metricName;
    if ([ColorHandler isNullOrEmptyString:resMetricPojo.metricValue]) {
        cell.contentLbl.text = @"——";
    } else {
        cell.contentLbl.text = [resMetricPojo.metricValue stringByAppendingString:resMetricPojo.metricUnit];
    }
    
    self.prototypeCell = cell;
    self.prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [self.prototypeCell.layer addSublayer:layer];
    [self.prototypeCell layoutIfNeeded];
    
    return self.prototypeCell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMCResourceAndSubMetricTableViewCell *cell = (BMCResourceAndSubMetricTableViewCell *)self.prototypeCell;
    
    ResMetricPojo *resMetricPojo = (ResMetricPojo *)self.dataSource[indexPath.row];
    if ([ColorHandler isNullOrEmptyString:resMetricPojo.metricValue]) {
        cell.contentLbl.text = @"——";
    } else {
        cell.contentLbl.text = [resMetricPojo.metricValue stringByAppendingString:resMetricPojo.metricUnit];
    }
    
    if ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    } else {
        return 55.f;
    }
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
        _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 16);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 55)];

        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, _footerView.bounds.size.height - 1, _footerView.bounds.size.width, 1);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
        [_footerView.layer addSublayer:layer];
        
        CALayer *layer1 = [CALayer layer];
        layer1.frame = CGRectMake(0, 0, _footerView.bounds.size.width, 1);
        layer1.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
        [_footerView.layer addSublayer:layer1];
        
        UIButton *addBtn = [UIButton new];
        [addBtn setTitle:@"子资源列表" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
