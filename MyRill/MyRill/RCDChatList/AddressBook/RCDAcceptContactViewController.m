//
//  RCDAcceptContactViewController.m
//  MyRill
//
//  Created by Steve on 15/7/6.
//
//

#import "RCDAcceptContactViewController.h"
//#import "RCDAcceptContactTableViewCell.h"
#import "CustomShowMessage.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"

@interface RCDAcceptContactViewController ()
@property (nonatomic,weak)IBOutlet UIImageView* portraitImage;
@property (nonatomic,weak)IBOutlet UIButton* acceptButton;
@property (nonatomic,weak)IBOutlet UILabel* nameLabel;
@property (nonatomic,weak)IBOutlet UILabel* scriptLabel;
@property (nonatomic,strong)IBOutlet UITableViewCell* acceptCell;

@property (nonatomic,strong)GetRequestContactListDataParse* getRequestContactListDataParse;
@property (nonatomic,strong)AddContactDataParse* addContactDataParse;
@property (nonatomic,strong)NSMutableArray* requestContactList;
-(IBAction)acceptButtonClicked:(id)sender;

@end

@implementation RCDAcceptContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd                    target:self action:@selector(rightBtnOnClicked:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
}

-(void)getRequestContactList
{
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDAcceptContactTableViewCell" ];
    if(!cell)
    {
//        cell = [[RCDAcceptContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCDAcceptContactTableViewCell"];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RCDAcceptContactTableViewCell" owner:self options:nil];
        if ([nib count]>0)
        {
            _acceptCell = [nib objectAtIndex:0];
            cell = _acceptCell;
        }
        else
        {
            return nil;
        }

    }
    ESUserInfo* userInfo = [_requestContactList objectAtIndex:indexPath.row];
    _nameLabel.text = userInfo.userName;
    _scriptLabel.text = [NSString stringWithFormat:@"我是%@，想加你为联系人",userInfo.userName];
    _acceptButton.tag = indexPath.row;
    [_portraitImage sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    return cell;
}

#pragma mark GetRequestContactListDelegate
-(void)getRequestedContactList:(NSArray*)contactList
{
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
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark AddContactDelegate
-(void)acceptContactSucceed
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"接受好友成功"];
}

-(void)acceptContactFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark event - clicked
-(void) rightBtnOnClicked:(id)sender
{
    
}

-(IBAction)acceptButtonClicked:(id)sender
{
    UIButton* button = (UIButton*)sender;
    ESUserInfo* userInfo = [_requestContactList objectAtIndex:button.tag];
    [_addContactDataParse acceptContact:userInfo.userId];
}


@end
