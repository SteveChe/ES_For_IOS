//
//  ChangePwdViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/24.
//
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"密码修改";
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(commitBtnItemOnClicked:)];
    self.navigationItem.rightBarButtonItem = commitBtnItem;
}

#pragma mark - response events
- (void)commitBtnItemOnClicked:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
