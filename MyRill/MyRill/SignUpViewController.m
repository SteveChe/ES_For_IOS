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

- (IBAction)signUpBtnOnClicked:(UIButton *)sender {
    [self hideKeyboard];
    [_signUpDataParse signUpWithPhoneNum:self.phoneNumTxtField.text name:self.usernameTxtField.text password:self.pwdTxtField.text
                        verificationCode:self.captchasTxtField.text];
}

- (IBAction)verificationBtnOnClicked:(UIButton *)sender {
    
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
                [_signUpDataParse getVerificationCode:_phoneNumTxtField.text];
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
-(void)signUpSucceed{
    [[CustomShowMessage getInstance] showNotificationMessage:@"注册成功"];
    
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
