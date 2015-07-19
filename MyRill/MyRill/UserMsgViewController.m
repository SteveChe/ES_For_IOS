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
#import "QRCodeViewController.h"

@interface UserMsgViewController () <LogoutDataDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
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
    
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置.png"]
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(settingBtnItemOnClicked:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/userIcon.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, @"/userIcon.png"];
        NSLog(@"--------- %@",filePath);
        self.userIcon.image = [UIImage imageWithContentsOfFile:filePath];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
//        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
//                                    CGRectMake(50, 120, 40, 40)];
//        
//        smallimage.image = image;
//        //加在视图中
//        [self.view addSubview:smallimage];
        
    } 
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LogoutDataParse delegate
- (void)logoutSuccess {
    [self showTips:@"注销成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [appDelegate changeWindow:loginVC];
}

- (void)logoutFail {
    [self showTips:@"注销失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES];
}

#pragma mark - response events
- (void)settingBtnItemOnClicked:(UIBarButtonItem *)sender {
    UserSettingViewController *settingVC = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
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
                                                          [self presentViewController:pickerImage animated:YES completion:nil];//进入照相界面
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}


- (IBAction)joinEnterpriseBtnOnClicked:(UIButton *)sender {
    QRCodeViewController *qrCodeVC = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrCodeVC animated:YES];
}

- (IBAction)logoutBtnOnClicked:(UIButton *)sender {
    [self.signOutDP logout];
}

#pragma mark - private methods
- (void)showTips:(NSString *)tip mode:(MRProgressOverlayViewMode)mode isDismiss:(BOOL)isDismiss
{
    [self.view addSubview:self.progress];
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
    
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
//    if (documentsPath ) {
//        <#statements#>
//    }
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",documentsPath, @"/userIcon.png"];
    _userIcon.image = [UIImage imageWithContentsOfFile:filePath];
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
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

@end
