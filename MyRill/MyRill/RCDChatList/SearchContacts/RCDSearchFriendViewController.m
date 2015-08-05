//
//  RCDSearchFriendTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/12.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import "RCDSearchFriendViewController.h"
#import "MBProgressHUD.h"
#import "AFHttpTool.h"
#import "UIImageView+WebCache.h"
//#import "RCDRCIMDataSource.h"
#import "ESUserInfo.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDAddFriendViewController.h"
#import "CustomShowMessage.h"
#import "RCDPhoneAddressBookViewController.h"
//#import "RCDAddressBookQRCodeViewController.h"
#import "QRCodeViewController.h"
#import "RCDSearchEnterpriseViewController.h"
#import "FollowEnterpriseDataParse.h"


@interface RCDSearchFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) SearchContactDataParse * searchContactDataParse;
@property (strong, nonatomic) UISearchDisplayController* searchDisplayController1;

@end

@implementation RCDSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationItem.title = @"查找好友";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;

//   self.searchDisplayController.searchResultsTableView.delegate = self;
    
    //initial data
    _searchResult=[[NSMutableArray alloc] init];
    _searchContactDataParse = [[SearchContactDataParse alloc] init];
    _searchContactDataParse.delegate = self;
    
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - searchResultDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return _searchResult.count;
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableCellWithIdentifier = @"RCDSearchResultTableViewCell";
        RCDSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
        ESUserInfo *user =_searchResult[indexPath.row];
        if(user){
            cell.lblName.text = user.userName;
            [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
        }
    }
    else
    {
        cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = @"手机添加联系人";
                cell.imageView.image = [UIImage imageNamed:@"tianjialianxiren_shouji"];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"二维码添加";
                cell.imageView.image = [UIImage imageNamed:@"tianjialianxiren_erweima"];
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"企业号添加";
                cell.imageView.image = [UIImage imageNamed:@"tianjialianxiren_qiyehao"];
            }
                break;
            default:
                break;
        }
    }
    
    return cell;

}


#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        ESUserInfo *user = _searchResult[indexPath.row];
        RCUserInfo *userInfo = [RCUserInfo new];
        userInfo.userId = user.userId;
        userInfo.name = user.userName;
        userInfo.portraitUri = user.portraitUri;
        RCDAddFriendViewController *addViewController = [[RCDAddFriendViewController alloc] init];
        addViewController.strUserId = userInfo.userId;
        [self.navigationController pushViewController:addViewController animated:YES];
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
            {
                RCDPhoneAddressBookViewController* phoneAddressBookViewController = [[RCDPhoneAddressBookViewController alloc] init];
                [self.navigationController pushViewController:phoneAddressBookViewController animated:YES];
            }
                break;
            case 1:
            {
                QRCodeViewController* addressBookQRCodeViewController = [[QRCodeViewController alloc] init];
                [self.navigationController pushViewController:addressBookQRCodeViewController animated:YES];
            }
                break;
            case 2:
            {
                RCDSearchEnterpriseViewController* searchEnterpriseVC = [[RCDSearchEnterpriseViewController alloc] init];
                [self.navigationController pushViewController:searchEnterpriseVC animated:YES];

            }
                break;
            default:
                break;
        }
    }
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
        [_searchContactDataParse searchContacts:searchText];
    }
}

#pragma mark SearchContactDelegate
-(void)searchContactResult:(NSArray*)contactsResult
{
    [_searchResult addObjectsFromArray:contactsResult];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchDisplayController1.searchResultsTableView reloadData];
    });
}

-(void)searchContactFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

@end
