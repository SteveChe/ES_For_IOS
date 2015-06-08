//
//  LoginViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/7.
//
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "ColorHandler.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *userNameTxtField;
@property (nonatomic, strong) UITextField *passwordTxtField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *signUpBtn;
@property (nonatomic, strong) LoginDataParse* loginDataParse;

@end

@implementation LoginViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.userNameTxtField];
    [self.view addSubview:self.passwordTxtField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.signUpBtn];
    
    [self layoutPageSubviews];
    
    _loginDataParse = [[LoginDataParse alloc] init];
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
    
    __weak UIButton *weakLogin = self.loginBtn;
    [self.signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakLogin.mas_bottom).with.offset(8);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - response events
- (void)onLoginBtnClicked:(UIButton *)sender {
    [_loginDataParse loginWithUserName:_userNameTxtField.text password:_passwordTxtField.text];
    
}

- (void)onSignUpBtnClicked:(UIButton *)sender {
    
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

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        _loginBtn.layer.cornerRadius = 3.0;
        _loginBtn.backgroundColor = [UIColor blueColor];
        [_loginBtn addTarget:self action:@selector(onLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    }
    
    return _loginBtn;
}

- (UIButton *)signUpBtn {
    if (!_signUpBtn) {
        _signUpBtn = [UIButton new];
        _signUpBtn.layer.cornerRadius = 3.0;
        _signUpBtn.backgroundColor = [UIColor blueColor];
        [_signUpBtn addTarget:self action:@selector(onSignUpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
    
    return _signUpBtn;
}

@end
