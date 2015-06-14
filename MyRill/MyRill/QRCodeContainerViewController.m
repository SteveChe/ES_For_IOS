//
//  QRCodeContainerViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "QRCodeContainerViewController.h"
#import "QRCodeViewController.h"
#import "Masonry.h"

@interface QRCodeContainerViewController ()

@end

@implementation QRCodeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    QRCodeViewController *qrCodeVC = [[QRCodeViewController alloc] init];
    [self addChildViewController:qrCodeVC];
    
    
    qrCodeVC.view.frame = CGRectMake(40, 80, 200, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
