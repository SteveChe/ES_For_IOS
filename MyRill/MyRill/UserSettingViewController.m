//
//  UserSettingViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/24.
//
//

#import "UserSettingViewController.h"
#import "ChangePwdViewController.h"
#import "ChangPhoneNumViewController.h"

@interface UserSettingViewController ()

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"信息修改";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePwdBtnOnClicked:(UIButton *)sender {
    ChangePwdViewController *changePwdVC = [[ChangePwdViewController alloc] init];
    [self.navigationController pushViewController:changePwdVC animated:YES];
}

- (IBAction)changePhoneBtnOnClicked:(UIButton *)sender {
    ChangPhoneNumViewController *changePhoneNumVC = [[ChangPhoneNumViewController alloc] init];
    [self.navigationController pushViewController:changePhoneNumVC animated:YES];
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
