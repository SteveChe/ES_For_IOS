//
//  ESViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/9.
//
//

#import "ESViewController.h"
#import "ColorHandler.h"

@interface ESViewController ()

@end

@implementation ESViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"];
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
