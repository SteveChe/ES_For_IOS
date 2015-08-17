//
//  UserDescriptionChangeViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import "UserDescriptionChangeViewController.h"
#import "ColorHandler.h"
#import "ESUserDetailInfo.h"

@interface UserDescriptionChangeViewController () <ChangeUserMsgDelegate>

@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) ChangeUserMsgDataParse *changeUserMsgDP;

@end

@implementation UserDescriptionChangeViewController

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
    
    self.textView.text = self.descriptionStr;
}

- (void)changeUserMsgSuccess {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[@"简介：" stringByAppendingString:self.textView.text] forKey:@"UserDecription"];
    [userDefaults synchronize];
    
    [self cancelItemOnClicked];
}

- (void)confirmItemOnClicked {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ESUserDetailInfo *userInfo = [[ESUserDetailInfo alloc] init];
    userInfo.userId = [userDefaults stringForKey:@"UserId"];
    userInfo.userName = [userDefaults stringForKey:@"UserName"];
    userInfo.position = [userDefaults stringForKey:@"UserPosition"];
    userInfo.contactDescription = self.textView.text;
    
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
