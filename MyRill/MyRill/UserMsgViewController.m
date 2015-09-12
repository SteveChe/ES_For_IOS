//
//  UserMsgViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "UserMsgViewController.h"
#import "ColorHandler.h"
#import "UserDefaultsDefine.h"
#import "UserSettingViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SignOutDataParse.h"
#import "MRProgress.h"
#import "QRCodeViewController.h"
#import "ChangeUserImageDataParse.h"
#import "ESNavigationController.h"
#import "ESUserDetailInfo.h"
#import "GetContactDetailDataParse.h"
#import "ShowQRCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "UserInfoDataSource.h"
#import "NameMailDepartmentViewController.h"
#import "ESNavigationController.h"
#import "UserDescriptionChangeViewController.h"
#import "GetContactDetailDataParse.h"
#import "RCDAddressBookEnterpriseDetailViewController.h"
#import "PushDefine.h"
#import "CustomShowMessage.h"

@interface UserMsgViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ContactDetailDataDelegate,ChangeUserImageDataDelegate, LogoutDataDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnCollection;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mailLbl;
@property (weak, nonatomic) IBOutlet UILabel *UserEnterpriseLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userEnterpriseImg;
@property (weak, nonatomic) IBOutlet UILabel *UserPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *userDescriptionLbl;
@property (nonatomic, strong) MRProgressOverlayView *progress;

@property (weak, nonatomic) IBOutlet UIImageView *enterpriseQRCodeImg;
@property (weak, nonatomic) IBOutlet UIImageView *enterpriseQRCodeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *personQRCodeImg;
@property (weak, nonatomic) IBOutlet UIImageView *personQRCodeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *enterpriseArrow;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) ESUserDetailInfo *userDetailInfo;
@property (nonatomic, assign) CGRect oldframe;

@property (nonatomic, strong) GetContactDetailDataParse *getContactDetailDP;
@property (nonatomic, strong) ChangeUserImageDataParse *changeUserImageDP;
@property (nonatomic, strong) SignOutDataParse *signOutDP;

@end

@implementation UserMsgViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    self.view.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"];
    
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置.png"]
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(settingBtnItemOnClicked:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePushEnterprise)
                                                 name:NOTIFICATION_PUSH_ENTERPRISE_ACCEPT
                                               object:nil];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [self.getContactDetailDP getContactDetail:[userDefaultes stringForKey:DEFAULTS_USERID]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_PUSH_ENTERPRISE_ACCEPT
                                                  object:nil];
}

#pragma mark - ContactDetailDataDelegate methods
- (void)getContactDetail:(ESUserDetailInfo *)userDetailInfo {
    self.userDetailInfo = userDetailInfo;
    //更新头像缓存的url，若url有变化
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:userDetailInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    self.UserNameLbl.text = userDetailInfo.userName;
    self.mailLbl.text = userDetailInfo.email;
    self.UserEnterpriseLbl.text = userDetailInfo.enterprise.enterpriseName;
    [self.userEnterpriseImg sd_setImageWithURL:[NSURL URLWithString:userDetailInfo.enterprise.portraitUri]
                              placeholderImage:nil];
    self.UserPositionLbl.text = userDetailInfo.department;
    self.userDescriptionLbl.text = [@"简介：" stringByAppendingString:userDetailInfo.contactDescription?userDetailInfo.contactDescription:@""];
    
    //若没有企业二维码信息，则不显示企业二维码占位图标和箭头
    if ([ColorHandler isNullOrEmptyString:userDetailInfo.enterprise_qrcode]) {
        self.enterpriseQRCodeImg.hidden = YES;
        self.enterpriseQRCodeArrow.hidden = YES;
    }
    
    //若没有个人二维码信息，则不显示个人二维码占位图标和箭头
    if ([ColorHandler isNullOrEmptyString:userDetailInfo.qrcode]) {
        self.personQRCodeImg.hidden = YES;
        self.personQRCodeArrow.hidden = YES;
    }
    
    if ([ColorHandler isNullOrEmptyString:userDetailInfo.enterprise.enterpriseName]) {
        self.enterpriseArrow.hidden = YES;
    }
}

- (void)getContactDetailFailed:(NSString *)errorMessage {
    NSLog(@"%@",errorMessage);
}

#pragma mark - ChangeUserImageDataDelegate methods
- (void)changeUserImageSuccess:(NSString *)avatar {
    //更新头像缓存的url
    NSURL *url = [NSURL URLWithString:avatar];
    [self.userIcon sd_setImageWithURL:url placeholderImage:nil];
    
//    //将新的url存储到NSUserDefaults本地中
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:[ColorHandler isNullOrEmptyString:avatar]?@"":avatar
//                     forKey:DEFAULTS_USERAVATAR];
//    [userDefaults synchronize];
    [self dismissProgress];
}

