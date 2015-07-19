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

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *qrView;
@property ( strong , nonatomic ) AVCaptureDevice *device;
@property ( strong , nonatomic ) AVCaptureDeviceInput *input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput *output;
@property ( strong , nonatomic ) AVCaptureSession *session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) NSTimer *scanLineTimer;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"扫描二维码";
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
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // Session
    _session = [[AVCaptureSession alloc] init];
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    //Start
    [_session startRunning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.scanLineTimer == nil) {
        [self moveUpAndDownLine];
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
}

// 扫描条上下滚动
- (void)moveUpAndDownLine {
//    CGRect readerFrame = self.view.frame;
//    CGSize viewFinderSize = CGSizeMake(self.view.frame.size.width - 80, self.view.frame.size.width - 80);
//    
//    CGRect scanLineframe = self.scanLineImageView.frame;
//    scanLineframe.origin.y =
//    (readerFrame.size.height - viewFinderSize.height)/2;
//    self.scanLineImageView.frame = scanLineframe;
//    self.scanLineImageView.hidden = NO;
//    
//    __weak __typeof(self) weakSelf = self;
//    
//    [UIView animateWithDuration:LINE_SCAN_TIME - 0.05
//                     animations:^{
//                         CGRect scanLineframe = weakSelf.scanLineImageView.frame;
//                         scanLineframe.origin.y =
//                         (readerFrame.size.height + viewFinderSize.height)/2 -
//                         weakSelf.scanLineImageView.frame.size.height;
//                         
//                         weakSelf.scanLineImageView.frame = scanLineframe;
//                     }
//                     completion:^(BOOL finished) {
//                         weakSelf.scanLineImageView.hidden = YES;
//                     }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //设置二维码的有效扫描区域
    CGSize size = self.view.bounds.size;
    CGRect cropRect = self.qrView.frame;
    _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                        cropRect.origin.x/size.width,
                                        cropRect.size.height/size.height,
                                        cropRect.size.width/size.width);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];

    self.navigationController.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
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
        
        [self.navigationController popViewControllerAnimated:YES];
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
