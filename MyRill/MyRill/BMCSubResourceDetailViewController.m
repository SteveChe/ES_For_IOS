//
//  BMCSubResourceDetailViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCSubResourceDetailViewController.h"
#import "BMCGetSubResourceMetricListDataParse.h"
#import "BMCSubResourceDetailTableViewCell.h"
#import "LogSummaryEventAlarmPojo.h"
#import "ColorHandler.h"
#import "CustomShowMessage.h"

@interface BMCSubResourceDetailViewController () <UITableViewDataSource, UITableViewDelegate, BMCGetSubResourceMetricListDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BMCSubResourceDetailTableViewCell *prototypeCell;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) BMCGetSubResourceMetricListDataParse *getSubResourceMetricListDP;

@end

@implementation BMCSubResourceDetailViewController
#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"子资源详情";
    [self.view addSubview:self.tableView];
    
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BMCSubResourceDetailTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSLog(@"!!!!! %@",self.subResId);
    [self.getSubResourceMetricListDP getSubResourceMetricListWithSubResId:self.subResId];
}

#pragma mark - BMCGetSubResourceMetricListDelegate methods
- (void)getSubResourceMetricListSucceed:(NSArray *)resultList {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:resultList];
    [self.tableView reloadData];
}

- (void)getSubResourceMetricListFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:@"获取子资源指标信息失败!"];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMCSubResourceDetailTableViewCell *cell = (BMCSubResourceDetailTableViewCell *)self.prototypeCell;
    
    LogSummaryEventAlarmPojo *logSummaryEventAlarmPojo = (LogSummaryEventAlarmPojo *)self.dataSource[indexPath.row];
    cell.contentLbl.text = [ColorHandler isNullOrEmptyString:logSummaryEventAlarmPojo.metricValue] ? @"——" : logSummaryEventAlarmPojo.metricValue;
    
    if ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    } else {
        return 44.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell  = nil;
    BMCSubResourceDetailTableViewCell *subResourceDetailCell = (BMCSubResourceDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCSubResourceDetailTableViewCell" forIndexPath:indexPath];
    LogSummaryEventAlarmPojo *logSummaryEventAlarmPojo = (LogSummaryEventAlarmPojo *)self.dataSource[indexPath.row];
    subResourceDetailCell.titleLbl.text = logSummaryEventAlarmPojo.metricName;
    subResourceDetailCell.contentLbl.text = [ColorHandler isNullOrEmptyString:logSummaryEventAlarmPojo.metricValue] ? @"——" : logSummaryEventAlarmPojo.metricValue;
    
    self.prototypeCell = subResourceDetailCell;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [self.prototypeCell.layer addSublayer:layer];
    [self.prototypeCell layoutIfNeeded];
    
    return self.prototypeCell;
}

#pragma mark - setters&getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 16)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.allowsSelection = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"BMCSubResourceDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"BMCSubResourceDetailTableViewCell"];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (BMCGetSubResourceMetricListDataParse *)getSubResourceMetricListDP {
    if (!_getSubResourceMetricListDP) {
        _getSubResourceMetricListDP = [[BMCGetSubResourceMetricListDataParse alloc] init];
        _getSubResourceMetricListDP.delegate = self;
    }
    
    return _getSubResourceMetricListDP;
}

@end
