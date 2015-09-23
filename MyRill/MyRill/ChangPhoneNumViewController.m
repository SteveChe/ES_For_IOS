//
//  ChangPhoneNumViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/5.
//
//

#import "ChangPhoneNumViewController.h"
#import "ColorHandler.h"
#import "SignUpDataParse.h"
#import "ChangePhoneNumDataParse.h"
#import "MRProgress.h"
#import "UserDefaultsDefine.h"
#import "GetVerificationCodeDataParse.h"
#import "CustomShowMessage.h"

@interface ChangPhoneNumViewController () <ChangePhoneNumDelegate, GetVerificationCodeDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLbl;
@property (weak, nonatomic) IBOutlet UITextField *newphoneNumTxtField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTxtField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (nonatomic, strong) MRProgressOverlayView *progress;
@property (nonatomic, strong) SignUpDataParse *signUpDP;
@property (nonatomic, strong) ChangePhoneNumDataParse *changePhoneNumDP;
@property (nonatomic, strong) GetVerificationCodeDataParse *getVerificationCodeDP;

@end

@implementation ChangPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"更换手机号";
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(commitBtnItemOnClicked:)];
    self.navigationItem.rightBarButtonItem = commitBtnItem;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.phoneNumLbl.text = [@"当前手机号:" stringByAppendingString:[userDefaults stringForKey:DEFAULTS_USERPHONENUMBER]];
}

#pragma mark - ChangePhoneNumDelegate&GetVerificationCodeDelegate methods
- (void)changePhoneNumSuccess {
    [self showTips:@"修改成功" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES isSucceuss:YES];
}

- (void)changePhoneNUmFail:(NSString *)errorMsg {
    if (errorMsg == nil || [errorMsg isEqual:[NSNull null]] || [errorMsg isEqualToString:@""]) {
        [self showTips:@"修改失败" mode:MRProgressOverlayViewModeCross isDismiss:YES isSucceuss:NO];
    }
}

- (void)getVerificationCodeSucceed {
    [[CustomShowMessage getInstance] showNotificationMessage:@"验证码已发送!"];
}

- (void)getVerificationCodeFailed:(NSString *)errorMessage {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark - response events
- (void)hideKeyboard {
    [self.newphoneNumTxtField resignFirstResponder];
    [self.verificationTxtField resignFirstResponder];
}

- (void)commitBtnItemOnClicked:(UIBarButtonItem *)sender {
    
    //首先回收键盘
    [self hideKeyboard];
    [self.changePhoneNumDP changePhoneNumWithNewPhoneNum:self.newphoneNumTxtField.text
                                       vertificationCode:self.verificationTxtField.text];
}

- (IBAction)verificationBtnOnClicked:(UIButton *)sender {
    
    if ([ColorHandler isNullOrEmptyString:self.newphoneNumTxtField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"手机号码不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.verificationBtn.userInteractionEnabled) {
        [self.getVerificationCodeDP getVerificationCode:self.newphoneNumTxtField.text];
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

#pragma mark - private methods
- (void)showTips:(NSString *)tip mode:(MRProgressOverlayViewMode)mode isDismiss:(BOOL)isDismiss isSucceuss:(BOOL)success
{
    [self.navigationController.view addSubview:self.progress];
    [self.progress show:YES];
    self.progress.mode = mode;
    self.progress.titleLabelText = tip;
    if (isDismiss)
    {
        [self performSelector:@selector(dismissProgress:) withObject:@(success) afterDelay:1.8];
    }
}

//参数作为布尔对象传递，使用Bool会出问题
- (void)dismissProgress:(Boolean)isSuccess
{
    if (self.progress)
    {
        [self.progress dismiss:YES];
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - setters&getters
- (SignUpDataParse *)signUpDP {
    if (!_signUpDP) {
        _signUpDP = [[SignUpDataParse alloc] init];
    }
    
    return _signUpDP;
}

- (ChangePhoneNumDataParse *)changePhoneNumDP {
    if (!_changePhoneNumDP) {
        _changePhoneNumDP = [[ChangePhoneNumDataParse alloc] init];
        _changePhoneNumDP.delegate = self;
    }
    
    return _changePhoneNumDP;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    
    _contentView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    _contentView.layer.borderWidth = 1.f;
}

- (void)setVerificationBtn:(UIButton *)verificationBtn {
    _verificationBtn = verificationBtn;
    
    _verificationBtn.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    _verificationBtn.layer.borderWidth = 1.f;
    _verificationBtn.layer.cornerRadius = 3.f;
    _verificationBtn.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"];
}

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

- (GetVerificationCodeDataParse *)getVerificationCodeDP {
    if (!_getVerificationCodeDP) {
        _getVerificationCodeDP = [[GetVerificationCodeDataParse alloc] init];
        _getVerificationCodeDP.delegate = self;
    }
    
    return _getVerificationCodeDP;
}

@end
