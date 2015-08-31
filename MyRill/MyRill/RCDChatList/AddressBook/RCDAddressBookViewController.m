//
//  RCDAddressBookViewController.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import "RCDAddressBookViewController.h"
//#import "RCDRCIMDataSource.h"
#import <RongIMLib/RongIMLib.h>
#import "UIImageView+WebCache.h"
#import "AFHttpTool.h"
#import "pinyin.h"
#import "ESUserInfo.h"
#import "ESContactList.h"
#include <ctype.h>
#import "RCDAcceptContactViewController.h"
#import "RCDSearchFriendViewController.h"
#import "RCDAddressBookViewTableViewCell.h"
#import "RCDAddressBookDetailViewController.h"
#import "ColorHandler.h"
#import "RCDApprovedJoinEnterpriseViewController.h"
#import "GetEnterpriseListDataParse.h"
#import "ESEnterpriseInfo.h"
#import "RCDAddressBookEnterpriseDetailViewController.h"
#import "DiscussionChatListViewController.h"
#import "PushDefine.h"
#import "GetRequestContactListDataParse.h"
#import "EnterPriseRequestDataParse.h"

@interface RCDAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,GetFollowedEnterpriseListDelegate,GetRequestContactListDelegate,GetEnterPriseRequestListDelegate>

//#字符索引对应的user object
@property (nonatomic,strong) NSMutableArray *tempOtherArr;
@property (nonatomic,strong) GetContactListDataParse* getContactListDataParse;
@property (nonatomic,strong) GetEnterpriseListDataParse* getEnterpriseListDataParse;
@property (nonatomic,strong)GetRequestContactListDataParse* getRequestContactListDataParse;
@property (nonatomic,strong)EnterPriseRequestDataParse* enterpriseRequestDataParse;
@property (nonatomic,strong) NSMutableArray *requestContactList;
@property (nonatomic,strong) NSMutableArray *enterpriseRequestContactList;


@end

@implementation RCDAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"联系人";
    
    _getContactListDataParse = [[GetContactListDataParse alloc] init];
    _getContactListDataParse.delegate = self;
    
    _getEnterpriseListDataParse = [[GetEnterpriseListDataParse alloc] init];
    _getEnterpriseListDataParse.getFollowedEnterPriseListDelegate = self;
    
    _getRequestContactListDataParse = [[GetRequestContactListDataParse alloc] init];
    _getRequestContactListDataParse.delegate = self;

    _enterpriseRequestDataParse = [EnterPriseRequestDataParse alloc];
    _enterpriseRequestDataParse.getEnterPriseRequestListDelegate = self;
    
    // Add searchbar
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchDisplayController1 = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    _searchDisplayController1.searchResultsDataSource = self;
    _searchDisplayController1.searchResultsDelegate = self;
    _searchDisplayController1.delegate = self;
    //    self.searchDisplayController.searchBar = searchBar;
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDAddressBookViewTableViewCell" bundle:nil];
    [_searchDisplayController1.searchResultsTableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDAddressBookViewTableViewCell"];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDAddressBookViewTableViewCell"];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self getAllData];
    
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self                      action:@selector(addButtonOnClicked:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;

}

