//
//  RCDAddressBookEnterpriseDetailViewController.m
//  MyRill
//
//  Created by Steve on 15/8/10.
//
//

#import "RCDAddressBookEnterpriseDetailViewController.h"
#import "ESEnterpriseDetailInfo.h"
#import "RCDAddressBookDetailTableViewCell.h"
#import "ESTagViewController.h"
#import "ShowQRCodeViewController.h"
#import "CustomShowMessage.h"
#import "UIImageView+WebCache.h"
#import "RootViewController.h"
#import "FollowEnterpriseDataParse.h"
#import "CustomShowMessage.h"


@interface RCDAddressBookEnterpriseDetailViewController ()<FollowEnterpriseDelegate,UnFollowEnterpriseDelegate>

@property(nonatomic,strong)GetEnterpriseDetailDataParse* getEnterpriseDetailDataParse;
@property (nonatomic,strong) ESEnterpriseDetailInfo* enterpriseDetailInfo;
@property (nonatomic,strong) FollowEnterpriseDataParse* followEnterpriseDataParse;

@property (nonatomic,strong) IBOutlet UITableView* tableView;
@property (nonatomic,strong) IBOutlet UIImageView* portraitImageView;
@property (nonatomic,strong) IBOutlet UILabel* enterpriseName;
@property (nonatomic,strong) IBOutlet UILabel* enterpriseDes;
@property (nonatomic,weak) IBOutlet UIButton* smsButton;
@property (nonatomic,weak) IBOutlet UIButton* deleteButton;
@property (nonatomic,weak) IBOutlet UIView* tableHeaderView;

-(IBAction)clickStartChatButton:(id)sender;
-(IBAction)clickDeleteButton:(id)sender;
-(void)initEnterpriseDetail;

@end

@implementation RCDAddressBookEnterpriseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"企业详情";
    
    _getEnterpriseDetailDataParse = [[GetEnterpriseDetailDataParse alloc] init];
    _getEnterpriseDetailDataParse.delegate = self;
    
    _followEnterpriseDataParse = [[FollowEnterpriseDataParse alloc] init];
    _followEnterpriseDataParse.followEnterPriseDelegate = self;
    _followEnterpriseDataParse.unfollowEnterPriseDelegate = self;
    
    [self initEnterpriseDetail];
    
    UINib *rcdCellNib = [UINib nibWithNibName:@"RCDAddressBookDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:rcdCellNib forCellReuseIdentifier:@"RCDAddressBookDetailTableViewCell"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initEnterpriseDetail
{
    if (_enterpriseId != nil && _enterpriseId != nil && [_enterpriseId length] > 0)
    {
        [_getEnterpriseDetailDataParse getEnterpriseDetailInfo:_enterpriseId];
        [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
    }
    self.tableView.hidden = YES;
}


-(void)refreshEnterpriseDetailButton
{
    if (_enterpriseDetailInfo == nil)
    {
        return;
    }
    if (_enterpriseDetailInfo.bFollowed )
    {
        _smsButton.titleLabel.text = @"进入企业号";
        _deleteButton.hidden = NO;
        [_smsButton removeTarget:self action:@selector(followEnterpriseButton:)  forControlEvents:UIControlEventTouchUpInside];
        [_smsButton addTarget:self action:@selector(clickStartChatButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    else
    {
        _smsButton.titleLabel.text = @"关注企业";
        _deleteButton.hidden = YES;
        [_smsButton removeTarget:self action:@selector(clickStartChatButton:)  forControlEvents:UIControlEventTouchUpInside];
        [_smsButton addTarget:self action:@selector(followEnterpriseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -- EnterpriseDetailInfoDataDelegate
- (void)getEnterpriseDetailSucceed:(ESEnterpriseDetailInfo *)enterpriseDetailInfo
{
    self.tableView.hidden = NO;

    _enterpriseDetailInfo = enterpriseDetailInfo;
    if (enterpriseDetailInfo.enterpriseName != nil && ![enterpriseDetailInfo.enterpriseName isEqual:[NSNull null]] && [enterpriseDetailInfo.enterpriseName length] > 0)
    {
        _enterpriseName.text = enterpriseDetailInfo.enterpriseName;
    }
    if (enterpriseDetailInfo.enterpriseDescription  != nil && ![enterpriseDetailInfo.enterpriseDescription isEqual:[NSNull null]] && [enterpriseDetailInfo.enterpriseDescription length] > 0)
    {
        _enterpriseDes.text = [NSString stringWithFormat:@"企业简介:%@",enterpriseDetailInfo.enterpriseDescription];
    }
    _portraitImageView.clipsToBounds = YES;
    _portraitImageView.layer.cornerRadius = 18.f;
    
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:enterpriseDetailInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    
//    CGRect rect = _tableHeaderView.frame;
//    rect.size.height = [_tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    _tableHeaderView.frame = rect;
//    self.tableView.tableHeaderView = _tableHeaderView;
    
    [self refreshEnterpriseDetailButton];
    [self.tableView reloadData];
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    
    
}
- (void)getEnterpriseDetailFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
    [[CustomShowMessage getInstance] hideWaitingIndicator];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_enterpriseDetailInfo == nil)
        return 0;
    
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_enterpriseDetailInfo == nil)
        return 0;
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(_enterpriseDetailInfo == nil)
        return nil;
    
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_enterpriseDetailInfo == nil)
        return nil;
    static NSString *cellReuseIdentifier = @"RCDAddressBookDetailTableViewCell";
    RCDAddressBookDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    if(indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.qrCodeImage.hidden = YES;
        cell.titleLabel.text = @"标签选择";
        
    }
    else if (indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = @"企业二维码";
        cell.qrCodeImage.hidden = NO;
        [cell.qrCodeImage setImage:[UIImage imageNamed:@"二维码"]];
    }
    
    return cell;
}

#pragma mark --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        ESTagViewController* tagViewVC = [[ESTagViewController alloc] init];
        tagViewVC.enterpriseId = _enterpriseDetailInfo.enterpriseId;
        tagViewVC.tagType = TAG_TYPE_ENTERPRISE;
        [self.navigationController pushViewController:tagViewVC animated:YES];
    }
    else if (indexPath.section == 1)
    {
        ShowQRCodeViewController* showQRCodeVC = [[ShowQRCodeViewController alloc] init];
        showQRCodeVC.qrCodeTitle = @"企业二维码";
        showQRCodeVC.imageUrl = _enterpriseDetailInfo.enterpriseQRCode;
        [self.navigationController pushViewController:showQRCodeVC animated:YES];
    }
    
}

#pragma mark - FollowEnterpriseDelegate
-(void)followEnterpriseSucceed
{
//    [self refreshEnterpriseDetailButton];
    [self initEnterpriseDetail];
    [[CustomShowMessage getInstance] showNotificationMessage:@"关注企业成功！"];
    [[CustomShowMessage getInstance] hideWaitingIndicator];

}

-(void)followEnterpriseFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
    [[CustomShowMessage getInstance] hideWaitingIndicator];
}

#pragma mark - UnFollowEnterpriseDelegate
-(void)unFollowEnterpriseSucceed
{
//    [self refreshEnterpriseDetailButton];
//    [self initEnterpriseDetail];
    [[CustomShowMessage getInstance] showNotificationMessage:@"取消关注企业成功！"];
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)unFollowEnterpriseFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
    [[CustomShowMessage getInstance] hideWaitingIndicator];
}


#pragma mark - event 
-(IBAction)clickStartChatButton:(id)sender
{
    if (_enterpriseDetailInfo==nil)
        return;

    RootViewController* enterpriseChatVC = [[RootViewController alloc] init];
    enterpriseChatVC.title = @"企业消息";
    enterpriseChatVC.title = _enterpriseDetailInfo.enterpriseName;
    enterpriseChatVC.enterpriseId = _enterpriseDetailInfo.enterpriseId;
    
    enterpriseChatVC.chatType = e_Enterprise_Chat_Enterprise;
    [self.navigationController pushViewController:enterpriseChatVC animated:YES];
}

-(IBAction)followEnterpriseButton:(id)sender
{
    if(_enterpriseDetailInfo == nil)
        return;
    [_followEnterpriseDataParse followEnterPriseWithEnterpriseId:_enterpriseDetailInfo.enterpriseId];
    [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];

}

-(IBAction)clickDeleteButton:(id)sender
{
    if(_enterpriseDetailInfo == nil)
        return;
    
    [_followEnterpriseDataParse unfollowEnterPriseWithEnterpriseId:_enterpriseDetailInfo.enterpriseId];
    [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];

}

#pragma mark -- setter&getter
- (void)setSmsButton:(UIButton *)smsButton
{
    _smsButton = smsButton;
    _smsButton.layer.cornerRadius = 20.0f;
}
-(void)setDeleteButton:(UIButton *)deleteButton
{
    _deleteButton = deleteButton;
    _deleteButton.layer.cornerRadius = 20.0f;
}


@end
