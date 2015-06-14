//
//  QRCodeViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/9.
//
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property ( strong , nonatomic ) AVCaptureDevice *device;
@property ( strong , nonatomic ) AVCaptureDeviceInput *input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput *output;
@property ( strong , nonatomic ) AVCaptureSession *session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer *preview;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"企业二维码扫描";
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
//    CGFloat screenHigh = bounds.size.height;
//    CGFloat screenWidth = bounds.size.width;
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [_output setRectOfInterest:CGRectMake (( 124 )/ screenHigh ,(( screenWidth - 220 )/ 2 )/ screenWidth, 220 / screenHigh , 220 / screenWidth)];
    CGSize size = self.view.bounds.size;
    CGRect cropRect = CGRectMake(40, 100, 240, 240);
    _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                              cropRect.origin.x/size.width,
                                              cropRect.size.height/size.height,
                                              cropRect.size.width/size.width);
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
