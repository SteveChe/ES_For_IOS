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
#import "MRProgress.h"

@interface UserNameAndPositionViewController () <ChangeUserMsgDelegate>

@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (weak, nonatomic) IBOutlet UITextField *nameAndPositionTxtField;

@property (nonatomic, strong) ChangeUserMsgDataParse *changeUserMsgDP;
@property (nonatomic, strong) MRProgressOverlayView *progress;

@end

@implementation UserNameAndPositionViewController

#pragma mark - lifeCycle methods
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(freeKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.nameAndPositionTxtField.text = self.nameAndPositionStr;
}

#pragma mark - ChangeUserMsgDelegate methods
- (void)changeUserMsgSuccess:(ESUserDetailInfo *)userInfo {
    NSLog(@"%@",userInfo);
    [self showTips:@"修改成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES isSucceuss:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.type == ESUserMsgName) {
        [userDefaults setObject:[ColorHandler isNullOrEmptyString:userInfo.userName]?@"":userInfo.userName forKey:@"UserName"];
    } else if (self.type == ESUserMsgPosition) {
        [userDefaults setObject:[ColorHandler isNullOrEmptyString:userInfo.position]?@"":userInfo.position forKey:@"UserPosition"];
    } else {
        //empty
    }
    [userDefaults synchronize];
}

- (void)changeUserMsgFailed:(NSString *)error {
    [self showTips:@"修改失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES isSucceuss:NO];
}

#pragma mark - response methods
- (void)freeKeyboard {
    [self.nameAndPositionTxtField resignFirstResponder];
}

- (void)confirmItemOnClicked {
    [self freeKeyboard];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ESUserDetailInfo *userInfo = [[ESUserDetailInfo alloc] init];
    userInfo.userId = [userDefaults stringForKey:@"UserId"];
    
    if (self.type == ESUserMsgName) {
        if ([ColorHandler isNullOrEmptyString:self.nameAndPositionTxtField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"用户名不能为空"
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了!"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
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
    [self freeKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
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
            [self cancelItemOnClicked];
        }
    }
}

#pragma mark - setters&getters
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

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

@end
