//
//  RCDRadioSelectPersonViewController.m
//  MyRill
//
//  Created by Steve on 15/8/30.
//
//

#import "RCDRadioSelectPersonViewController.h"
#import "RCDSelectPersonTableViewCell.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"
#import "ESContactList.h"
#import "UserDefaultsDefine.h"
#import "ESEnterpriseInfo.h"

@interface RCDRadioSelectPersonViewController ()

-(void)judgeJoinedEnterprise;

@property (nonatomic,strong)RCDSelectPersonTableViewCell* selectedCell;
@property (nonatomic,assign)BOOL bJoinedEnterprise;
@property(nonatomic,assign)BOOL bSearchDisplay;

@end

@implementation RCDRadioSelectPersonViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择联系人";
    
    if (_type == e_Selected_Person_Radio)
    {
        self.tableView.allowsMultipleSelection = NO; //控制单选
        self.searchDisplayController1.searchResultsTableView.allowsMultipleSelection = NO;

    }
    else
    {
        self.tableView.allowsMultipleSelection = YES; //控制多选
        self.searchDisplayController1.searchResultsTableView.allowsMultipleSelection = YES;
    }
    self.bSearchDisplay = NO;
    
    [self judgeJoinedEnterprise];
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDSelectPersonTableViewCell" bundle:nil];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDSelectPersonTableViewCell"];
    [self.searchDisplayController1.searchResultsTableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDSelectPersonTableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self                      action:@selector(clickedDone:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
    
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)judgeJoinedEnterprise
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString* enterpriseName = [userDefaultes stringForKey:DEFAULTS_USERENTERPRISE];
    NSString* enterpriseId = [userDefaultes stringForKey:DEFAULTS_USERENTERPRISE_ID];

    _bJoinedEnterprise = YES;
    if (enterpriseId == nil || [enterpriseId length] <= 0
        || [enterpriseId isEqual:[NSNull null]])
    {
        _bJoinedEnterprise = NO;
    }
    
    
}

//clicked done
-(void) clickedDone:(id) sender
{
    NSArray *indexPaths = nil;

    if (self.bSearchDisplay)
    {
        indexPaths = [self.searchDisplayController1.searchResultsTableView indexPathsForSelectedRows];
    }
    else
    {
        indexPaths = [self.tableView indexPathsForSelectedRows];
    }

//    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if (!indexPaths||indexPaths.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择联系人!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:enterAction];
        [self showDetailViewController:alertController sender:self];
        return;
    }
    
    //get seleted users
    NSMutableArray *seletedUsers = [NSMutableArray new];
    for (NSIndexPath *indexPath in indexPaths) {
        //        NSString *key = [self.allKeys objectAtIndex:indexPath.section];
        //        NSArray *arrayForKey = [self.allFriends objectForKey:key];
        ESContactList* contactList = self.friends[indexPath.section];
        
        ESUserInfo *user = contactList.contactList[indexPath.row];
        
        //转成RCDUserInfo
        ESUserInfo *userInfo = [ESUserInfo new];
        userInfo.userId = user.userId;
        userInfo.userName = user.userName;
        userInfo.portraitUri = user.portraitUri;
        [seletedUsers addObject:userInfo];
    }
    
    //excute the clickDoneCompletion
    if (self.clickDoneCompletion) {
        self.clickDoneCompletion(self,seletedUsers);
    }
    
}


#pragma mark -UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
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
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    return [self.friends count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
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
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        ESUserInfo *user = self.searchResult[indexPath.row];
        
        if(user){
            cell.lblName.text = user.userName;
            [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
        }
        
        
        //设置选中状态
        for (ESUserInfo *userInfo in self.seletedUsers) {
            if ([user.userId isEqualToString:userInfo.userId]) {
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                if (_type == e_Selected_Check_Box_UnDeselect)
                {
                    [cell setUserInteractionEnabled:NO];
                }
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
        for (ESUserInfo *userInfo in self.seletedUsers) {
            if ([user.userId isEqualToString:userInfo.userId]) {
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                if (_type == e_Selected_Check_Box_UnDeselect)
                {
                    [cell setUserInteractionEnabled:NO];
                }
            }
        }
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDSelectPersonTableViewCell *cell = (RCDSelectPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
//    if (_selectedCell!=nil)
//    {
//        [_selectedCell setSelected:NO];
//    }
//    _selectedCell = cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDSelectPersonTableViewCell *cell = (RCDSelectPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}


#pragma mark - GetContactListDelegate
-(void)getContactList:(NSArray*)contactList
{
    self.friends = [NSMutableArray arrayWithArray:contactList];
    if(!_bJoinedEnterprise)
    {
        NSMutableArray* userInfoArray = [NSMutableArray array];
        ESContactList* contactList = [[ESContactList alloc]init];
        contactList.enterpriseName = @"我";
        contactList.contactList = userInfoArray;
        ESUserInfo* userInfo = [[ESUserInfo alloc] init];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString* userId = [userDefaultes stringForKey:DEFAULTS_USERID];
        if (userId != nil && ![userId isEqual:[NSNull null]])
        {
            userInfo.userId = [NSString stringWithFormat:@"%d",[userId intValue]];
        }
        
        NSString* userName = [userDefaultes stringForKey:DEFAULTS_USERNAME];
        if (userName != nil && ![userName isEqual:[NSNull null]])
        {
            userInfo.userName = userName;
        }
        NSString* userPhoneNum = [userDefaultes stringForKey:DEFAULTS_USERPHONENUMBER];
        if (userPhoneNum != nil && ![userPhoneNum isEqual:[NSNull null]])
        {
            userInfo.phoneNumber = userPhoneNum;
        }
        
        ESEnterpriseInfo* enterpriseInfo = [[ESEnterpriseInfo alloc] init];
        enterpriseInfo.enterpriseName = @"我";
        userInfo.enterprise = enterpriseInfo;
        
        NSString* userPortraitUri = [userDefaultes stringForKey:DEFAULTS_ENTERPRISEAVATAR];
        if (userPortraitUri != nil && ![userPortraitUri isEqual:[NSNull null]])
        {
            userInfo.portraitUri = userPortraitUri;
        }
        
        //        userInfo.type = @"contact";
        
        [userInfoArray addObject:userInfo];
        
        [self.friends insertObject:contactList atIndex:0];
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
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.bSearchDisplay = YES;
    //    NSLog(@"searchBarShouldBeginEditing");
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
