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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *textFieldHoldView;
@property (nonatomic, strong) UITextField *userNameTxtField;
@property (nonatomic, strong) UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) IBOutlet UIButton *signUpBtn;
@property (nonatomic, strong) LoginDataParse* loginDataParse;
@end

@implementation LoginViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"My Rill";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.userNameTxtField];
    [self.view addSubview:self.passwordTxtField];
    [self.view addSubview:self.loginBtn];
    
    [self layoutPageSubviews];
    
    _loginDataParse = [[LoginDataParse alloc] init];
    _loginDataParse.delegate = self;
}

- (void)layoutPageSubviews {
    __weak UIView *weakSelf = self.view;
    
    [self.userNameTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    __weak UITextField *weakUsername = self.userNameTxtField;
    [self.passwordTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakUsername.mas_bottom).with.offset(8);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    __weak UITextField *weakPassword = self.passwordTxtField;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakPassword.mas_bottom).with.offset(20);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)onLoginBtnClicked:(UIButton *)sender {
    [_loginDataParse loginWithUserName:_userNameTxtField.text password:_passwordTxtField.text];

    //[_loginDataParse loginWithUserName:_userNameTxtField.text password:_passwordTxtField.text];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate changeWindow:nil];
}

- (IBAction)onSignUpBtnClicked:(UIButton *)sender {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUpViewController];
    self.definesPresentationContext = YES;
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - setters&getters
- (UITextField *)userNameTxtField {
    if (!_userNameTxtField) {
        _userNameTxtField = [UITextField new];
        _userNameTxtField.layer.borderColor = [ColorHandler colorFromHexRGB:@"EDEDED"].CGColor;
        _userNameTxtField.layer.borderWidth = 1.0;
        _userNameTxtField.layer.cornerRadius = 3.0;
        _userNameTxtField.placeholder = @"手机号/用户名";
        _userNameTxtField.textColor = [ColorHandler colorFromHexRGB:@"B1B1B1"];
        _userNameTxtField.textAlignment = NSTextAlignmentCenter;
        _userNameTxtField.keyboardType = UIKeyboardTypeASCIICapable;
        _userNameTxtField.spellCheckingType = UITextSpellCheckingTypeNo;
        _userNameTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
    return _userNameTxtField;
}

- (UITextField *)passwordTxtField {
    if (!_passwordTxtField) {
        _passwordTxtField = [UITextField new];
        _passwordTxtField.layer.borderColor = [ColorHandler colorFromHexRGB:@"EDEDED"].CGColor;
        _passwordTxtField.layer.borderWidth = 1.0;
        _passwordTxtField.layer.cornerRadius = 3.0;
        _passwordTxtField.placeholder = @"密码";
        _passwordTxtField.textColor = [ColorHandler colorFromHexRGB:@"B1B1B1"];
        _passwordTxtField.textAlignment = NSTextAlignmentCenter;
        _passwordTxtField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTxtField.spellCheckingType = UITextSpellCheckingTypeNo;
        _passwordTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
    return _passwordTxtField;
}

-(void)setTextFieldHoldView:(UIView *)textFieldHoldView {
    _textFieldHoldView = textFieldHoldView;
    
    _textFieldHoldView.layer.borderWidth = 1.0;
    _textFieldHoldView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setLoginBtn:(UIButton *)loginBtn {
    _loginBtn = loginBtn;
    
    _loginBtn.layer.cornerRadius = 19.0;
}

@end
