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

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UIView *textFieldHoldView;
@property (nonatomic, strong) IBOutlet UITextField *userNameTxtField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTxtField;
@property (nonatomic, weak) IBOutlet UIButton *resetPswBtn;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) IBOutlet UIButton *signUpBtn;
@property (nonatomic, strong) LoginDataParse* loginDataParse;
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

#pragma mark - LoginDataDelegate
-(void)loginSucceed
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"登录成功"];
    return;
    
}
-(void)loginFailed
{
    
}

#pragma mark - response events
- (IBAction)onResetPwdBtnClicked:(UIButton *)sender {
    ResetPwdViewController *resetPwdVC = [[ResetPwdViewController alloc] init];
    [self.navigationController pushViewController:resetPwdVC animated:YES];
}

- (IBAction)onLoginBtnClicked:(UIButton *)sender {
    [_loginDataParse loginWithUserName:_userNameTxtField.text password:_passwordTxtField.text];

    //[_loginDataParse loginWithUserName:_userNameTxtField.text password:_passwordTxtField.text];
}

- (IBAction)onSignUpBtnClicked:(UIButton *)sender {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

- (void)hideKeyboard {
    [self.userNameTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
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

@end
