//
//  BMCLoginViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import "BMCLoginViewController.h"
#import "BMCLoginDataParse.h"
#import "BMCGetMainResourceListDataParse.h"
#import "ColorHandler.h"

@interface BMCLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *holdView;

@property (nonatomic, strong) BMCLoginDataParse *bmcLoginDP;
@property (nonatomic, strong) BMCGetMainResourceListDataParse *getMainResourceListDP;

@end

@implementation BMCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"RIIL-BMC";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnOnClicked:(UIButton *)sender {
    [self.bmcLoginDP loginBMCWithUserName:@"admin"
                                 password:@"riiladmin"];
}

- (IBAction)second:(UIButton *)sender {
    [self.getMainResourceListDP getMainResourceListWithTreeNodeId:@"00"
                                                        pageIndex:@"1"
                                                            state:@"all"
                                                       sortColumn:@"venderName"
                                                         sortType:@"asc"];
}

#pragma mark - setter&getter
- (BMCLoginDataParse *)bmcLoginDP {
    if (!_bmcLoginDP) {
        _bmcLoginDP = [[BMCLoginDataParse alloc] init];
    }
    
    return _bmcLoginDP;
}

- (BMCGetMainResourceListDataParse *)getMainResourceListDP {
    if (!_getMainResourceListDP) {
        _getMainResourceListDP = [[BMCGetMainResourceListDataParse alloc] init];
        
    }
    return _getMainResourceListDP;
}

- (void)setHoldView:(UIView *)holdView {
    _holdView = holdView;
    
    _holdView.layer.cornerRadius = 3.f;
    _holdView.layer.borderWidth = 1.f;
    _holdView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}


@end
