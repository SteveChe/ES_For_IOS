//
//  BMCResourceDetailViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/17.
//
//

#import "BMCResourceDetailViewController.h"
#import "BMCResourceDetailTableViewCell.h"
#import "EventVO.h"
#import "ColorHandler.h"
#import "BMCGetResourceMetricListDataParse.h"
#import "LogSummaryEventAlarmPojo.h"
#import "BMCSubResourceDetailViewController.h"
#import "CustomShowMessage.h"

@interface BMCResourceDetailViewController () <UITableViewDataSource, UITableViewDelegate, BMCGetResourceMetricListDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *resourceName;
@property (weak, nonatomic) IBOutlet UILabel *resourceIP;
@property (weak, nonatomic) IBOutlet UILabel *resourceType;
@property (nonatomic, strong) BMCResourceDetailTableViewCell *prototypeCell;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) BMCGetResourceMetricListDataParse *getResourdeMetricListDP;

@end

@implementation BMCResourceDetailViewController
#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"资源详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BMCResourceDetailTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"BMCResourceDetailTableViewCell"];
    
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BMCResourceDetailTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.getResourdeMetricListDP getResourceMetricListWithResId:self.eventVO.resId];
}

#pragma mark - BMCGetResourceMetricListDelegate methods
- (void)getResourceMetricListSucceed:(NSArray *)resultList {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:resultList];
    [self.tableView reloadData];
    
    self.resourceName.text = self.eventVO.resName;
    self.resourceIP.text = self.eventVO.ip;
    self.resourceType.text = self.eventVO.resType;
}

- (void)getResourceMetricListFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:@"获取主资源信息失败!"];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 144.f;
    }
    
    BMCResourceDetailTableViewCell *cell = (BMCResourceDetailTableViewCell *)self.prototypeCell;
    
    if ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    } else {
        return 44.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell  = nil;
    BMCResourceDetailTableViewCell *cell = (BMCResourceDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCResourceDetailTableViewCell" forIndexPath:indexPath];
    
    LogSummaryEventAlarmPojo *mainMetric = (LogSummaryEventAlarmPojo *)self.dataSource[indexPath.row];
    cell.titleLbl.text = mainMetric.metricName;
    cell.contentLbl.text = [ColorHandler isNullOrEmptyString:mainMetric.metricValue] ? @"——" : mainMetric.metricValue;
    
    self.prototypeCell = cell;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [self.prototypeCell.layer addSublayer:layer];
    [self.prototypeCell layoutIfNeeded];
    
    return self.prototypeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogSummaryEventAlarmPojo *mainMetric = (LogSummaryEventAlarmPojo *)self.dataSource[indexPath.row];
    BMCSubResourceDetailViewController *subResourceDetailVC = [[BMCSubResourceDetailViewController alloc] init];
    subResourceDetailVC.subResId = mainMetric.subResId;
    [self.navigationController pushViewController:subResourceDetailVC animated:YES];
}

#pragma mark - setters&getters
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (BMCGetResourceMetricListDataParse *)getResourdeMetricListDP {
    if (!_getResourdeMetricListDP) {
        _getResourdeMetricListDP = [[BMCGetResourceMetricListDataParse alloc] init];
        _getResourdeMetricListDP.delegate = self;
    }
    
    return _getResourdeMetricListDP;
}

@end
