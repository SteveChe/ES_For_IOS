//
//  BMCLoginViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import "BMCLoginViewController.h"
#import "BMCLoginDataParse.h"
#import "ColorHandler.h"
#import "BMCMainViewController.h"
#import "CustomShowMessage.h"

@interface BMCLoginViewController () <BMCLoginDelegate>

@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtField;
@property (weak, nonatomic) IBOutlet UIButton *BMCLoginBtn;

@property (nonatomic, strong) BMCLoginDataParse *bmcLoginDP;

@end

@implementation BMCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"RIIL-BMC";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![ColorHandler isNullOrEmptyString:[userDefault objectForKey:@"BMC_USERNAME"]]) {
        self.userNameTxtField.text = [userDefault objectForKey:@"BMC_USERNAME"];
    }
    if (![ColorHandler isNullOrEmptyString:[userDefault objectForKey:@"BMC_PASSWORD"]]) {
        self.pwdTxtField.text = [userDefault objectForKey:@"BMC_PASSWORD"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - BMCLoginDelegate methods
- (void)loginSucceed:(NSDictionary *)loginDic {
    [[CustomShowMessage getInstance] showNotificationMessage:@"BMC登录成功!"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:self.userNameTxtField.text forKey:@"BMC_USERNAME"];
    [userDefault setValue:self.pwdTxtField.text forKey:@"BMC_PASSWORD"];
    [userDefault synchronize];
    
    BMCMainViewController *bmcMainVC = [[BMCMainViewController alloc] init];
    [self.navigationController pushViewController:bmcMainVC animated:YES];
}

- (void)loginFailed:(NSString *)errorMessage {
    
}

#pragma mark - response events
- (void)hideKeyboard {
    [self.userNameTxtField resignFirstResponder];
    [self.pwdTxtField resignFirstResponder];
}

- (IBAction)loginBtnOnClicked:(UIButton *)sender {
    [self.bmcLoginDP loginBMCWithUserName:self.userNameTxtField.text
                                 password:self.pwdTxtField.text];
}

#pragma mark - setter&getter
- (void)setHoldView:(UIView *)holdView {
    _holdView = holdView;
    
    _holdView.layer.cornerRadius = 3.f;
    _holdView.layer.borderWidth = 1.f;
    _holdView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setBMCLoginBtn:(UIButton *)BMCLoginBtn {
    _BMCLoginBtn = BMCLoginBtn;
    
    _BMCLoginBtn.layer.cornerRadius = 18.f;
}

- (BMCLoginDataParse *)bmcLoginDP {
    if (!_bmcLoginDP) {
        _bmcLoginDP = [[BMCLoginDataParse alloc] init];
        _bmcLoginDP.delegate = self;
    }
    
    return _bmcLoginDP;
}

@end