//删除已选中用户
-(void) removeSelectedUsers:(NSArray *) selectedUsers
{
    for (RCUserInfo *user in selectedUsers) {
        
        [_friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ESUserInfo *userInfo = obj;
            if ([user.userId isEqualToString:userInfo.userId]) {
                [_friends removeObject:obj];
            }
            
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  initial data
 */

-(void) getAllData
{
    [_getContactListDataParse getContactList];
    [_getEnterpriseListDataParse getFollowedEnterpriseList];
    [_getRequestContactListDataParse getRequestedContactList];
    [_enterpriseRequestDataParse getEnterPriseRequestList];
}

#pragma mark - GetFollowedEnterpriseListDelegate
-(void)getFollowedEnterpriseListSucceed:(NSArray*)enterpriseList
{
    _enterprises = [NSMutableArray arrayWithArray:enterpriseList];
    if (_enterprises==nil || [_enterprises count]<=0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
-(void)getFollowedEnterpriseListFailed:(NSString*)errorMessage
{
    
}


#pragma mark - GetContactListDelegate
-(void)getContactList:(NSArray*)contactList
{
    _friends = [NSMutableArray arrayWithArray:contactList];
    if (_friends==nil || [_friends count]<=0)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

-(void)getContactListFailed:(NSString *)errorMessage
{

}

#pragma mark -- GetRequestContactListDelegate
-(void)getRequestedContactList:(NSArray*)contactList
{
    _requestContactList = [NSMutableArray arrayWithArray:contactList];
    if (_requestContactList==nil || [_requestContactList count]<=0)
    {
        return;
    }
    if (contactList!=nil && [contactList count]>0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }
}

-(void)getRequestedContactListFailed:(NSString*)errorMessage
{
    
}

#pragma mark - GetEnterPriseRequestListDelegate

-(void)getEnterPriseRequestListSucceed:(NSArray*)requestList
{
    _enterpriseRequestContactList = [NSMutableArray arrayWithArray:requestList];
    if (_enterpriseRequestContactList==nil || [_enterpriseRequestContactList count]<=0)
    {
        return;
    }
    if (requestList!=nil && [requestList count]>0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }
    
}
-(void)getEnterPriseRequestListFailed:(NSString*)errorMessage
{
    
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"RCDAddressBookViewTableViewCell";
    RCDAddressBookViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    if(tableView == self.searchDisplayController1.searchResultsTableView)
//    if(tableView == _searchDisplayController1.searchResultsTableView)

    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        ESUserInfo *user = _searchResult[indexPath.row];
        if(user){
            cell.addressBookName.text = user.userName;
            [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
            cell.ivAva.clipsToBounds = YES;
            cell.ivAva.layer.cornerRadius = 18.f;
        }
        
        return cell;
    }
    else
    {
        if (indexPath.section == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.addressBookName.text = @"新的联系人";
                    cell.ivAva.image = [UIImage imageNamed:@"lianxiren_xindelianxiren"];
                    if (_requestContactList!=nil && [_requestContactList count]>0)
                    {
                        cell.redBadgeLabel.hidden = NO;
//                        self.tabBarItem.badgeValue = @"1";
                    }
                    else
                    {
                        cell.redBadgeLabel.hidden = YES;
//                        self.tabBarItem.badgeValue = nil;
                    }
                }
                    break;
                case 1:
                {
                    cell.addressBookName.text = @"加入企业请求";
                    cell.ivAva.image = [UIImage imageNamed:@"lianxiren_xindelianxiren"];
                    //_enterpriseRequestContactList
                    if (_enterpriseRequestContactList!=nil && [_enterpriseRequestContactList count]>0)
                    {
                        cell.redBadgeLabel.hidden = NO;
                        //                        self.tabBarItem.badgeValue = @"1";
                    }
                    else
                    {
                        cell.redBadgeLabel.hidden = YES;
                        //                        self.tabBarItem.badgeValue = nil;
                    }
                }
                    break;

                case 2:
                {
                    cell.addressBookName.text = @"多人聊天组";
                    cell.ivAva.image = [UIImage imageNamed:@"lianxiren_duorenliaotianzu"];
                }
                    
                default:
                    break;
            }
            return cell;
        }
        else if (indexPath.section == 1)
        {
            if ([_enterprises count] > 0)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                ESEnterpriseInfo* enterpriseInfo = _enterprises[indexPath.row];
                if (enterpriseInfo) {
                    cell.addressBookName.text = enterpriseInfo.enterpriseName;
                    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:enterpriseInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
//                    [cell.ivAva setImage:[UIImage imageNamed:@"头像_100"]];
                    cell.ivAva.clipsToBounds = YES;
                    cell.ivAva.layer.cornerRadius = 18.f;
                    
                }
                return cell;
                
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                ESContactList* contactList = _friends[indexPath.section-1];
                
                ESUserInfo *user = contactList.contactList[indexPath.row];
                if(user){
                    cell.addressBookName.text = user.userName;
                    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
                    cell.ivAva.clipsToBounds = YES;
                    cell.ivAva.layer.cornerRadius = 18.f;
                }
                
                return cell;
            }
        }
        else
        {
            ESContactList* contactList = nil;
            if ([_enterprises count] > 0)
            {
                contactList = [_friends objectAtIndex:indexPath.section-2];
            }
            else
            {
                contactList = [_friends objectAtIndex:indexPath.section-1];
            }

            cell.accessoryType = UITableViewCellAccessoryNone;
            
            ESUserInfo *user = contactList.contactList[indexPath.row];
            if(user){
                cell.addressBookName.text = user.userName;
                [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
                cell.ivAva.clipsToBounds = YES;
                cell.ivAva.layer.cornerRadius = 18.f;
            }
            
            return cell;
        }

    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController1.searchResultsTableView)
//    if(tableView == _searchDisplayController1.searchResultsTableView)
    {
        return [_searchResult count];
    }
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        if ([_enterprises count]>0)
        {
            return [_enterprises count];
        }
        else
        {
            ESContactList* contactList = [_friends objectAtIndex:section-1];
            return [contactList.contactList count];
        }
    }
    else
    {
        if ([_enterprises count] > 0)
        {
            ESContactList* contactList = [_friends objectAtIndex:section-2];
            return [contactList.contactList count];
        }
        else
        {
            ESContactList* contactList = [_friends objectAtIndex:section-1];
            return [contactList.contactList count];
        }

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController1.searchResultsTableView)
//    if(tableView == _searchDisplayController1.searchResultsTableView)
    {
        return 1;
    }
    if ([_enterprises count] > 0)
    {
        return [_friends count]+1+1;
    }
    return [_friends count]+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController1.searchResultsTableView)
//    if(tableView == _searchDisplayController1.searchResultsTableView)
    {
        return @"联系人";
    }
    else
    {
        if (section == 0)
        {
            return nil;
        }
        else if(section == 1)
        {
            if ([_enterprises count] > 0)
            {
                return @"企业号联系人";
            }
            else
            {
                ESContactList* contactList = [_friends objectAtIndex:section-1];
                return contactList.enterpriseName;
            }
        }
        else
        {
            if ([_enterprises count] > 0)
            {
                ESContactList* contactList = [_friends objectAtIndex:section-2];
                return contactList.enterpriseName;
            }
            else
            {
                ESContactList* contactList = [_friends objectAtIndex:section-1];
                return contactList.enterpriseName;
            }
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController1.searchResultsTableView)
//    if(tableView == _searchDisplayController1.searchResultsTableView)
    {
        ESUserInfo *user = _searchResult[indexPath.row];

        RCDAddressBookDetailViewController* addressBookDetailVC = [[RCDAddressBookDetailViewController alloc] init];
//        ESUserInfo *user = contactList.contactList[indexPath.row];
        addressBookDetailVC.userId = user.userId;
        [self.navigationController pushViewController:addressBookDetailVC animated:YES];
    }
    else
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                RCDAcceptContactViewController* acceptContactVC = [[RCDAcceptContactViewController alloc] init];
                [self.navigationController pushViewController:acceptContactVC animated:YES];
            }
            else if(indexPath.row == 1)
            {
                RCDApprovedJoinEnterpriseViewController* approvedJoinEnterpriseVC = [[RCDApprovedJoinEnterpriseViewController alloc] init ];
                [self.navigationController pushViewController:approvedJoinEnterpriseVC animated:YES];
            }
            else if(indexPath.row == 2)
            {
                DiscussionChatListViewController* discussionChatListVC = [[DiscussionChatListViewController alloc] init];
                [self.navigationController pushViewController:discussionChatListVC animated:YES];

            }
            
        }
        else if (indexPath.section == 1)
        {
            if ([_enterprises count]>0)
            {
                RCDAddressBookEnterpriseDetailViewController* addressBookEnterpriseDetailVC = [[RCDAddressBookEnterpriseDetailViewController alloc] init];
                ESEnterpriseInfo* enterpriseInfo = [_enterprises objectAtIndex:indexPath.row];
                addressBookEnterpriseDetailVC.enterpriseId = enterpriseInfo.enterpriseId;
                [self.navigationController pushViewController:addressBookEnterpriseDetailVC animated:YES];
            }
            else
            {
                RCDAddressBookDetailViewController* addressBookDetailVC = [[RCDAddressBookDetailViewController alloc] init];
                ESContactList* contactList = [_friends objectAtIndex:indexPath.section-1];
                ESUserInfo *user = contactList.contactList[indexPath.row];
                addressBookDetailVC.userId = user.userId;
                [self.navigationController pushViewController:addressBookDetailVC animated:YES];
            }
        }
        else
            
        {
            ESContactList* contactList = nil;
            if ([_enterprises count] > 0)
            {
                contactList = [_friends objectAtIndex:indexPath.section-2];
            }
            else
            {
                contactList = [_friends objectAtIndex:indexPath.section-1];
            }

            RCDAddressBookDetailViewController* addressBookDetailVC = [[RCDAddressBookDetailViewController alloc] init];
            ESUserInfo *user = contactList.contactList[indexPath.row];
            addressBookDetailVC.userId = user.userId;
            [self.navigationController pushViewController:addressBookDetailVC animated:YES];

        }
    }

}


