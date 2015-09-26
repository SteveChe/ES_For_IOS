//
//  BMCSubResourceDetailViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCSubResourceDetailViewController.h"
#import "BMCGetSubResourceMetricListDataParse.h"
#import "BMCResourceAndSubMetricTableViewCell.h"
#import "ResMetricPojo.h"
#import "ColorHandler.h"
#import "CustomShowMessage.h"

@interface BMCSubResourceDetailViewController () <UITableViewDataSource, UITableViewDelegate, BMCGetSubResourceMetricListDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BMCResourceAndSubMetricTableViewCell *prototypeCell;

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
    
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BMCResourceAndSubMetricTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.getSubResourceMetricListDP getSubResourceMetricListWithSubResId:self.subResId];
}

#pragma mark - BMCGetSubResourceMetricListDelegate methods
- (void)getSubResourceMetricListSucceed:(NSArray *)resultList {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:resultList];
    [self.tableView reloadData];
}

- (void)getSubResourceMetricListFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:@"获取子资源详情失败!"];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
        return 44.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell  = nil;
    BMCResourceAndSubMetricTableViewCell *subResourceDetailCell = (BMCResourceAndSubMetricTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCResourceAndSubMetricTableViewCell" forIndexPath:indexPath];
    ResMetricPojo *resMetricPojo = (ResMetricPojo *)self.dataSource[indexPath.row];
    subResourceDetailCell.titleLbl.text = resMetricPojo.metricName;
    if ([ColorHandler isNullOrEmptyString:resMetricPojo.metricValue]) {
        subResourceDetailCell.contentLbl.text = @"——";
    } else {
        subResourceDetailCell.contentLbl.text = [resMetricPojo.metricValue stringByAppendingString:resMetricPojo.metricUnit];
    }
    
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
        [_tableView registerNib:[UINib nibWithNibName:@"BMCResourceAndSubMetricTableViewCell" bundle:nil] forCellReuseIdentifier:@"BMCResourceAndSubMetricTableViewCell"];
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
