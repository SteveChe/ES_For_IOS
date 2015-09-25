//
//  QRCodeViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/9.
//
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ColorHandler.h"
#import "RCDAddFriendViewController.h"
#import "RCDJoinEnterpriseViewController.h"
#import "CustomShowMessage.h"
#import "FollowEnterpriseDataParse.h"
#import "ESMenuViewController.h"
#import "AppDelegate.h"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate,FollowEnterpriseDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *qrView;
@property (weak, nonatomic) IBOutlet UIImageView *scanLineImageView;
@property ( strong , nonatomic ) AVCaptureDevice *device;
@property ( strong , nonatomic ) AVCaptureDeviceInput *input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput *output;
@property ( strong , nonatomic ) AVCaptureSession *session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) NSTimer *scanLineTimer;
@property (nonatomic, strong) FollowEnterpriseDataParse* followEnterpriseDataParse;
@property (nonatomic, strong) NSString* followEnterpriseId;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"扫描二维码";
    _followEnterpriseDataParse = [[FollowEnterpriseDataParse alloc] init];
    _followEnterpriseDataParse.followEnterPriseDelegate = self;
    
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"000000"];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(cancelAction:)];
    UIBarButtonItem *photo = [[UIBarButtonItem alloc] initWithTitle:@"相册"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(photoAction:)];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = photo;

    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (granted) {
                                             //继续
                                             [self configQRCode];
                                         } else {
                                             //用户拒绝，无法继续
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您拒绝了使用相机的授权"
                                                                                             message:@"请在设备的'设置-隐私-相机'中允许应用访问相机。"
                                                                                            delegate:self
                                                                                   cancelButtonTitle:@"确定"
                                                                                   otherButtonTitles:nil];
                                             [alert show];
                                         }
                                     }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
            // 继续
            [self configQRCode];
            break;
        case AVAuthorizationStatusDenied:
            //用户明确地拒绝授权
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未授权使用相机"
                                                                message:@"请在设备的'设置-隐私-相机'中允许应用访问相机。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        case AVAuthorizationStatusRestricted:
            //相机设备无法访问
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机设备无法访问"
                                                                message:@"请在设备的'设置-隐私-相机'中允许应用访问相机。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configQRCode {
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // Session
    _session = [[AVCaptureSession alloc] init];
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    
    if ([_output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        // Preview
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:_preview atIndex:0];
        
        //Start
        [_session startRunning];
    } else {
        NSLog(@"扫描类型错误!");
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //使动画开始时scanLineImageView位置完成初始化
    [self.view layoutIfNeeded];
    
    if (self.scanLineTimer == nil) {
        [self createTimer];
    }
}

#define LINE_SCAN_TIME  3.0     // 扫描线从上到下扫描所历时间（s）
- (void)createTimer {
    self.scanLineTimer =
    [NSTimer scheduledTimerWithTimeInterval:LINE_SCAN_TIME
                                     target:self
                                   selector:@selector(moveUpAndDownLine)
                                   userInfo:nil
                                    repeats:YES];
    [self moveUpAndDownLine];
}

// 扫描条上下滚动
- (void)moveUpAndDownLine {
    CGRect scanLineframe = self.scanLineImageView.frame;
    scanLineframe.origin.y = 0;
    self.scanLineImageView.frame = scanLineframe;
    self.scanLineImageView.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:LINE_SCAN_TIME - 0.05
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect scanLineframe = weakSelf.scanLineImageView.frame;
                         scanLineframe.origin.y = self.qrView.frame.size.height - weakSelf.scanLineImageView.frame.size.height;
                         
                         weakSelf.scanLineImageView.frame = scanLineframe;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.scanLineImageView.hidden = YES;
                     }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //设置二维码的有效扫描区域
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    CGRect cropRect = self.qrView.frame;
    _output.rectOfInterest = CGRectMake((cropRect.origin.y + 44) / screenRect.size.height,
                                        (cropRect.origin.x + 40)/ screenRect.size.width,
                                        cropRect.size.height / screenRect.size.height,
                                        cropRect.size.width / screenRect.size.width);
    //CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];

    self.navigationController.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
}

-(void)qrCodeStringParse:(NSString*)qrCodeString
{
    NSRange range1 = [qrCodeString rangeOfString:@"add_user_contact"];
    if (range1.length > 0)
    {
        NSRange rangeUserId = [qrCodeString rangeOfString:@"user_id="];
        if (rangeUserId.length > 0)
        {
//            int nstrLength = [qrCodeString length];
            NSString *strUserId = [qrCodeString substringFromIndex:rangeUserId.location+8];
//            NSLog(@"strUserId = %@",strUserId);
            RCDAddFriendViewController *addViewController = [[RCDAddFriendViewController alloc] init];
            addViewController.strUserId = strUserId;

            self.navigationController.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
            UITabBarController *tabbarVC = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:tabbarVC animated:YES];
            [tabbarVC.navigationController pushViewController:addViewController animated:YES];

        }
        return;
    }
    NSRange range2 = [qrCodeString rangeOfString:@"add_enterprise_contact"];
    if (range2.length > 0)
    {
        NSString* searchQuery = @"user_id=";
        NSRange rangeUserId = [qrCodeString rangeOfString:searchQuery];
        if (rangeUserId.length > 0)
        {
            NSString *strUserId = [qrCodeString substringFromIndex:rangeUserId.location+[searchQuery length]];
            RCDJoinEnterpriseViewController *joinEnterpriseViewController = [[RCDJoinEnterpriseViewController alloc] init];
            joinEnterpriseViewController.strUserId = strUserId;
            
            self.navigationController.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
            UITabBarController *tabbarVC = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:tabbarVC animated:YES];
            [tabbarVC.navigationController pushViewController:joinEnterpriseViewController animated:YES];
        }
        else
        {
            NSString* searchEnterpriseQuery = @"enterprise_id=";
            NSRange rangeEnterpriseId = [qrCodeString rangeOfString:searchEnterpriseQuery];
            if (rangeEnterpriseId.length > 0)
            {
                NSString *strEnterpriseId = [qrCodeString substringFromIndex:rangeEnterpriseId.location+[searchEnterpriseQuery length]];
                _followEnterpriseId = strEnterpriseId;
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"关注该企业" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
                [actionSheet showInView:self.view];
            }
            
        }
        
        return;
    }

}

#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        if (_followEnterpriseId != nil && ![_followEnterpriseId isEqual:[NSNull null]] && [_followEnterpriseId length] > 0)
        {
            [_followEnterpriseDataParse followEnterPriseWithEnterpriseId:_followEnterpriseId];
            [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
        }
    }
}


#pragma mark - FollowEnterpriseDelegate
-(void)followEnterpriseSucceed
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"关注企业成功！"];
    [[CustomShowMessage getInstance] hideWaitingIndicator];
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    ESMenuViewController* rootViewCtrl = (ESMenuViewController*)appDelegate.window.rootViewController;
//    [rootViewCtrl setSelectedIndex:2];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)followEnterpriseFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] > 0)
    {
        //停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"%@",stringValue);
        [self qrCodeStringParse:stringValue];
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - response events
- (void)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)photoAction:(UIBarButtonItem *)sender {
    
}

#pragma mark - setters&getters
- (void)setQrView:(UIView *)qrView {
    _qrView = qrView;
    
    _qrView.layer.borderColor = [UIColor whiteColor].CGColor;
    _qrView.layer.borderWidth = .5f;
}

@end
