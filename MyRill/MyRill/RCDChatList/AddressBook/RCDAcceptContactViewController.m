//
//  RCDAcceptContactViewController.m
//  MyRill
//
//  Created by Steve on 15/7/6.
//
//

#import "RCDAcceptContactViewController.h"
#import "CustomShowMessage.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"
#import "RCDAddressBookDetailViewController.h"

@interface RCDAcceptContactViewController ()
@property (nonatomic,strong)GetRequestContactListDataParse* getRequestContactListDataParse;
@property (nonatomic,strong)AddContactDataParse* addContactDataParse;
@property (nonatomic,strong)NSMutableArray* requestContactList;
@property (nonatomic,strong)ESUserInfo* acceptingUser;

@end

@implementation RCDAcceptContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的联系人";
    _getRequestContactListDataParse = [[GetRequestContactListDataParse alloc] init];
    _getRequestContactListDataParse.delegate = self;
    _addContactDataParse = [[AddContactDataParse alloc] init];
    _addContactDataParse.delegate = self;
    
    _requestContactList = [[NSMutableArray alloc] init];
    [self getRequestContactList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDPhoneAddressBookTableViewCell" bundle:nil];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDPhoneAddressBookTableViewCell"];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)getRequestContactList
{
    [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
    [_getRequestContactListDataParse getRequestedContactList];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_requestContactList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDPhoneAddressBookTableViewCell" ];
    ESUserInfo* userInfo = [_requestContactList objectAtIndex:indexPath.row];
    if (userInfo != nil)
    {
        cell.title.text = userInfo.userName;
        cell.subtitle.text = [NSString stringWithFormat:@"请求您添加为联系人"];;
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
        if([userInfo.type isEqualToString:@"contact"])
        {
            [cell.addButton setBackgroundImage:[UIImage imageNamed:@"ren_tianjia_chenggong"] forState:UIControlStateNormal];
        }
        [cell setTag:indexPath.row];
        cell.delegate = self;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESUserInfo* userInfo = [_requestContactList objectAtIndex:indexPath.row];
    RCDAddressBookDetailViewController* addressDetailVC = [[RCDAddressBookDetailViewController alloc] init];
    if (userInfo == nil || userInfo.userId == nil) {
        return;
    }
    addressDetailVC.userId = userInfo.userId;
    [self.navigationController pushViewController:addressDetailVC animated:YES];
}
#pragma mark GetRequestContactListDelegate
-(void)getRequestedContactList:(NSArray*)contactList
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];

    [_requestContactList removeAllObjects];
    [_requestContactList addObjectsFromArray:contactList];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}
-(void)getRequestedContactListFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark AddContactDelegate
-(void)acceptContactSucceed
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:@"接受好友成功"];
    _acceptingUser.type = @"contact";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });//    [_requestingCell.addButton setBackgroundImage:[UIImage imageNamed:@"ren_tianjia_chenggong"] forState:UIControlStateNormal];
}

-(void)acceptContactFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark-- RCDPhoneAddressBookTableViewCellDelegate
-(void)addButtonClick:(id)sender
{
    RCDPhoneAddressBookTableViewCell* cell = (RCDPhoneAddressBookTableViewCell*) sender;
    NSInteger rowIndex = cell.tag;
    if (rowIndex < [_requestContactList count])
    {
        ESUserInfo* userInfo = [_requestContactList objectAtIndex:rowIndex];
        if (userInfo.userId != nil && ![userInfo.userId isEqual:[NSNull null]] && [userInfo.userId length] > 0 )
        {
            [_addContactDataParse acceptContact:userInfo.userId];
            _acceptingUser = userInfo;
        }
    }
    [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
}

@end
