//
//  ResetPwdViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/22.
//
//

#import "ResetPwdViewController.h"
#import "ColorHandler.h"
#import "LoginViewController.h"

@interface ResetPwdViewController ()

@property (weak, nonatomic) IBOutlet UIView *textFieldHoldView;
@property (weak, nonatomic) IBOutlet UIButton *validateCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *newpwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

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

#pragma mark - response event
- (void)hideKeyboard {
    [self.phoneNumTextField resignFirstResponder];
    [self.validateCodeTextField resignFirstResponder];
    [self.newpwdTextField resignFirstResponder];
    [self.confirmPwdTextField resignFirstResponder];
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
    
    _confirmBtn.layer.cornerRadius = 20.0;
}

@end
