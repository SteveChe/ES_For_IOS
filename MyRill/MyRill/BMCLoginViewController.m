//
//  BMCLoginViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import "BMCLoginViewController.h"
#import "BMCLoginDataParse.h"
#import "ColorHandler.h"
#import "BMCMainViewController.h"

@interface BMCLoginViewController () <BMCLoginDelegate>

@property (weak, nonatomic) IBOutlet UIView *holdView;

@property (nonatomic, strong) BMCLoginDataParse *bmcLoginDP;


@end

@implementation BMCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"RIIL-BMC";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - BMCLoginDelegate methods
- (void)loginSucceed:(NSDictionary *)loginDic {
    BMCMainViewController *bmcMainVC = [[BMCMainViewController alloc] init];
    [self.navigationController pushViewController:bmcMainVC animated:YES];
}

- (IBAction)loginBtnOnClicked:(UIButton *)sender {
    [self.bmcLoginDP loginBMCWithUserName:@"admin"
                                 password:@"riiladmin"];
}

#pragma mark - setter&getter
- (BMCLoginDataParse *)bmcLoginDP {
    if (!_bmcLoginDP) {
        _bmcLoginDP = [[BMCLoginDataParse alloc] init];
        _bmcLoginDP.delegate = self;
    }
    
    return _bmcLoginDP;
}

- (void)setHoldView:(UIView *)holdView {
    _holdView = holdView;
    
    _holdView.layer.cornerRadius = 3.f;
    _holdView.layer.borderWidth = 1.f;
    _holdView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}


@end
