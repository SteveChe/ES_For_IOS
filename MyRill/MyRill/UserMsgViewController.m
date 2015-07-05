//
//  UserMsgViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "UserMsgViewController.h"
#import "ColorHandler.h"
#import "UserSettingViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SignOutDataParse.h"
#import "MRProgress.h"

@interface UserMsgViewController () <LogoutDataDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (nonatomic, strong) SignOutDataParse *signOutDP;
@property (nonatomic, strong) MRProgressOverlayView *progress;

@end

@implementation UserMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    self.view.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"];
    
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                      target:self
                                                                      action:@selector(settingBtnItemOnClicked:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
    
}

#pragma mark - LogoutDataParse delegate
- (void)logoutSuccess {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [appDelegate changeWindow:loginVC];
    self.progress.mode = MRProgressOverlayViewModeCheckmark;
    self.progress.titleLabelText = @"注销成功!";
    
    [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:1.5];
}

- (void)logoutFail {
    
}

-(void)dismissProgress
{
    if (self.progress)
    {
        [self.progress dismiss:YES];
    }
}

#pragma mark - response events
- (void)settingBtnItemOnClicked:(UIBarButtonItem *)sender {
    UserSettingViewController *settingVC = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction)logoutBtnOnClicked:(UIButton *)sender {
    SignOutDataParse *signOutDP = [[SignOutDataParse alloc] init];
    [signOutDP logout];
    
    [self.progress show:YES];
    self.progress.mode = MRProgressOverlayViewModeDeterminateCircular;
    self.progress.titleLabelText = @"注销...";
}

#pragma mark - setters&getters
- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    
    _contentView.layer.borderWidth = 1.f;
    _contentView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setLogoutBtn:(UIButton *)logoutBtn {
    _logoutBtn = logoutBtn;
    
    _logoutBtn.layer.cornerRadius = 20.f;
}

- (SignOutDataParse *)signOutDP {
    if (!_signOutDP) {
        _signOutDP = [[SignOutDataParse alloc] init];
        _signOutDP.delegate = self;
    }
    
    return _signOutDP;
}

- (MRProgressOverlayView *)progress {
    if (_progress) {
        _progress = [[MRProgressOverlayView alloc] initWithFrame:CGRectMake(200, 200, 300, 300)];
        [self.view addSubview:_progress];
    }
    return _progress;
}

@end
