//
//  ESNavigationController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/22.
//
//

#import "ESNavigationController.h"
#import "ColorHandler.h"

@interface ESNavigationController ()

@end

@implementation ESNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //bar背景颜色
    self.navigationBar.barTintColor = [ColorHandler colorFromHexRGB:@"FF5454"];
    //item颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    //设定title颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //取消translucent效果
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
