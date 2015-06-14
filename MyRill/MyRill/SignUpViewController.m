//
//  SignUpViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/8.
//
//

#import "SignUpViewController.h"
#import "ColorHandler.h"
#import "Masonry.h"
#import "QRCodeViewController.h"
#import "SignUpDataParse.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *phoneNumTxtField;
@property (strong, nonatomic) UITextField *captchasTxtField;
@property (strong, nonatomic) UITextField *usernameTxtField;
@property (strong, nonatomic) UITextField *pwdTxtField;
@property (strong, nonatomic) UITextField *validatePwdTxtField;

@property (strong, nonatomic) UIButton *joinBtn;
@property (strong, nonatomic) UIButton *signUpBtn;
@property (strong, nonatomic) SignUpDataParse * signUpDataParse;

@end

@implementation SignUpViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    [self.view endEditing:YES];
    
    [self.view addSubview:self.phoneNumTxtField];
    [self.view addSubview:self.captchasTxtField];
    [self.view addSubview:self.usernameTxtField];
    [self.view addSubview:self.pwdTxtField];
    [self.view addSubview:self.validatePwdTxtField];
    [self.view addSubview:self.joinBtn];
    [self.view addSubview:self.signUpBtn];
    
    [self layoutPageSubviews];
    
    _signUpDataParse = [[SignUpDataParse alloc] init];
    
}

- (void)layoutPageSubviews {
    __weak UIView *weakSelf = self.view;
    [self.pwdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    __weak UITextField *weakPwd = self.pwdTxtField;
    [self.usernameTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakPwd.mas_top).with.offset(-8);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    __weak UITextField *weakUsername = self.usernameTxtField;
    [self.captchasTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakUsername.mas_top).with.offset(-8);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    __weak UITextField *weakCaptchas = self.captchasTxtField;
    [self.phoneNumTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakCaptchas.mas_top).with.offset(-8);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.validatePwdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPwd.mas_bottom).with.offset(8);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    __weak UITextField *weakValidate = self.validatePwdTxtField;
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakValidate.mas_bottom).with.offset(8);
        make.leading.equalTo(weakSelf.mas_leading).with.offset(20);
        make.trailing.equalTo(weakSelf.mas_trailing).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    __weak UIButton *weakJoin = self.joinBtn;
    [self.signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakJoin.mas_bottom).with.offset(8);
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
- (void)compBtnOnClicked:(UIButton *)sender {
    QRCodeViewController *qrcodeVC = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrcodeVC animated:YES];
    
}

- (void)signUpBtnOnClicked:(UIButton *)sender {
    [_signUpDataParse signUpWithPhoneNum:_phoneNumTxtField.text password:_pwdTxtField.text verificationCode:_captchasTxtField.text];
}

- (void)verificationBtnOnClicked:(UIButton *)sender {
    [_signUpDataParse getVerificationCode:_phoneNumTxtField.text];
}

#pragma mark - private methods
- (void)textFieldConfig:(UITextField *)textField {
    textField.layer.borderColor = [ColorHandler colorFromHexRGB:@"EDEDED"].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 3.0;
    textField.textColor = [ColorHandler colorFromHexRGB:@"B1B1B1"];
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
}

#pragma mark - setters&getters
- (UITextField *)phoneNumTxtField {
    if (!_phoneNumTxtField) {
        _phoneNumTxtField = [UITextField new];
        _phoneNumTxtField.placeholder = @"输入手机号";
        _phoneNumTxtField.textAlignment = NSTextAlignmentLeft;
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.bounds = CGRectMake(0, 0, 80, 30);
        rightBtn.backgroundColor = [UIColor blueColor];
        [rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn addTarget:self action:@selector(verificationBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];

        _phoneNumTxtField.rightView = rightBtn;
        _phoneNumTxtField.rightViewMode = UITextFieldViewModeAlways;
        [self textFieldConfig:_phoneNumTxtField];
    }
    
    return _phoneNumTxtField;
}

- (UITextField *)captchasTxtField {
    if (!_captchasTxtField) {
        _captchasTxtField = [UITextField new];
        _captchasTxtField.placeholder = @"输入验证码";
        _captchasTxtField.textAlignment = NSTextAlignmentLeft;
        [self textFieldConfig:_captchasTxtField];
    }
    
    return _captchasTxtField;
}

- (UITextField *)usernameTxtField {
    if (!_usernameTxtField) {
        _usernameTxtField = [UITextField new];
        _usernameTxtField.placeholder = @"用户名";
        _usernameTxtField.textAlignment = NSTextAlignmentCenter;
        [self textFieldConfig:_usernameTxtField];
    }
    
    return _usernameTxtField;
}

- (UITextField *)pwdTxtField {
    if (!_pwdTxtField) {
        _pwdTxtField = [UITextField new];
        _pwdTxtField.placeholder = @"输入密码";
        _pwdTxtField.textAlignment = NSTextAlignmentCenter;
        [self textFieldConfig:_pwdTxtField];
    }
    
    return _pwdTxtField;
}

- (UITextField *)validatePwdTxtField {
    if (!_validatePwdTxtField) {
        _validatePwdTxtField = [UITextField new];
        _validatePwdTxtField.placeholder = @"确认密码";
        _validatePwdTxtField.textAlignment = NSTextAlignmentCenter;
        [self textFieldConfig:_validatePwdTxtField];
    }
    
    return _validatePwdTxtField;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton new];
        [_joinBtn setTitle:@"加入企业" forState:UIControlStateNormal];
        _joinBtn.backgroundColor = [UIColor blueColor];
        _joinBtn.layer.cornerRadius = 3.0;
        [_joinBtn addTarget:self action:@selector(compBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _joinBtn;
}

- (UIButton *)signUpBtn {
    if (!_signUpBtn) {
        _signUpBtn = [UIButton new];
        [_signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
        _signUpBtn.backgroundColor = [UIColor blueColor];
        _signUpBtn.layer.cornerRadius = 3.0;
        [_signUpBtn addTarget:self action:@selector(signUpBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _signUpBtn;
}

@end