#pragma mark - event repond
-(void)addButtonOnClicked:(id)sender
{
    RCDSearchFriendViewController *  searchFrendVC = [[RCDSearchFriendViewController alloc] init];
    [self.navigationController pushViewController:searchFrendVC animated:YES];
}

#pragma mark - 拼音排序

/**
 *  汉字转拼音
 *
 *  @param hanZi 汉字
 *
 *  @return 转换后的拼音
 */
-(NSString *) hanZiToPinYinWithString:(NSString *)hanZi
{
    if(!hanZi) return nil;
    NSString *pinYinResult=[NSString string];
    for(int j=0;j<hanZi.length;j++){
        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([hanZi characterAtIndex:j])] uppercaseString];
        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    
    return pinYinResult;

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
    if (_searchResult == nil)
    {
        _searchResult = [NSMutableArray array];
    }
    
    [_searchResult removeAllObjects];
    
    if ([searchText length] > 0)
    {
        for ( int i = 0 ; i < [_friends count] ; i++ )
        {
//            ESContactList* contactListTemp = [[ESContactList alloc] init];
//            NSMutableArray* contactListArray = [NSMutableArray array];
            ESContactList* contactList = _friends[i];
            for (ESUserInfo* user in contactList.contactList )
            {
                if(user.userName != nil && [user.userName length] > 0 )
                {
                    NSRange range1 = [user.userName rangeOfString:searchText];
                    if (range1.length > 0)
                    {
                        [_searchResult addObject:user];
                        continue;
                    }
                }
                if (user.phoneNumber != nil && [user.phoneNumber length] > 0)
                {
                    NSRange range2 = [user.phoneNumber rangeOfString:searchText];
                    if (range2.length > 0)
                    {
                        [_searchResult addObject:user];
                        continue;
                    }
                }
                
            }
        }
    }
    
//    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.searchDisplayController1.searchResultsTableView reloadData];
}



@end
