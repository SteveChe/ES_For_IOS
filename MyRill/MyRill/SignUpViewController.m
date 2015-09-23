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
#import "SignUpDataParse.h"
#import "CustomShowMessage.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ESNavigationController.h"
#import "UserDefaultsDefine.h"
#import "GetVerificationCodeDataParse.h"
#import "CustomShowMessage.h"

@interface SignUpViewController () <UITextFieldDelegate, SignUpDataDelegate, GetVerificationCodeDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTxtField;
@property (weak, nonatomic) IBOutlet UITextField *captchasTxtField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTxtField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;


@property (nonatomic, assign) BOOL isCanSend;
@property (strong, nonatomic) SignUpDataParse * signUpDataParse;
@property (nonatomic, strong) GetVerificationCodeDataParse *getVerificationCodeDP;

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
    
    self.isCanSend = YES;
}

#pragma mark - SignUpDataDelegate&GetVerificationCodeDelegate methods
- (void)signUpSucceed{
    [[CustomShowMessage getInstance] showNotificationMessage:@"注册成功"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.usernameTxtField.text forKey:DEFAULTS_USERNAME];
    
    [self performSelector:@selector(changeToLoginView)
               withObject:nil
               afterDelay:2];
}

- (void)signUpFailed:(NSString*)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

- (void)getVerificationCodeSucceed {
    [[CustomShowMessage getInstance] showNotificationMessage:@"验证码已发送!"];
}

- (void)getVerificationCodeFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark - response events
- (void)hideKeyboard {
    [self.phoneNumTxtField resignFirstResponder];
    [self.captchasTxtField resignFirstResponder];
    [self.usernameTxtField resignFirstResponder];
    [self.pwdTxtField resignFirstResponder];
    [self.confirmPwdTxtField resignFirstResponder];
}

- (IBAction)signUpBtnOnClicked:(UIButton *)sender {
    [self hideKeyboard];
    
    NSString *errorMsg = nil;
    if ([ColorHandler isNullOrEmptyString:self.phoneNumTxtField.text]) {
        errorMsg = @"手机号不能为空!";
    } else if ([ColorHandler isNullOrEmptyString:self.captchasTxtField.text]) {
        errorMsg = @"验证码不能为空!";
    } else if ([ColorHandler isNullOrEmptyString:self.usernameTxtField.text]) {
        errorMsg = @"用户名不能为空!";
    } else if ([ColorHandler isNullOrEmptyString:self.pwdTxtField.text] || [ColorHandler isNullOrEmptyString:self.confirmPwdTxtField.text]) {
        errorMsg = @"请输入密码!";
    } else if (![self.pwdTxtField.text isEqualToString:self.confirmPwdTxtField.text]) {
        errorMsg = @"两次密码输入不一致!";
    } else if (self.pwdTxtField.text.length < 6 || self.confirmPwdTxtField.text.length > 16 ){
        errorMsg = @"密码长度由6-16位数字或字母组成!";
    }else {
        //empty
    }
    
    if (errorMsg != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:errorMsg
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [_signUpDataParse signUpWithPhoneNum:self.phoneNumTxtField.text name:self.usernameTxtField.text password:self.pwdTxtField.text
                        verificationCode:self.captchasTxtField.text];
}

- (IBAction)verificationBtnOnClicked:(UIButton *)sender {
    
    if ([ColorHandler isNullOrEmptyString:_phoneNumTxtField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"手机号码不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.verificationBtn.userInteractionEnabled) {
        [self.getVerificationCodeDP getVerificationCode:_phoneNumTxtField.text];
    }
    
    __block int timeout = 30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.verificationBtn.userInteractionEnabled = YES;
//                [_signUpDataParse getVerificationCode:_phoneNumTxtField.text];
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [self.verificationBtn setTitle:[NSString stringWithFormat:@" %@s重新发送 ",strTime] forState:UIControlStateNormal];
                self.verificationBtn.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark SignUpDataDelegate - method
-(void)changeToLoginView
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:loginVC];

    [appDelegate changeWindow:nav];
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
    
    _signUpBtn.layer.cornerRadius = 18.f;
}

- (GetVerificationCodeDataParse *)getVerificationCodeDP {
    if (!_getVerificationCodeDP) {
        _getVerificationCodeDP = [[GetVerificationCodeDataParse alloc] init];
        _getVerificationCodeDP.delegate = self;
    }
    
    return _getVerificationCodeDP;
}

@end
