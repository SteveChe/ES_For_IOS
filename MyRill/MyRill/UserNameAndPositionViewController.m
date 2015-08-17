//
//  UserNameAndPositionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import "UserNameAndPositionViewController.h"
#import "ColorHandler.h"
#import "ESUserDetailInfo.h"

@interface UserNameAndPositionViewController () <ChangeUserMsgDelegate>

@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (weak, nonatomic) IBOutlet UITextField *nameAndPositionTxtField;

@property (nonatomic, strong) ChangeUserMsgDataParse *changeUserMsgDP;

@end

@implementation UserNameAndPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(confirmItemOnClicked)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(cancelItemOnClicked)];
    self.navigationItem.rightBarButtonItem = confirmItem;
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    self.nameAndPositionTxtField.text = self.nameAndPositionStr;
}

- (void)changeUserMsgSuccess {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.type == ESUserMsgName) {
        [userDefaults setObject:self.nameAndPositionTxtField.text forKey:@"UserName"];
    } else if (self.type == ESUserMsgPosition) {
        [userDefaults setObject:self.nameAndPositionTxtField.text forKey:@"UserPosition"];
    } else {
        
    }
    [userDefaults synchronize];
    
    [self cancelItemOnClicked];
}

- (void)confirmItemOnClicked {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ESUserDetailInfo *userInfo = [[ESUserDetailInfo alloc] init];
    userInfo.userId = [userDefaults stringForKey:@"UserId"];
    
    if (self.type == ESUserMsgName) {
        userInfo.userName = self.nameAndPositionTxtField.text;
        userInfo.position = [userDefaults stringForKey:@"UserPosition"];
    } else {
        userInfo.userName = [userDefaults stringForKey:@"UserName"];
        userInfo.position = self.nameAndPositionTxtField.text;
    }
    
    userInfo.contactDescription = [userDefaults stringForKey:@"UserDecription"];
    
    [self.changeUserMsgDP changeUserMsgWithUserInfo:userInfo];
}

- (void)cancelItemOnClicked {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setHoldView:(UIView *)holdView {
    _holdView = holdView;
    
    _holdView.layer.borderWidth = 1.f;
    _holdView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (ChangeUserMsgDataParse *)changeUserMsgDP {
    if (!_changeUserMsgDP) {
        _changeUserMsgDP = [[ChangeUserMsgDataParse alloc] init];
        _changeUserMsgDP.delegate = self;
    }
    
    return _changeUserMsgDP;
}

@end
