//
//  RCDPhoneAddressBookViewController.m
//  MyRill
//
//  Created by Steve on 15/7/8.
//
//
#import <AddressBook/AddressBook.h>
#import "RCDPhoneAddressBookViewController.h"
#import "GetPhoneContactListDataParse.h"
#import "CustomShowMessage.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"
#import "RCDAddressBookDetailViewController.h"

@interface RCDPhoneAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) UISearchDisplayController* searchDisplayController1;
@property (nonatomic,strong) NSMutableArray* phoneNumberList;
@property (nonatomic,strong) NSMutableDictionary* addBookDic;
@property (nonatomic,strong) GetPhoneContactListDataParse* getPhoneContactListDataParse;
@property (nonatomic,strong) NSMutableArray* phoneNumberContacts;
@property (nonatomic,strong) NSMutableArray* searchResult;
@property (strong,nonatomic) AddContactDataParse* addContactDataParse;

@end

@implementation RCDPhoneAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _getPhoneContactListDataParse = [[GetPhoneContactListDataParse alloc] init];
    _getPhoneContactListDataParse.delegate = self;
    _phoneNumberList = [[NSMutableArray alloc] init];
    _phoneNumberContacts = [[NSMutableArray alloc] init];
    _addBookDic = [NSMutableDictionary dictionary];
    _addContactDataParse = [[AddContactDataParse alloc] init];
    _addContactDataParse.delegate = self;
    
    [self initPhoneContactList];
    
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDPhoneAddressBookTableViewCell" bundle:nil];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDPhoneAddressBookTableViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
}

//
-(void)initPhoneContactList
{
    [self readAllPeoples];
    if ([self.phoneNumberList count] > 0)
    {
        [_getPhoneContactListDataParse getPhoneContactList:self.phoneNumberList];
    }
    
}

//读取所有联系人
-(void)readAllPeoples

{
    [_phoneNumberList removeAllObjects];
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    CFErrorRef error = nil;
    tmpAddressBook=ABAddressBookCreateWithOptions(NULL, &error);

    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    //取得本地所有联系人记录
    
    
    if (tmpAddressBook==nil) {
        return ;
    };
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);

    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(results),
                                                               results
                                                               );
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering()
                      );
    for(int i = 0; i < CFArrayGetCount(peopleMutable); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(peopleMutable, i);
        
        //读取firstname
        NSString *firsterName = nil;
        firsterName = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        
        //读取lastname
        NSString *lastName = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *personName = @"";
        if (lastName) {
            personName = [personName stringByAppendingString:lastName];
        }
        if (firsterName) {
            personName = [personName stringByAppendingString:firsterName];
        }
        if (personName == nil || [personName isEqualToString:@""]) {
            continue;
        }
        
//        NSLog(@"personName = %@",personName);
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSInteger phoneCount = ABMultiValueGetCount(phone);
        if (phoneCount > 0) {
            
            for (int k = 0; k<phoneCount; k++)
            {
                NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
                personPhone = [personPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *pureNumbers = [[personPhone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
                
                if (pureNumbers.length >= 11)
                {
                    NSString *phoneNumber = [pureNumbers substringFromIndex:pureNumbers.length-11];
                    [_phoneNumberList addObject:phoneNumber];
                    [_addBookDic setObject:personName forKey:phoneNumber];
                }
            }
        
            CFRelease(phone);
        }
    }
    CFRelease(peopleMutable);
    CFRelease(results);
    CFRelease(tmpAddressBook);
    
}


#pragma mark --GetPhoneContactListDelegate
-(void)getPhoneContactList:(NSArray*)contactList;
{
    [_phoneNumberContacts removeAllObjects];
    [_phoneNumberContacts addObjectsFromArray:contactList];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
}
-(void)getPhoneContactListFailed:(NSString*)errorMessage;
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_searchResult count];
    }
    
    return [_phoneNumberContacts count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"手机联系人";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"RCDPhoneAddressBookTableViewCell";
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDPhoneAddressBookTableViewCell" bundle:nil];
    [tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDPhoneAddressBookTableViewCell"];
    

    RCDPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    ESUserInfo *user = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        user = _searchResult[indexPath.row];
        cell.tag = 0;

    }
    else
    {
        user = _phoneNumberContacts[indexPath.row];
        cell.tag = 1;

    }
    if(user)
    {
        cell.title.text = @"联系人";
        cell.subtitle.text = user.userName;
        
        NSString* phoneName = [_addBookDic valueForKey:user.phoneNumber];
        if (phoneName != nil && [phoneName length] > 0 )
        {
            cell.title.text = phoneName;
        }
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"icon"]];
        if([user.type isEqualToString:@"contact"])
        {
            [cell.addButton setBackgroundImage:[UIImage imageNamed:@"ren_tianjia_chenggong"] forState:UIControlStateNormal];
        }
        cell.addButton.tag = indexPath.row;
        cell.delegate = self;
    }

    return cell;
}

#pragma mark --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDAddressBookDetailViewController * addressBookDetailVC = [[RCDAddressBookDetailViewController alloc] init];
    ESUserInfo *user = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        user = _searchResult[indexPath.row];
        addressBookDetailVC.userInfo = user;
    }
    else
    {
        user = _phoneNumberContacts[indexPath.row];
    }
    addressBookDetailVC.userInfo = user;

    [self.navigationController pushViewController:addressBookDetailVC animated:YES];

}

#pragma mark --RCDPhoneAddressBookTableViewCellDelegate
-(void)addButtonClick:(id)sender
{
    RCDPhoneAddressBookTableViewCell* cell = (RCDPhoneAddressBookTableViewCell*) sender;
    NSInteger rowIndex = cell.addButton.tag;
    ESUserInfo* userInfo = nil;

    if(0 == cell.tag)
    {
        userInfo = [_searchResult objectAtIndex:rowIndex];
    }
    else if(1 ==cell.tag)
    {
        userInfo = [_phoneNumberContacts objectAtIndex:rowIndex];
    }
    if (userInfo != nil)
    {
        [_addContactDataParse addContact:userInfo.userId];
    }
//    [cell.addButton setBackgroundImage:[UIImage imageNamed:@"ren_tianjia_chenggong"] forState:UIControlStateNormal];
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
        for (ESUserInfo* user in _phoneNumberContacts )
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
                NSString* strAddressBookName = [_addBookDic objectForKey:user.phoneNumber];
                NSRange range3 = [strAddressBookName rangeOfString:searchText];
                if (range3.length > 0)
                {
                    [_searchResult addObject:user];
                    continue;
                }
            }
            
        }
    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    
}

#pragma mark- AddContactDelegate
-(void)addContactSucceed
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"已经发送"];
    [self performSelector:@selector( returnToLastView)
               withObject:nil
               afterDelay:1];
    return;
    
}
-(void)returnToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addContactFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}


@end
