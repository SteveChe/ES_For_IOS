//
//  LoginViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/7.
//
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "Masonry.h"
#import "ColorHandler.h"
#import "AppDelegate.h"
#import "CustomShowMessage.h"
#import "ESMenuViewController.h"
#import "ResetPwdViewController.h"
#import "ESUserDetailInfo.h"
#import "MRProgress.h"
#import "UserDefaultsDefine.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UIView *textFieldHoldView;
@property (nonatomic, strong) IBOutlet UITextField *userNameTxtField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTxtField;
@property (nonatomic, weak) IBOutlet UIButton *resetPswBtn;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) IBOutlet UIButton *signUpBtn;
@property (nonatomic, strong) LoginDataParse* loginDataParse;
@property (nonatomic, strong) MRProgressOverlayView *progress;
@end

@implementation LoginViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"My Rill";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    _loginDataParse = [[LoginDataParse alloc] init];
    _loginDataParse.delegate = self;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefault stringForKey:DEFAULTS_USERNAME];
    if (![ColorHandler isNullOrEmptyString:userName]) {
        self.userNameTxtField.text = userName;
    }
}

#pragma mark - LoginDataDelegate
- (void)loginSucceed:(ESUserDetailInfo *)userDetailInfo
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"登录成功"];
    [_loginDataParse getRongCloudToken];
    [self performSelector:@selector(changeToESMenuView)
               withObject:nil
               afterDelay:.5];
    
    //将登陆成功地返回信息存到本地，用于个人界面的各类信息展示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.userId]?@"":userDetailInfo.userId
                     forKey:DEFAULTS_USERID];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.userName]?@"":userDetailInfo.userName
                     forKey:DEFAULTS_USERNAME];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.phoneNumber]?@"":userDetailInfo.phoneNumber
                     forKey:DEFAULTS_USERPHONENUMBER];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.department]?@"":userDetailInfo.department
                     forKey:DEFAULTS_USERDEPARTMENT];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.portraitUri]?@"":userDetailInfo.portraitUri
                     forKey:DEFAULTS_USERAVATAR];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.contactDescription]?@"":userDetailInfo.contactDescription
                     forKey:DEFAULTS_USERDESCRIPTION];
    
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.qrcode]?@"":userDetailInfo.qrcode
                     forKey:DEFAULTS_USERQRCODE];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.enterprise_qrcode]?@"":userDetailInfo.enterprise_qrcode
                     forKey:DEFAULTS_ENTERPRISEQRCODE];
    
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.enterprise.enterpriseName]?@"":userDetailInfo.enterprise.enterpriseName
                     forKey:DEFAULTS_USERENTERPRISE];

    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.enterprise.enterpriseName]?@"":userDetailInfo.enterprise.enterpriseId
                     forKey:DEFAULTS_USERENTERPRISE_ID];

    [userDefaults setObject:[ColorHandler isNullOrEmptyString:userDetailInfo.enterprise.portraitUri]?@"":userDetailInfo.enterprise.portraitUri
                     forKey:DEFAULTS_ENTERPRISEAVATAR];
    
    [userDefaults synchronize];
}
-(void)changeToESMenuView
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    ESMenuViewController *esVC = [[ESMenuViewController alloc] init];
    [appDelegate changeWindow:esVC];
}
-(void)loginFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

-(void)rongCloudToken:(NSString*)rongCloudToken
{
    [[NSUserDefaults standardUserDefaults] setObject:rongCloudToken forKey:@"RONG_CLOUD_KEY"];
}

#pragma mark - response events
- (IBAction)onResetPwdBtnClicked:(UIButton *)sender {
    ResetPwdViewController *resetPwdVC = [[ResetPwdViewController alloc] init];
    [self.navigationController pushViewController:resetPwdVC animated:YES];
}

- (IBAction)onLoginBtnClicked:(UIButton *)sender {
    [self hideKeyboard];
    [_loginDataParse loginWithUserName:_userNameTxtField.text password:_passwordTxtField.text];
}

- (IBAction)onSignUpBtnClicked:(UIButton *)sender {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

- (void)hideKeyboard {
    [self.userNameTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
}

#pragma mark - private methods
- (void)showTips:(NSString *)tip mode:(MRProgressOverlayViewMode)mode isDismiss:(BOOL)isDismiss
{
    [self.view addSubview:self.progress];
    [self.progress show:YES];
    self.progress.mode = mode;
    self.progress.titleLabelText = tip;
    if (isDismiss)
    {
        [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:.8f];
    }
}

- (void)dismissProgress
{
    if (self.progress)
    {
        [self.progress dismiss:YES];
    }
}

#pragma mark - setters&getters
-(void)setTextFieldHoldView:(UIView *)textFieldHoldView {
    _textFieldHoldView = textFieldHoldView;
    
    _textFieldHoldView.layer.borderWidth = 1.0;
    _textFieldHoldView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setLoginBtn:(UIButton *)loginBtn {
    _loginBtn = loginBtn;
    
    _loginBtn.layer.cornerRadius = 18.f;
}

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

@end
