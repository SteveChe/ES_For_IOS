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

@interface RCDPhoneAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) UISearchDisplayController* searchDisplayController1;
@property (nonatomic,strong) NSMutableArray* phoneNumberList;
@property (nonatomic,strong) NSMutableDictionary* addBookDic;
@property (nonatomic,strong) GetPhoneContactListDataParse* getPhoneContactListDataParse;
@property (nonatomic,strong) NSMutableArray* phoneNumberContacts;

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

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    RCDPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    ESUserInfo *user = _phoneNumberContacts[indexPath.row];
    
    if(user)
    {
        cell.esName.text = user.userName;
        NSString* phoneName = [_addBookDic valueForKey:user.phoneNumber];
        if (phoneName != nil && [phoneName length] > 0 )
        {
            cell.phoneName.text = phoneName;
        }
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"icon"]];
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
    
}

#pragma mark --RCDPhoneAddressBookTableViewCellDelegate

-(void)addButtonClick:(id)sender
{
    RCDPhoneAddressBookTableViewCell* cell = (RCDPhoneAddressBookTableViewCell*) sender;
    [cell.addButton setBackgroundImage:[UIImage imageNamed:@"ren_tianjia_chenggong"] forState:UIControlStateNormal];
}

@end
