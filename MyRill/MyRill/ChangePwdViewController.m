//
//  ChangePwdViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/24.
//
//

#import "ChangePwdViewController.h"
#import "ChangePwdDataParse.h"
#import "MRProgress.h"

@interface ChangePwdViewController () <ChangePwdDataDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdOrphoneNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *pwdOrCodeLbl;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTxtField;
@property (weak, nonatomic) IBOutlet UITextField *newpwdTxtField;
@property (weak, nonatomic) IBOutlet UITextField *newpwdAgainTxtField;
@property (nonatomic, strong) MRProgressOverlayView *progress;
@property (nonatomic, strong) ChangePwdDataParse *changePwdDP;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"密码修改";
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(commitBtnItemOnClicked:)];
    self.navigationItem.rightBarButtonItem = commitBtnItem;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - ChangePwdDataDelegate methods
- (void)changePasswordSucceed {
    [self showTips:@"修改成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES isSucceuss:YES];
}

- (void)changePasswordFailed:(NSString *)errorMsg {
    [self showTips:@"修改失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES isSucceuss:NO];
}

#pragma mark - response events
- (void)hideKeyboard {
    [self.oldPwdTxtField resignFirstResponder];
    [self.newpwdTxtField resignFirstResponder];
    [self.newpwdAgainTxtField resignFirstResponder];
}

- (void)commitBtnItemOnClicked:(UIBarButtonItem *)sender {
    
    if ([self.newpwdTxtField.text isEqualToString:@""] || [self.newpwdAgainTxtField.text isEqualToString:@""]) {
        return;
    }
    
    if (self.newpwdTxtField.text.length < 6 || self.newpwdAgainTxtField.text.length < 6) {
        return;
    }
    
    if (![self.newpwdTxtField.text isEqualToString:self.newpwdAgainTxtField.text]) {
        return;
    }
    
    //首先回收键盘
    [self hideKeyboard];
    [self.changePwdDP changePassword:self.oldPwdTxtField.text newPassword:self.newpwdAgainTxtField.text];
}

#pragma mark - private methods
- (void)showTips:(NSString *)tip mode:(MRProgressOverlayViewMode)mode isDismiss:(BOOL)isDismiss isSucceuss:(BOOL)success
{
    [self.view addSubview:self.progress];
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
- (ChangePwdDataParse *)changePwdDP {
    if (!_changePwdDP) {
        _changePwdDP = [[ChangePwdDataParse alloc] init];
        _changePwdDP.delegate = self;
    }
    
    return _changePwdDP;
}

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

@end
