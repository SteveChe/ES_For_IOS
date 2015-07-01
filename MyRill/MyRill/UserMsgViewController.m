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

@interface UserMsgViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

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

#pragma mark - response events
- (void)settingBtnItemOnClicked:(UIBarButtonItem *)sender {
    UserSettingViewController *settingVC = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction)logoutBtnOnClicked:(UIButton *)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [appDelegate changeWindow:loginVC];
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

@end
