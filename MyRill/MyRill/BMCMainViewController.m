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

@interface BMCMainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, BMCGetEmergencyListDelegate, BMCGetMainResourceListDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;
@property (weak, nonatomic) IBOutlet UITableView *warningTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, strong) NSMutableArray *searchResultDataSource;

@property (nonatomic, strong) NSMutableArray *favoriteDataSource;
@property (nonatomic, strong) NSMutableArray *warningDataSource;

@property (nonatomic, strong) BMCGetEmergencyListDataParse *getEmergencyListDP;
@property (nonatomic, strong) BMCGetMainResourceListDataParse *getMainResourceListDP;

@end

@implementation BMCMainViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"RIIL-BMC";
    
//    [self setAutomaticallyAdjustsScrollViewInsets:YES];
//    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.warningTableView.bounds.size.width, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"条件搜索";
    self.warningTableView.tableHeaderView = searchBar;
    
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.displayController.delegate = self;
    self.displayController.searchResultsDelegate=self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.displayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"BMCEmergencyTableViewCell" bundle:nil] forCellReuseIdentifier:@"BMCEmergencyTableViewCell"];
    self.displayController.searchResultsTableView.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"];
    
    UINib *emergenceTableCell = [UINib nibWithNibName:@"BMCEmergencyTableViewCell" bundle:nil];
    [self.warningTableView registerNib:emergenceTableCell forCellReuseIdentifier:@"BMCEmergencyTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self emergenceItemOnClicked:nil];
}

#pragma mark - BMCGetMainResourceListDelegate methods
- (void)getEmergencyListSucceed:(NSArray *)resultList {
    [self.warningDataSource removeAllObjects];
    [self.warningDataSource addObjectsFromArray:resultList];
    [self.warningTableView reloadData];
}

- (void)getEmergencyeListFailed:(NSString *)errorMessage {
    
}

- (void)getMainResourceListSucceed:(NSArray *)resultList {
    [self.warningDataSource removeAllObjects];
    [self.warningDataSource addObjectsFromArray:resultList];
}

- (void)getMainResourceListFailed:(NSString *)errorMessage {
    
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.favoriteTableView]) {
        return self.favoriteDataSource.count;
    } else if ([tableView isEqual:self.displayController.searchResultsTableView]) {
        return self.searchResultDataSource.count;
    }else {
        return self.warningDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.warningTableView] || [tableView isEqual:self.displayController.searchResultsTableView]) {
        BMCEmergencyTableViewCell *cell = (BMCEmergencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCEmergencyTableViewCell" forIndexPath:indexPath];
        if ([tableView isEqual:self.displayController.searchResultsTableView]) {
            [cell updateBMCEmergencyCell:self.searchResultDataSource[indexPath.row]];
        } else {
            [cell updateBMCEmergencyCell:self.warningDataSource[indexPath.row]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, cell.bounds.size.height - 10, cell.bounds.size.width, 10);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
        [cell.layer addSublayer:layer];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.warningTableView] || [tableView isEqual:self.displayController.searchResultsTableView]) {
        return 144.f;
    } else {
        return 44;
    }
}

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

- (IBAction)favoriteItemOnClicked:(UIBarButtonItem *)sender {
    [self.getMainResourceListDP getMainResourceListWithTreeNodeId:@"00"
                                                        pageIndex:@"1"
                                                            state:@"all"
                                                       sortColumn:@"venderName"
                                                         sortType:@"asc"];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) animated:YES];
}

- (IBAction)emergenceItemOnClicked:(UIBarButtonItem *)sender {
    [self.getEmergencyListDP getEmergencyListWithViewType:@"unaccepted_event_view"];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) animated:YES];
}

#pragma mark - setters&getters
- (BMCGetEmergencyListDataParse *)getEmergencyListDP {
    if (!_getEmergencyListDP) {
        _getEmergencyListDP = [[BMCGetEmergencyListDataParse alloc] init];
        _getEmergencyListDP.delegate = self;
    }
    
    return _getEmergencyListDP;
}

- (BMCGetMainResourceListDataParse *)getMainResourceListDP {
    if (!_getMainResourceListDP) {
        _getMainResourceListDP = [[BMCGetMainResourceListDataParse alloc] init];
        _getMainResourceListDP.delegate = self;
    }
    return _getMainResourceListDP;
}

- (NSMutableArray *)favoriteDataSource {
    if (!_favoriteDataSource) {
        _favoriteDataSource = [[NSMutableArray alloc] init];
    }
    
    return _favoriteDataSource;
}

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
