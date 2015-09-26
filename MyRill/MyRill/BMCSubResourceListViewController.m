//
//  BMCSubResourceListViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/17.
//
//

#import "BMCSubResourceListViewController.h"
#import "BMCResourceDetailTableViewCell.h"
#import "EventVO.h"
#import "ColorHandler.h"

#import "ResMetricPojo.h"
#import "BMCSubResourceDetailViewController.h"
#import "CustomShowMessage.h"

@interface BMCSubResourceListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *resourceName;
@property (weak, nonatomic) IBOutlet UILabel *resourceIP;
@property (weak, nonatomic) IBOutlet UILabel *resourceType;
@property (nonatomic, strong) BMCResourceDetailTableViewCell *prototypeCell;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation BMCSubResourceListViewController
#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"子资源列表";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BMCResourceDetailTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"BMCResourceDetailTableViewCell"];
    
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BMCResourceDetailTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

#pragma mark - BMCGetResourceMetricListDelegate methods
//- (void)getResourceMetricListSucceed:(NSArray *)resultList {
//    [self.dataSource removeAllObjects];
//    [self.dataSource addObjectsFromArray:resultList];
//    [self.tableView reloadData];
//    
//    self.resourceName.text = self.eventVO.resName;
//    self.resourceIP.text = self.eventVO.ip;
//    self.resourceType.text = self.eventVO.resType;
//}
//
//- (void)getResourceMetricListFailed:(NSString *)errorMessage {
//    [[CustomShowMessage getInstance] showNotificationMessage:@"获取主资源信息失败!"];
//}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMCResourceDetailTableViewCell *cell = (BMCResourceDetailTableViewCell *)self.prototypeCell;
    
    ResMetricPojo *logSummaryEventAlarmPojo = (ResMetricPojo *)self.dataSource[indexPath.row];
    cell.contentLbl.text = [ColorHandler isNullOrEmptyString:logSummaryEventAlarmPojo.metricValue] ? @"——" : logSummaryEventAlarmPojo.metricValue;
    
    if ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    } else {
        return 44.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell  = nil;
    BMCResourceDetailTableViewCell *cell = (BMCResourceDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCResourceDetailTableViewCell" forIndexPath:indexPath];
    
    ResMetricPojo *mainMetric = (ResMetricPojo *)self.dataSource[indexPath.row];
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
    ResMetricPojo *mainMetric = (ResMetricPojo *)self.dataSource[indexPath.row];
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

@end
