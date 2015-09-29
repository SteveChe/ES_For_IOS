//
//  ResetPwdViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/22.
//
//

#import "ResetPwdViewController.h"
#import "ColorHandler.h"
#import "CustomShowMessage.h"
#import "GetVerificationCodeDataParse.h"
#import "ResetPwdDataParse.h"

@interface ResetPwdViewController () <GetVerificationCodeDelegate, ResetPwdDelegate>

@property (weak, nonatomic) IBOutlet UIView *textFieldHoldView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *newpwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *validateCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) GetVerificationCodeDataParse *getVerificationCodeDP;
@property (nonatomic, strong) ResetPwdDataParse *resetPwdDP;

@end

@implementation ResetPwdViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"找回密码";

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - GetVerificationCodeDelegate methods
- (void)resetPwdSucceed {
    //UIKit的操作需要在主线程中完成
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CustomShowMessage getInstance] showNotificationMessage:@"密码重置成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)resetPwdFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

- (void)getVerificationCodeSucceed {
    [[CustomShowMessage getInstance] showNotificationMessage:@"验证码已发送!"];
}

- (void)getVerificationCodeFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark - response event
- (void)hideKeyboard {
    [self.phoneNumTextField resignFirstResponder];
    [self.validateCodeTextField resignFirstResponder];
    [self.newpwdTextField resignFirstResponder];
    [self.confirmPwdTextField resignFirstResponder];
}

- (IBAction)verificationBtnOnClicked:(UIButton *)sender {
    if ([ColorHandler isNullOrEmptyString:self.phoneNumTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"手机号码不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.validateCodeBtn.userInteractionEnabled) {
        [self.getVerificationCodeDP getVerificationCode:self.phoneNumTextField.text];
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
                [self.validateCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.validateCodeBtn.userInteractionEnabled = YES;
                //                [_signUpDataParse getVerificationCode:_phoneNumTxtField.text];
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [self.validateCodeBtn setTitle:[NSString stringWithFormat:@" %@s重新发送 ",strTime] forState:UIControlStateNormal];
                self.validateCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)confirmBtnOnClicked:(UIButton *)sender {
    if ([ColorHandler isNullOrEmptyString:self.phoneNumTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"手机号不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([ColorHandler isNullOrEmptyString:self.validateCodeTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"验证码不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.newpwdTextField.text isEqualToString:@""] || [self.confirmPwdTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"密码不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.newpwdTextField.text.length < 6 || self.confirmPwdTextField.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"密码不能少于6位!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![self.newpwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"两次密码输入不一致!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //首先回收键盘
    [self hideKeyboard];
    [self.resetPwdDP resetPwdWithPhoneNum:self.phoneNumTextField.text
                                 password:self.confirmPwdTextField.text
                         verificationCode:self.validateCodeTextField.text];

}

#pragma mark - setter&getter
- (void)setTextFieldHoldView:(UIView *)textFieldHoldView {
    _textFieldHoldView = textFieldHoldView;
    
    _textFieldHoldView.layer.borderWidth = 1.0;
    _textFieldHoldView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setValidateCodeBtn:(UIButton *)validateCodeBtn {
    _validateCodeBtn = validateCodeBtn;
    
    _validateCodeBtn.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    _validateCodeBtn.layer.borderWidth = 1.0;
    _validateCodeBtn.layer.cornerRadius = 3.0;
}

- (void)setConfirmBtn:(UIButton *)confirmBtn {
    _confirmBtn = confirmBtn;
    
    _confirmBtn.layer.cornerRadius = 18.f;
}

- (GetVerificationCodeDataParse *)getVerificationCodeDP {
    if (!_getVerificationCodeDP) {
        _getVerificationCodeDP = [[GetVerificationCodeDataParse alloc] init];
        _getVerificationCodeDP.delegate = self;
    }
    
    return _getVerificationCodeDP;
}

- (ResetPwdDataParse *)resetPwdDP {
    if (!_resetPwdDP) {
        _resetPwdDP = [[ResetPwdDataParse alloc] init];
        _resetPwdDP.delegate = self;
    }
    
    return _resetPwdDP;
}

@end
