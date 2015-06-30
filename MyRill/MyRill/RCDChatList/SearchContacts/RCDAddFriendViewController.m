//
//  RCDAddFriendViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/16.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import "RCDAddFriendViewController.h"
#import "AFHttpTool.h"
#import "UIImageView+WebCache.h"
@interface RCDAddFriendViewController ()
//@property (weak, nonatomic)  UILabel *lblName;
//@property (weak, nonatomic)  UIImageView *ivAva;

@end

@implementation RCDAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加好友";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UILabel* lblNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 54, 184, 21)];
    lblNameLabel.text = self.targetUserInfo.name;
    [self.view addSubview:lblNameLabel];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 11, 65, 65)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.targetUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    [self.view addSubview:imageView];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(8, 140, 584, 42);
    [button setBackgroundImage:[UIImage imageNamed:@"Voip-calling"] forState:UIControlStateNormal];
    button.titleLabel.text = @"添加好友";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)actionAddFriend:(id)sender {
//    [RCDHTTPTOOL requestFriend:_targetUserInfo.userId complete:^(BOOL result) {
//        if (result) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请求已发送" delegate:nil
//                                                      cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    }];
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
