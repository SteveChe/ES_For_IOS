//
//  ShowQRCodeViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/20.
//
//

#import "ShowQRCodeViewController.h"

@interface ShowQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodePNGView;

@end

@implementation ShowQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.qrCodeTitle;
    
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.qrCodePNGView.image = [UIImage imageWithData:data];
    [self.view layoutIfNeeded];
}

- (void)setQrCodePNGView:(UIImageView *)qrCodePNGView {
    _qrCodePNGView = qrCodePNGView;
    
    _qrCodePNGView.layer.cornerRadius = 4.f;
}

@end
