//
//  ChangePwdViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/24.
//
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdOrphoneNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *pwdOrCodeLbl;

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
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - response events
- (void)commitBtnItemOnClicked:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setters&getters
- (void)setUserMsgChangeType:(ESUserMsgChangeType)userMsgChangeType {
    _userMsgChangeType = userMsgChangeType;
    
    if (_userMsgChangeType == ESPwdChangeMold) {
        return;
    } else {
        self.title = @"更换手机号";
        self.pwdOrphoneNumLbl.text = @"新手机号";
        self.pwdOrCodeLbl.text = @"输入验证码";
    }
}

- (void)setPwdOrphoneNumLbl:(UILabel *)pwdOrphoneNumLbl {
    _pwdOrphoneNumLbl = pwdOrphoneNumLbl;
    
}

@end
