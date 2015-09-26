//
//  BMCMainViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import "BMCMainViewController.h"
#import "BMCGetEmergencyListDataParse.h"
#import "BMCGetMainResourceListDataParse.h"
#import "BMCEmergencyTableViewCell.h"
#import "ColorHandler.h"
#import "BMCSubResourceListViewController.h"
#import "BMCLoginViewController.h"
#import "EventVO.h"
#import "CustomShowMessage.h"

@interface BMCMainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, BMCGetEmergencyListDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *warningTableView;
@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) IBOutlet UILabel *alertLbl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) BMCEmergencyTableViewCell *prototypeCell;

@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, strong) NSMutableArray *searchResultDataSource;
@property (nonatomic, strong) NSMutableArray *warningDataSource;

@property (nonatomic, strong) BMCGetEmergencyListDataParse *getEmergencyListDP;

//@property (nonatomic, strong) BMCGetMainResourceListDataParse *getMainResourceListDP;

@end

@implementation BMCMainViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"RIIL-BMC";
    
    //[self setAutomaticallyAdjustsScrollViewInsets:YES];
    
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate = self;
    self.displayController.searchResultsDelegate=self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.displayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"BMCEmergencyTableViewCell" bundle:nil]
                                        forCellReuseIdentifier:@"BMCEmergencyTableViewCell"];
    self.displayController.searchResultsTableView.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"];
    
    [self.warningTableView registerNib:[UINib nibWithNibName:@"BMCEmergencyTableViewCell" bundle:nil]
                forCellReuseIdentifier:@"BMCEmergencyTableViewCell"];
    self.warningTableView.estimatedRowHeight = 144;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    [self.getEmergencyListDP getEmergencyListWithViewType:@"unaccepted_event_view"];
}

#pragma mark - BMCGetEmergencyListDelegate methods
- (void)getEmergencyListSucceed:(NSArray *)resultList {
    [self.warningDataSource removeAllObjects];
    [self.warningDataSource addObjectsFromArray:resultList];
    [self.warningTableView reloadData];
    
    self.alertLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)resultList.count];
}

- (void)getEmergencyeListFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:@"获取告警列表失败!"];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.displayController.searchResultsTableView]) {
        return self.searchResultDataSource.count;
    }else {
        return self.warningDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell = nil;
    BMCEmergencyTableViewCell *cell = (BMCEmergencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCEmergencyTableViewCell" forIndexPath:indexPath];
    if ([tableView isEqual:self.displayController.searchResultsTableView]) {
        [cell updateBMCEmergencyCell:self.searchResultDataSource[indexPath.row]];
    } else {
        [cell updateBMCEmergencyCell:self.warningDataSource[indexPath.row]];
    }
    
    self.prototypeCell = cell;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 10);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [self.prototypeCell.layer addSublayer:layer];
    [self.prototypeCell layoutIfNeeded];
    
    return self.prototypeCell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    
//    BMCEmergencyTableViewCell *cell = (BMCEmergencyTableViewCell *)self.prototypeCell;
//    
//    EventVO *eventVO = (EventVO *)self.warningDataSource[indexPath.row];
//    cell.warningLbl.text = eventVO.name;
//    
//    if ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
//        NSLog(@"%f",cell.contentView.bounds.size.height);
//        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//    } else {
//        return 144.f;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 168.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMCSubResourceListViewController *bmcEmergencyDetailVC = [[BMCSubResourceListViewController alloc] init];
    bmcEmergencyDetailVC.eventVO = (EventVO *)self.warningDataSource[indexPath.row];
    [self.navigationController pushViewController:bmcEmergencyDetailVC animated:YES];
}

//-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
//{
//    [tableView setContentInset:UIEdgeInsetsZero];
//    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
//}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF.description CONTAINS[c] %@",searchString];
    
    if (self.searchResultDataSource!= nil) {
        [self.searchResultDataSource removeAllObjects];
    }
    //过滤数据
    [self.searchResultDataSource addObjectsFromArray:[self.warningDataSource filteredArrayUsingPredicate:preicate]];
    //刷新表格
    return YES;
}

#pragma mark - response events
- (IBAction)backToLoginView:(UIButton *)sender {
    BMCLoginViewController *bmcLoginVC = [[BMCLoginViewController alloc] init];
    UITabBarController *tabbarVC = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:tabbarVC animated:YES];
    [tabbarVC.navigationController  pushViewController:bmcLoginVC animated:YES];
}

#pragma mark - setters&getters
- (void)setAlertLbl:(UILabel *)alertLbl {
    _alertLbl = alertLbl;
    
    _alertLbl.layer.cornerRadius = 9.f;
}

- (BMCGetEmergencyListDataParse *)getEmergencyListDP {
    if (!_getEmergencyListDP) {
        _getEmergencyListDP = [[BMCGetEmergencyListDataParse alloc] init];
        _getEmergencyListDP.delegate = self;
    }
    
    return _getEmergencyListDP;
}

//- (BMCGetMainResourceListDataParse *)getMainResourceListDP {
//    if (!_getMainResourceListDP) {
//        _getMainResourceListDP = [[BMCGetMainResourceListDataParse alloc] init];
//        _getMainResourceListDP.delegate = self;
//    }
//    return _getMainResourceListDP;
//}

- (NSMutableArray *)warningDataSource {
    if (!_warningDataSource) {
        _warningDataSource = [[NSMutableArray alloc] init];
    }
    
    return _warningDataSource;
}

- (NSMutableArray *)searchResultDataSource {
    if (!_searchResultDataSource) {
        _searchResultDataSource = [[NSMutableArray alloc] init];
    }
    
    return _searchResultDataSource;
}

@end
