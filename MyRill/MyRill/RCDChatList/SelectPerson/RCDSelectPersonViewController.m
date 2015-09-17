//
//  RCDSelectPersonViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/27.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//
#import <RongIMKit/RongIMKit.h>
#import "RCDSelectPersonViewController.h"
#import "RCDSelectPersonTableViewCell.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"
#import "ESContactList.h"
//#import "RCDRCIMDataSource.h"
//#import "ChatViewController.h"

@interface RCDSelectPersonViewController()

@property(nonatomic,assign)BOOL bSearchDisplay;
@property(nonatomic,strong)NSMutableArray* selectUsersInSearch;

-(void)initUserInSearchArray;
@end

@implementation RCDSelectPersonViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择联系人";
    
    //控制多选
    self.tableView.allowsMultipleSelection = YES;
    self.searchDisplayController1.searchResultsTableView.allowsMultipleSelection = YES;
    self.bSearchDisplay = NO;
    
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDSelectPersonTableViewCell" bundle:nil];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDSelectPersonTableViewCell"];
    [self.searchDisplayController1.searchResultsTableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDSelectPersonTableViewCell"];
//    _selectUsersInSearch = [NSMutableArray array];
//    _selectUsersInSearch = [NSMutableArray arrayWithArray:self.seletedUsers];
    [self initUserInSearchArray];
}
-(void)initUserInSearchArray
{
    _selectUsersInSearch = [NSMutableArray array];
    for (NSObject* tempObj in self.seletedUsers)
    {
        if ([tempObj isKindOfClass:[RCUserInfo class]])
        {
            RCUserInfo* tempUser = (RCUserInfo*)tempObj;
//            tempUser = (RCUserInfo*)tempUser;
            ESUserInfo* user = [[ESUserInfo alloc] init];
            user.userId = tempUser.userId;
            user.userName = tempUser.name;
            user.portraitUri = tempUser.portraitUri;
            
            [_selectUsersInSearch addObject:user];
        }
        else if ([tempObj isKindOfClass:[ESUserInfo class]])
        {
            [_selectUsersInSearch addObject:tempObj];
        }
    }
//    _selectUsersInSearch = [NSMutableArray arrayWithArray:self.seletedUsers];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self                      action:@selector(clickedDone:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
}



//clicked done
-(void) clickedDone:(id) sender
{
    if (self.selectUsersInSearch.count == 0 ){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择联系人!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:enterAction];
        [self showDetailViewController:alertController sender:self];
        return;
    }
    
    //get seleted users
    NSMutableArray *seletedUsers = [NSMutableArray new];
    
    for (ESUserInfo* user in self.selectUsersInSearch )
    {
        [seletedUsers addObject:user];
    }
    
    
    //excute the clickDoneCompletion
    if (self.clickDoneCompletion) {
        self.clickDoneCompletion(self,seletedUsers);
    }

}


#pragma mark -UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController1.searchResultsTableView)
    {
        return @"联系人";
    }
    else
    {
        ESContactList* contactList = [self.friends objectAtIndex:section];
        return contactList.enterpriseName;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController1.searchResultsTableView)
    {
        return 1;
    }
    return [self.friends count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController1.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    ESContactList* contactList = [self.friends objectAtIndex:section];
    return [contactList.contactList count];
}
//override delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

//override datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"RCDSelectPersonTableViewCell";

    RCDSelectPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    [cell setUserInteractionEnabled:YES];

    if(tableView == self.searchDisplayController1.searchResultsTableView)
    {
        ESUserInfo *user = self.searchResult[indexPath.row];
        
        if(user){
            cell.lblName.text = user.userName;
            [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
        }
        
        //设置选中状态
        for (ESUserInfo *userInfo in self.selectUsersInSearch) {
            if ([user.userId isEqualToString:userInfo.userId]) {
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            }
        }

        return cell;
    }
    else
    {
        ESContactList* contactList = self.friends[indexPath.section];
        ESUserInfo *user = contactList.contactList[indexPath.row];
        
        if(user){
            cell.lblName.text = user.userName;
            [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
        }
        
        //设置选中状态
        for (ESUserInfo *userInfo in self.selectUsersInSearch) {
            if ([user.userId isEqualToString:userInfo.userId]) {
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            }
        }

        
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDSelectPersonTableViewCell *cell = (RCDSelectPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    
    if(tableView == self.searchDisplayController1.searchResultsTableView)
    {
        [self.searchDisplayController1 setActive:NO animated:NO];
        ESUserInfo *user = self.searchResult[indexPath.row];
        if(user)
        {
            [self.selectUsersInSearch addObject:user];
            [self.tableView reloadData];
        }

    }
    else
    {
        ESContactList* contactList = self.friends[indexPath.section];
        ESUserInfo *user = contactList.contactList[indexPath.row];
        
        if(user){
            [self.selectUsersInSearch addObject:user];
        }

    }
    



}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDSelectPersonTableViewCell *cell = (RCDSelectPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if(tableView == self.searchDisplayController1.searchResultsTableView)
    {
        [self.searchDisplayController1 setActive:NO animated:NO];
        ESUserInfo *user = self.searchResult[indexPath.row];
        if(user)
        {
            [self.selectUsersInSearch removeObject:user];
            [self.tableView reloadData];
        }
        
    }
    else
    {
        ESContactList* contactList = self.friends[indexPath.section];
        ESUserInfo *user = contactList.contactList[indexPath.row];
        
        if(user){
            [self.selectUsersInSearch removeObject:user];
        }
        
    }

}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.bSearchDisplay = YES;
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self clickedDone:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.bSearchDisplay = NO;

//    NSLog(@"searchBarCancelButtonClicked");
}

@end
