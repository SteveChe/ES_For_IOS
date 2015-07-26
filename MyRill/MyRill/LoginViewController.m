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
#import "ESUserInfo.h"
#import "MRProgress.h"

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (e_login_status_logout ==  self.eStatus) {
        [self showTips:@"注销成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES];
    }
    else if (e_login_status_invalid ==  self.eStatus) {
        [self showTips:@"登录失效!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES];
    }

}

#pragma mark - LoginDataDelegate
- (void)loginSucceed:(ESUserInfo *)userInfo
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"登录成功"];
    [_loginDataParse getRongCloudToken];
    [self performSelector:@selector(changeToESMenuView)
               withObject:nil
               afterDelay:.5];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userInfo.userId forKey:@"UserId"];
    [userDefaults setObject:userInfo.userName forKey:@"UserName"];
    [userDefaults setObject:userInfo.phoneNumber forKey:@"PhoneNumber"];
    [userDefaults setObject:userInfo.enterprise forKey:@"Enterprise"];
    [userDefaults setObject:userInfo.position forKey:@"Position"];
    [userDefaults setObject:[@"http://120.25.249.144" stringByAppendingString:userInfo.portraitUri] forKey:@"UserImageURL"];
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
        [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:1.8];
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
    
    _loginBtn.layer.cornerRadius = 20.0;
}

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

@end
