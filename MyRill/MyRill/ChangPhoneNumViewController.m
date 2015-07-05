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

@interface ChangPhoneNumViewController () <ChangePhoneNumDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *newphoneNumTxtField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTxtField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (nonatomic, strong) SignUpDataParse *signUpDP;
@property (nonatomic, strong) ChangePhoneNumDataParse *changePhoneNumDP;

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
}

#pragma mark - ChangePhoneNumDelegate methods
- (void)changePhoneNumSuccess {
    NSLog(@"修改成功");
}

#pragma mark - response events
- (void)hideKeyboard {
    [self.newphoneNumTxtField resignFirstResponder];
    [self.verificationTxtField resignFirstResponder];
}

- (void)commitBtnItemOnClicked:(UIBarButtonItem *)sender {
    [self.changePhoneNumDP changePhoneNumWithNewPhoneNum:self.newphoneNumTxtField.text
                                       vertificationCode:self.verificationTxtField.text];
}

- (IBAction)verificationBtnOnClicked:(UIButton *)sender {
    [self.signUpDP getVerificationCode:self.newphoneNumTxtField.text];
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

@end