- (void)changeUserImageFailed:(NSString *)errorMsg {
    
}

#pragma mark - LogoutDataParse delegate
- (void)logoutSuccess {
    [self showTips:@"注销成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES];
//    [[UserInfoDataSource shareInstance] clearAllUserInfo];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:loginVC];
    [appDelegate changeWindow:nav];
}

- (void)logoutFail {
    [self showTips:@"注销失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES];
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

//    self.tabBarController.tabBarItem.enabled = NO;
//    [self.tabBarController.tabBar.items makeObjectsPerformSelector:@selector(setEnabled:) withObject:@NO];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //获取编辑框内部的图片，作为上传对象(上传图片不歪了也就)
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //先把图片转成NSData
        UIImage *img = [self scaleToSize:image size:CGSizeMake(300, 300)];
        NSData *data;
        if (UIImagePNGRepresentation(img) == nil)
        {
            data = UIImageJPEGRepresentation(img, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(img);
        }
        
        [self.changeUserImageDP changeUseImageWithId:self.userDetailInfo.userId
                                                data:data];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
//    MRActivityIndicatorView
    [self showTips:@"正在上传..." mode:MRProgressOverlayViewModeIndeterminateSmallDefault isDismiss:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - response events
- (void)settingBtnItemOnClicked:(UIBarButtonItem *)sender {
    UserSettingViewController *settingVC = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)updatePushEnterprise {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [self.getContactDetailDP getContactDetail:[userDefaultes stringForKey:DEFAULTS_USERID]];
}

- (void)tapInUserIcon:(UIGestureRecognizer *)sender {
    [self showImage:self.userIcon];
}

- (IBAction)buttonsOnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 902:
            {
                NameMailDepartmentViewController *nameAndPositionVC = [[NameMailDepartmentViewController alloc] init];
                nameAndPositionVC.title = @"用户名修改";
                nameAndPositionVC.type = ESUserMsgName;
                nameAndPositionVC.userDetailInfo = self.userDetailInfo;
                ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:nameAndPositionVC];
                [self.navigationController presentViewController:nav
                                                        animated:YES
                                                      completion:nil];
            }
            break;
        case 903:
        {
            NameMailDepartmentViewController *nameAndPositionVC = [[NameMailDepartmentViewController alloc] init];
            nameAndPositionVC.title = @"邮箱修改";
            nameAndPositionVC.type = ESUserMail;
            nameAndPositionVC.userDetailInfo = self.userDetailInfo;
            ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:nameAndPositionVC];
            [self.navigationController presentViewController:nav
                                                    animated:YES
                                                  completion:nil];
        }
            break;
        case 904:
        {
            if ([ColorHandler isNullOrEmptyString:self.UserEnterpriseLbl.text]) {
                return;
            }
            //企业详情
            RCDAddressBookEnterpriseDetailViewController* rcdAddressBookEnterpriseDetailVC = [[RCDAddressBookEnterpriseDetailViewController alloc] init];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString* enterpriseId = [userDefaultes stringForKey:DEFAULTS_USERENTERPRISE_ID];
            rcdAddressBookEnterpriseDetailVC.enterpriseId = enterpriseId;
            [self.navigationController pushViewController:rcdAddressBookEnterpriseDetailVC animated:YES];            
        }
            break;
        case 905:
            {
                NameMailDepartmentViewController *nameAndPositionVC = [[NameMailDepartmentViewController alloc] init];
                nameAndPositionVC.title = @"部门修改";
                nameAndPositionVC.type = ESUserMsgDepartment;
                nameAndPositionVC.userDetailInfo = self.userDetailInfo;
                ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:nameAndPositionVC];
                [self.navigationController presentViewController:nav
                                                        animated:YES
                                                      completion:nil];
            }
            break;
        case 906:
            {
                if (![ColorHandler isNullOrEmptyString:self.userDetailInfo.enterprise_qrcode]) {
                    ShowQRCodeViewController *showQRCodeVC = [[ShowQRCodeViewController alloc] init];
                    showQRCodeVC.qrCodeTitle = @"企业二维码";
                    showQRCodeVC.imageUrl = self.userDetailInfo.enterprise_qrcode;
                    [self.navigationController pushViewController:showQRCodeVC animated:YES];
                }
            }
            break;
        case 907:
            {
                if (![ColorHandler isNullOrEmptyString:self.userDetailInfo.qrcode]) {
                    ShowQRCodeViewController *showQRCodeVC = [[ShowQRCodeViewController alloc] init];
                    showQRCodeVC.qrCodeTitle = @"个人二维码";
                    showQRCodeVC.imageUrl = self.userDetailInfo.qrcode;
                    [self.navigationController pushViewController:showQRCodeVC animated:YES];
                }
            }
            break;
        case 908:
            {
                UserDescriptionChangeViewController *userDescriptionVC = [[UserDescriptionChangeViewController alloc] init];
                userDescriptionVC.title = @"个人简介修改";
                userDescriptionVC.userDetailInfo = self.userDetailInfo;
                ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:userDescriptionVC];
                [self.navigationController presentViewController:nav
                                                        animated:YES
                                                      completion:nil];
            }
            
        default:
            break;
    }
}

