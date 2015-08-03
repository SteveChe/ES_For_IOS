//
//  RCDApprovedJoinEnterpriseViewController.m
//  MyRill
//
//  Created by Steve on 15/8/2.
//
//

#import "RCDApprovedJoinEnterpriseViewController.h"
#import "CustomShowMessage.h"
#import "UIImageView+WebCache.h"
#import "ESEnterPriseRequestInfo.h"
#import "ESUserInfo.h"

@interface RCDApprovedJoinEnterpriseViewController ()
@property (nonatomic,strong)EnterPriseRequestDataParse* enterpriseRequestDataParse;
@property (nonatomic,strong)NSMutableArray* enterpriseRequestInfoList;
@property (nonatomic,strong)ESEnterPriseRequestInfo* requestIngEnterPriseRequestInfo;

@end

@implementation RCDApprovedJoinEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请求加入企业的联系人";
    _enterpriseRequestDataParse = [[EnterPriseRequestDataParse alloc] init];
    _enterpriseRequestDataParse.getEnterPriseRequestListDelegate = self;
    _enterpriseRequestDataParse.approvedEnterPriseRequestDelegate = self;
    
    _enterpriseRequestInfoList = [[NSMutableArray alloc] init];
    [self getEnterpriseRequestList];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDPhoneAddressBookTableViewCell" bundle:nil];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDPhoneAddressBookTableViewCell"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getEnterpriseRequestList
{
    [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
    [_enterpriseRequestDataParse getEnterPriseRequestList];
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
    return [_enterpriseRequestInfoList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDPhoneAddressBookTableViewCell" ];
    ESEnterPriseRequestInfo* enterpriseRequestInfo = [_enterpriseRequestInfoList objectAtIndex:indexPath.row];
    if (enterpriseRequestInfo != nil && enterpriseRequestInfo.sender != nil)
    {
        cell.title.text = enterpriseRequestInfo.sender.userName;
        cell.subtitle.text = [NSString stringWithFormat:@"请求加入你的企业"];;
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:enterpriseRequestInfo.sender.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
        if(enterpriseRequestInfo.bApproved)
        {
            [cell.addButton setBackgroundImage:[UIImage imageNamed:@"ren_tianjia_chenggong"] forState:UIControlStateNormal];
        }
        [cell setTag:indexPath.row];
        cell.delegate = self;
        
    }
    
    return cell;
}



#pragma mark -- GetEnterPriseRequestListDelegate
-(void)getEnterPriseRequestListSucceed:(NSArray*)requestList
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    
    [_enterpriseRequestInfoList removeAllObjects];
    [_enterpriseRequestInfoList addObjectsFromArray:requestList];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
-(void)getEnterPriseRequestListFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark -- ApprovedEnterPriseRequestDelegate
-(void)approvedEnterPriseRequestSucceed
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:@"同意对方加入企业"];
    _requestIngEnterPriseRequestInfo.bApproved = YES;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
-(void)approvedEnterPriseRequestFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
    
}

#pragma mark-- RCDPhoneAddressBookTableViewCellDelegate
-(void)addButtonClick:(id)sender
{
    RCDPhoneAddressBookTableViewCell* cell = (RCDPhoneAddressBookTableViewCell*) sender;
    NSInteger rowIndex = cell.tag;
    if (rowIndex < [_enterpriseRequestInfoList count])
    {
        ESEnterPriseRequestInfo* enterpriseRequestInfo = [_enterpriseRequestInfoList objectAtIndex:rowIndex];
        if(enterpriseRequestInfo == nil || enterpriseRequestInfo.requestId == nil || [enterpriseRequestInfo.requestId isEqual:[NSNull null]])
            return;
        [_enterpriseRequestDataParse approvedEnterPriseRequest:enterpriseRequestInfo.requestId bApproved:YES];
        _requestIngEnterPriseRequestInfo = enterpriseRequestInfo;
    }
    [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
}


@end
