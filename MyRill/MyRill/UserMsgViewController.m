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
#import "UserNameAndPositionViewController.h"
#import "ESNavigationController.h"
#import "UserDescriptionChangeViewController.h"

@interface UserMsgViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChangeUserImageDataDelegate, LogoutDataDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnCollection;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *UserEnterpriseLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userEnterpriseImg;
@property (weak, nonatomic) IBOutlet UILabel *UserPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *userDescriptionLbl;
@property (nonatomic, strong) MRProgressOverlayView *progress;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) CGRect oldframe;

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
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefaultes stringForKey:DEFAULTS_USERID];
    //更新头像缓存的url，若url有变化
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[userDefaultes stringForKey:DEFAULTS_USERAVATAR]] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    self.UserNameLbl.text = [userDefaultes stringForKey:DEFAULTS_USERNAME];
    self.UserEnterpriseLbl.text = [userDefaultes stringForKey:DEFAULTS_USERENTERPRISE];
    [self.userEnterpriseImg sd_setImageWithURL:[NSURL URLWithString:[userDefaultes stringForKey:DEFAULTS_ENTERPRISEAVATAR]] placeholderImage:nil];
    self.UserPositionLbl.text = [userDefaultes stringForKey:DEFAULTS_USERPOSITION];
    self.userDescriptionLbl.text = [@"简介：" stringByAppendingString:[userDefaultes stringForKey:DEFAULTS_USERDESCRIPTION]?[userDefaultes stringForKey:DEFAULTS_USERDESCRIPTION]:@""];
}

#pragma mark - ChangeUserImageDataDelegate methods
- (void)changeUserImageSuccess:(NSString *)avatar {
    //更新头像缓存的url
    NSURL *url = [NSURL URLWithString:avatar];
    [self.userIcon sd_setImageWithURL:url placeholderImage:nil];
    
    //将新的url存储到NSUserDefaults本地中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[ColorHandler isNullOrEmptyString:avatar]?@"":avatar
                     forKey:DEFAULTS_USERAVATAR];
    [userDefaults synchronize];
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
        
        [self.changeUserImageDP changeUseImageWithId:self.userId
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

- (void)tapInUserIcon:(UIGestureRecognizer *)sender {
    [self showImage:self.userIcon];
}

- (IBAction)buttonsOnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 902:
            {
                UserNameAndPositionViewController *nameAndPositionVC = [[UserNameAndPositionViewController alloc] init];
                nameAndPositionVC.title = @"用户名修改";
                nameAndPositionVC.type = ESUserMsgName;
                nameAndPositionVC.nameAndPositionStr = self.UserNameLbl.text;
                ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:nameAndPositionVC];
                [self.navigationController presentViewController:nav
                                                        animated:YES
                                                      completion:nil];
            }
            break;
            
        case 903:
            {
                UserNameAndPositionViewController *nameAndPositionVC = [[UserNameAndPositionViewController alloc] init];
                nameAndPositionVC.title = @"职位修改";
                nameAndPositionVC.type = ESUserMsgPosition;
                nameAndPositionVC.nameAndPositionStr = self.UserPositionLbl.text;
                ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:nameAndPositionVC];
                [self.navigationController presentViewController:nav
                                                        animated:YES
                                                      completion:nil];
            }
            break;
        case 904:
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *qrCodeStr = [userDefaults stringForKey:DEFAULTS_ENTERPRISEQRCODE];
                if (![ColorHandler isNullOrEmptyString:qrCodeStr]) {
                    ShowQRCodeViewController *showQRCodeVC = [[ShowQRCodeViewController alloc] init];
                    showQRCodeVC.qrCodeTitle = @"企业二维码";
                    showQRCodeVC.imageUrl = qrCodeStr;
                    [self.navigationController pushViewController:showQRCodeVC animated:YES];
                }
            }
            break;
        case 905:
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *qrCodeStr = [userDefaults stringForKey:DEFAULTS_USERQRCODE];
                if (![ColorHandler isNullOrEmptyString:qrCodeStr]) {
                    ShowQRCodeViewController *showQRCodeVC = [[ShowQRCodeViewController alloc] init];
                    showQRCodeVC.qrCodeTitle = @"个人二维码";
                    showQRCodeVC.imageUrl = [userDefaults stringForKey:DEFAULTS_USERQRCODE];
                    [self.navigationController pushViewController:showQRCodeVC animated:YES];
                }
            }
            break;
        case 906:
            {
                UserDescriptionChangeViewController *userDescriptionVC = [[UserDescriptionChangeViewController alloc] init];
                userDescriptionVC.title = @"个人简介修改";
                userDescriptionVC.descriptionStr = [self.userDescriptionLbl.text substringFromIndex:3];
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
