//
//  RCDPhoneAddressBookViewController.m
//  MyRill
//
//  Created by Steve on 15/7/8.
//
//
#import <AddressBook/AddressBook.h>
#import "RCDPhoneAddressBookViewController.h"

@interface RCDPhoneAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchDisplayController* searchDisplayController1;

@end

@implementation RCDPhoneAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

//读取所有联系人
-(void)readAllPeoples

{
    
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
        
        NSLog(@"personName = %@",personName);
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
                }
            }
        
            CFRelease(phone);
        }
    }
    CFRelease(peopleMutable);
    CFRelease(results);
    CFRelease(tmpAddressBook);

}

@end
