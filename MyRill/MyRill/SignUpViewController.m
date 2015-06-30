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
#import "CustomShowMessage.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTxtField;
@property (weak, nonatomic) IBOutlet UITextField *captchasTxtField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTxtField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@property (strong, nonatomic) SignUpDataParse * signUpDataParse;

@end

@implementation SignUpViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    _signUpDataParse = [[SignUpDataParse alloc] init];
    _signUpDataParse.delegate = self;
}

#pragma mark - response events
- (void)hideKeyboard {
    [self.phoneNumTxtField resignFirstResponder];
    [self.captchasTxtField resignFirstResponder];
    [self.usernameTxtField resignFirstResponder];
    [self.pwdTxtField resignFirstResponder];
    [self.confirmPwdTxtField resignFirstResponder];
}

- (IBAction)compBtnOnClicked:(UIButton *)sender {
    QRCodeViewController *qrcodeVC = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

- (IBAction)signUpBtnOnClicked:(UIButton *)sender {
    [_signUpDataParse signUpWithPhoneNum:self.phoneNumTxtField.text
                                password:self.pwdTxtField.text
                        verificationCode:self.captchasTxtField.text];
}

- (void)verificationBtnOnClicked:(UIButton *)sender {
    [_signUpDataParse getVerificationCode:_phoneNumTxtField.text];
}

#pragma mark SignUpDataDelegate - method
-(void)signUpSucceed
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"登录成功"];
    
    [self performSelector:@selector(changeToLoginView)
               withObject:nil
               afterDelay:2];
    
}

-(void)signUpFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

-(void)changeToLoginView
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [appDelegate changeWindow:loginVC];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    }
}

- (void)setVerificationBtn:(UIButton *)verificationBtn {
    _verificationBtn = verificationBtn;
    
    _verificationBtn.layer.cornerRadius = 3.0;
    _verificationBtn.layer.borderWidth = 1.0;
    _verificationBtn.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setSignUpBtn:(UIButton *)signUpBtn {
    _signUpBtn = signUpBtn;
    
    _signUpBtn.layer.cornerRadius = 19.0;
}

@end