- (IBAction)userImg:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          //处理点击拍照
                                                          UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                                                          //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                          //    }
                                                          //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
                                                          //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
                                                          //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
                                                          UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化  
                                                          picker.delegate = self;  
                                                          picker.allowsEditing = YES;//设置可编辑  
                                                          picker.sourceType = sourceType;
                                                          if([[[UIDevice
                                                                currentDevice] systemVersion] floatValue]>=8.0) {
                                                              
                                                              self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                                                              
                                                          }
                                                          [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          //处理点击从相册选取
                                                          UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
                                                          if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                                              pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                                              pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                                                              
                                                          }  
                                                          pickerImage.delegate = self;  
                                                          pickerImage.allowsEditing = YES;
                                                          if([[[UIDevice
                                                                currentDevice] systemVersion] floatValue]>=8.0) {
                                                              
                                                              self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                                                              
                                                          }
                                                          pickerImage.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
                                                          //item颜色
                                                          pickerImage.navigationBar.tintColor = [UIColor whiteColor];
                                                          //设定title颜色
                                                          [pickerImage.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                                                          //取消translucent效果
                                                          pickerImage.navigationBar.translucent = NO;
                                                          [self presentViewController:pickerImage animated:YES completion:nil];//进入照相界面
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)showImage:(UIImageView *)avatarImageView {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//        [self.navigationController preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.oldframe];
    imageView.image = image;
    imageView.tag = 101;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:nil];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:101];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = self.oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (IBAction)joinEnterpriseBtnOnClicked:(UIButton *)sender {
    if (_userDetailInfo.enterprise!=nil && _userDetailInfo.enterprise.enterpriseId != nil && [_userDetailInfo.enterprise.enterpriseId length] > 0)
    {
        [[CustomShowMessage getInstance] showNotificationMessage:@"用户已加入一个企业"];
        return;
    }
    
    QRCodeViewController *qrCodeVC = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrCodeVC animated:YES];
}

- (IBAction)logoutBtnOnClicked:(UIButton *)sender {
    [self.signOutDP logout];
    [[RCIM sharedRCIM] logout];
}

#pragma mark - private methods
- (void)showTips:(NSString *)tip mode:(MRProgressOverlayViewMode)mode isDismiss:(BOOL)isDismiss
{
    [self.tabBarController.view addSubview:self.progress];
    [self.progress show:YES];
    self.progress.mode = mode;
    self.progress.titleLabelText = tip;
    if (isDismiss)
    {
        [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:1.8];
    }
}

- (void)dismissProgress
{
    if (self.progress)
    {
        [self.progress dismiss:YES];
    }
}

//缩小头像的尺寸
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - setters&getters
- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    
    _contentView.layer.borderWidth = 1.f;
    _contentView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setUserIcon:(UIImageView *)userIcon {
    _userIcon = userIcon;
    
    _userIcon.clipsToBounds = YES;
    _userIcon.layer.cornerRadius = 33.f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInUserIcon:)];
    [_userIcon addGestureRecognizer:tap];
}

- (void)setBtnCollection:(NSArray *)btnCollection {
    _btnCollection = btnCollection;
    
    for (UIButton *btn in _btnCollection) {
        btn.layer.cornerRadius = 18.f;
    }
}

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

- (GetContactDetailDataParse *)getContactDetailDP {
    if (!_getContactDetailDP) {
        _getContactDetailDP = [[GetContactDetailDataParse alloc] init];
        _getContactDetailDP.delegate = self;
    }
    
    return _getContactDetailDP;
}

- (ChangeUserImageDataParse *)changeUserImageDP {
    if (!_changeUserImageDP) {
        _changeUserImageDP = [[ChangeUserImageDataParse alloc] init];
        _changeUserImageDP.delegate = self;
    }
    
    return _changeUserImageDP;
}

- (SignOutDataParse *)signOutDP {
    if (!_signOutDP) {
        _signOutDP = [[SignOutDataParse alloc] init];
        _signOutDP.delegate = self;
    }
    
    return _signOutDP;
}

@end
