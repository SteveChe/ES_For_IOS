//
//  RCDSearchEnterpriseViewController.m
//  MyRill
//
//  Created by Steve on 15/8/4.
//
//

#import "RCDSearchEnterpriseViewController.h"
#import "GetEnterpriseListDataParse.h"
#import "CustomShowMessage.h"
#import "RCDPhoneAddressBookTableViewCell.h"
#import "ESEnterpriseInfo.h"
#import "FollowEnterpriseDataParse.h"
#import "RCDAddressBookEnterpriseDetailViewController.h"

@interface RCDSearchEnterpriseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,GetSearchEnterpriseListDelegate,RCDPhoneAddressBookTableViewCellDelegate,FollowEnterpriseDelegate,UnFollowEnterpriseDelegate>
@property (nonatomic,strong)GetEnterpriseListDataParse* getEnterpriseListDataParse;
@property (nonatomic,strong)FollowEnterpriseDataParse* followEnterpriseDataParse;
@property (nonatomic,strong)ESEnterpriseInfo* followingEnterpriseInfo;

@property (strong, nonatomic) UISearchDisplayController* searchDisplayController1;
@property (strong, nonatomic) NSMutableArray* searchResult;
@property (strong, nonatomic) NSMutableArray* allEnterpriseList;
@property (nonatomic,assign) BOOL bFristRequest;

@end

@implementation RCDSearchEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找企业号";
    _getEnterpriseListDataParse = [[GetEnterpriseListDataParse alloc] init];
    _getEnterpriseListDataParse.getSearchEnterpriseListDelegate = self;
    
    _followEnterpriseDataParse = [[FollowEnterpriseDataParse alloc] init];
    _followEnterpriseDataParse.followEnterPriseDelegate = self;
    _followEnterpriseDataParse.unfollowEnterPriseDelegate = self;
    
    _searchResult = [[NSMutableArray alloc] init];
    _allEnterpriseList = [[NSMutableArray alloc] init];
    _bFristRequest = YES;
    // Add searchbar
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchDisplayController1 = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController1.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController1.searchResultsDelegate = self;
    _searchDisplayController1.delegate = self;
    
    [self initEnterpriseData];
    
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDPhoneAddressBookTableViewCell" bundle:nil];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDPhoneAddressBookTableViewCell"];
    [self.searchDisplayController.searchResultsTableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDPhoneAddressBookTableViewCell"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)initEnterpriseData
{
    [_getEnterpriseListDataParse searchEnterprise:@""];
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_searchResult removeAllObjects];
    if ([searchText length]) {
        [_getEnterpriseListDataParse searchEnterprise:searchText];
    }
}

#pragma mark - GetSearchEnterpriseListDelegate
-(void)getSearchEnterpriseListSucceed:(NSArray*)enterpriseList
{
    if(_bFristRequest)
    {
        _bFristRequest = NO;
        [_allEnterpriseList removeAllObjects];
        [_allEnterpriseList addObjectsFromArray:enterpriseList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return;
    }
    [_searchResult addObjectsFromArray:enterpriseList];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchDisplayController1.searchResultsTableView reloadData];
    });

}

-(void)getSearchEnterpriseListFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return _searchResult.count;

    return [_allEnterpriseList count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return nil;
    return @"企业号联系人";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCDPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDPhoneAddressBookTableViewCell" ];
    ESEnterpriseInfo* enterpriseInfo = nil;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        enterpriseInfo = [_searchResult objectAtIndex:indexPath.row];
        cell.tag = 0;
    }
    else
    {
        enterpriseInfo = [_allEnterpriseList objectAtIndex:indexPath.row];
        cell.tag = 1;
    }
    if (enterpriseInfo != nil)
    {
        cell.title.text = enterpriseInfo.enterpriseName;
        cell.subtitle.text = enterpriseInfo.enterpriseDescription;
        [cell.ivAva setImage: [UIImage imageNamed:@"头像_100"]];
        if(enterpriseInfo.bIsFollowed)
        {
            [cell.addButton setBackgroundImage:[UIImage imageNamed:@"ren_tianjia_chenggong"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.addButton setBackgroundImage:[UIImage imageNamed:@"tianjialianxiren_tianjia"] forState:UIControlStateNormal];
        }
        [cell.addButton setTag:indexPath.row];
        cell.delegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESEnterpriseInfo* enterpriseInfo = nil;

    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        enterpriseInfo = [_searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        enterpriseInfo = [_allEnterpriseList objectAtIndex:indexPath.row];
    }
    RCDAddressBookEnterpriseDetailViewController* addressBookEnterpriseDetailVC = [[RCDAddressBookEnterpriseDetailViewController alloc] init];
    addressBookEnterpriseDetailVC.enterpriseId = enterpriseInfo.enterpriseId;
    [self.navigationController pushViewController:addressBookEnterpriseDetailVC animated:YES];
}

#pragma mark-- RCDPhoneAddressBookTableViewCellDelegate
-(void)addButtonClick:(id)sender
{
    RCDPhoneAddressBookTableViewCell* cell = (RCDPhoneAddressBookTableViewCell*) sender;
    NSInteger rowIndex = cell.addButton.tag;
//
    ESEnterpriseInfo* enterpriseInfo = nil;
    if (cell.tag == 0)
    {
        enterpriseInfo  = [_searchResult objectAtIndex:rowIndex];
    }
    else
    {
        enterpriseInfo = [_allEnterpriseList objectAtIndex:rowIndex];
    }
    _followingEnterpriseInfo = enterpriseInfo;
    if (!enterpriseInfo.bIsFollowed) {
        [_followEnterpriseDataParse followEnterPriseWithEnterpriseId:enterpriseInfo.enterpriseId];
    }
    else {
        [_followEnterpriseDataParse unfollowEnterPriseWithEnterpriseId:enterpriseInfo.enterpriseId];
    }
    
    [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
}
#pragma mark-- FollowEnterpriseDelegate
-(void)followEnterpriseSucceed
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:@"关注企业成功"];
    _followingEnterpriseInfo.bIsFollowed = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.searchDisplayController.searchResultsTableView.hidden == NO )
                [self.searchDisplayController.searchResultsTableView reloadData];
            else
                [self.tableView reloadData];
        });
    });
}
-(void)followEnterpriseFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark-- UnFollowEnterpriseDelegate
-(void)unFollowEnterpriseSucceed
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:@"取消关注企业成功"];
    _followingEnterpriseInfo.bIsFollowed = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.searchDisplayController.searchResultsTableView.hidden == NO )
                [self.searchDisplayController.searchResultsTableView reloadData];
            else
                [self.tableView reloadData];

        });
    });

}
-(void)unFollowEnterpriseFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];

}

@end
