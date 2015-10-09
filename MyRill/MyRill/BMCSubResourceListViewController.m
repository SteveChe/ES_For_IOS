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
#import "BMCGetSubResourceListDataParse.h"
#import "SubResPojo.h"
#import "BMCSubResourceDetailViewController.h"
#import "CustomShowMessage.h"

@interface BMCSubResourceListViewController () <UITableViewDataSource, UITableViewDelegate, BMCGetSubResourceListDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *resourceName;
@property (weak, nonatomic) IBOutlet UILabel *resourceIP;
@property (weak, nonatomic) IBOutlet UILabel *resourceType;
@property (nonatomic, strong) BMCResourceDetailTableViewCell *prototypeCell;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) BMCGetSubResourceListDataParse *getSubResourceListDP;

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
    
    //数据量大，只在viewDidLoad中获取一次，避免重新出栈时在获取一次
    [self.getSubResourceListDP getSubResourceListWithResId:self.eventVO.resId];
}

#pragma mark - BMCGetResourceMetricListDelegate methods
- (void)getSubResourceListSucceed:(NSDictionary *)resultDic {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:resultDic[@"subResList"]];
    [self.tableView reloadData];
    
    self.resourceName.text = [ColorHandler isNullOrEmptyString:resultDic[@"resName"]] ? @"——" : resultDic[@"resName"];
    self.resourceIP.text = [ColorHandler isNullOrEmptyString:resultDic[@"resIp"]] ? @"——" : resultDic[@"resIp"];
    self.resourceType.text = [ColorHandler isNullOrEmptyString:resultDic[@"resType"]] ? @"——" : resultDic[@"resType"];
}

- (void)getSubResourceListFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:@"获取子资源列表失败!"];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMCResourceDetailTableViewCell *cell = (BMCResourceDetailTableViewCell *)self.prototypeCell;
    
    SubResPojo *subResPojo = (SubResPojo *)self.dataSource[indexPath.row];
    cell.contentLbl.text = [ColorHandler isNullOrEmptyString:subResPojo.subName] ? @"——" : subResPojo.subName;
    
    if ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    } else {
        return 44.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell  = nil;
    BMCResourceDetailTableViewCell *cell = (BMCResourceDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCResourceDetailTableViewCell" forIndexPath:indexPath];
    
    SubResPojo *subResPojo = (SubResPojo *)self.dataSource[indexPath.row];
    cell.titleLbl.text = [NSString stringWithFormat:@"(%@)",subResPojo.subResType];
    cell.contentLbl.text = [ColorHandler isNullOrEmptyString:subResPojo.subName] ? @"——" : subResPojo.subName;
    cell.arrowView.hidden = [ColorHandler isNullOrEmptyString:subResPojo.subResId] ? YES : NO;
    
    self.prototypeCell = cell;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [self.prototypeCell.layer addSublayer:layer];
    [self.prototypeCell layoutIfNeeded];
    
    return self.prototypeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubResPojo *subResPojo = (SubResPojo *)self.dataSource[indexPath.row];
    NSLog(@"%@",subResPojo.subResId);
    if ([ColorHandler isNullOrEmptyString:subResPojo.subResId]) {
        return;
    }
    BMCSubResourceDetailViewController *subResourceDetailVC = [[BMCSubResourceDetailViewController alloc] init];
    subResourceDetailVC.subResId = subResPojo.subResId;
    [self.navigationController pushViewController:subResourceDetailVC animated:YES];
}

#pragma mark - setters&getters
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (BMCGetSubResourceListDataParse *)getSubResourceListDP {
    if (!_getSubResourceListDP) {
        _getSubResourceListDP = [[BMCGetSubResourceListDataParse alloc] init];
        _getSubResourceListDP.delegate = self;
    }
    
    return _getSubResourceListDP;
}

@end
