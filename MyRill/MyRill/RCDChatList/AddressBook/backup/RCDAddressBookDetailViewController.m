//
//  RCDAddressBookDetailViewController.m
//  MyRill
//
//  Created by Steve on 15/7/14.
//
//

#import "RCDAddressBookDetailViewController.h"
#import "ESUserInfo.h"
#import "ESUserDetailInfo.h"
#import "CustomShowMessage.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"

@interface RCDAddressBookDetailViewController ()
@property (nonatomic,strong) GetContactDetailDataParse* getContactDetailDataParse;

@property (nonatomic,strong) IBOutlet UIImageView* portraitImageView;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic,strong) IBOutlet UILabel* phoneNumberLabel;
@property (nonatomic,strong) IBOutlet UILabel* descriptionDetailLabel;
@property (nonatomic,strong) IBOutlet UIImageView* qrCodeImageView;
@property (nonatomic,strong) IBOutlet UIImageView* enterpriseQRImageView;
@property (nonatomic,strong) ESUserDetailInfo* userDetailInfo;
@property (nonatomic,weak) IBOutlet UIButton* smsButton;
@property (nonatomic,weak) IBOutlet UIButton*callButton;
@property (nonatomic,weak) IBOutlet UIButton* deleteButton;

-(IBAction)clickStartChatButton:(id)sender;
-(IBAction)clickCallButton:(id)sender;
-(IBAction)clickDeleteButton:(id)sender;

@end

@implementation RCDAddressBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _getContactDetailDataParse = [[GetContactDetailDataParse alloc] init];
    _getContactDetailDataParse.delegate = self;
    [self initContactDetail];
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

-(void)initContactDetail
{
    if (_userId != nil && _userId != nil && [_userId length] > 0)
    {
        [_getContactDetailDataParse getContactDetail:_userId];
    }
}

#pragma mark - ContactDetailDataDelegate
- (void)getContactDetail:(ESUserDetailInfo *)userDetailInfo
{
    _userDetailInfo = userDetailInfo;
    if (userDetailInfo.userName != nil && ![userDetailInfo.userName isEqual:[NSNull null]] && [userDetailInfo.userName length] > 0)
    {
        _titleLabel.text = userDetailInfo.userName;
    }
    if (userDetailInfo.phoneNumber != nil && ![userDetailInfo.phoneNumber isEqual:[NSNull null]] && [userDetailInfo.phoneNumber length] > 0)
    {
        _phoneNumberLabel.text = [NSString stringWithFormat:@"电话:%@",userDetailInfo.phoneNumber];
    }
    if (userDetailInfo.contactDescription != nil && ![userDetailInfo.contactDescription isEqual:[NSNull null]] && [userDetailInfo.contactDescription length] > 0)
    {
        _descriptionDetailLabel.text = userDetailInfo.contactDescription;
    }
    _portraitImageView.clipsToBounds = YES;
    _portraitImageView.layer.cornerRadius = 18.f;

    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:userDetailInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:userDetailInfo.qrcode] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    [_enterpriseQRImageView sd_setImageWithURL:[NSURL URLWithString:userDetailInfo.enterprise_qrcode] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    
}
- (void)getContactDetailFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}



#pragma mark - Button Event
-(IBAction)clickStartChatButton:(id)sender
{
//    NSURL* smsURL = [NSURL URLWithString:[NSString stringWithFormat:@"SMS://%@",_userDetailInfo.phoneNumber]];
//    [[UIApplication sharedApplication]openURL:smsURL];
    if(_userDetailInfo == nil || _userDetailInfo.userId == nil ||
       [_userDetailInfo.userId length]<= 0)
        return;
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    chatViewController.targetId = _userDetailInfo.userId;
    chatViewController.title = _userDetailInfo.userName;
    
    //跳转到会话页面
    [self.navigationController pushViewController:chatViewController animated:YES];

}
-(IBAction)clickCallButton:(id)sender
{
    NSURL* phoneCallURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_userDetailInfo.phoneNumber]];

    [[UIApplication sharedApplication] openURL:phoneCallURL];
    
}
-(IBAction)clickDeleteButton:(id)sender
{
    
}

#pragma mark -- setter&getter
- (void)setSmsButton:(UIButton *)smsButton
{
    _smsButton = smsButton;
    _smsButton.layer.cornerRadius = 20.0f;
}
-(void)setCallButton:(UIButton *)callButton
{
    _callButton = callButton;
    _callButton.layer.cornerRadius = 20.0f;
}
-(void)setDeleteButton:(UIButton *)deleteButton
{
    _deleteButton = deleteButton;
    _deleteButton.layer.cornerRadius = 20.0f;
}

@end
