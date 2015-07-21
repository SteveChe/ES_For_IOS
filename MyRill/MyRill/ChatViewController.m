//
//  ChatViewController.m
//  MyRill
//
//  Created by Steve on 15/6/24.
//
//

#import "ChatViewController.h"
#import "ChatSettingViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"duihua_liaotianxiangqing"]style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(rightBarButtonItemPressed:)];

    self.navigationItem.rightBarButtonItem = rightButton;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  重载右边导航按钮的事件
 *
 *  @param sender
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    ChatSettingViewController* chatSettingVC = [[ChatSettingViewController alloc] init];
    chatSettingVC.conversationType = self.conversationType;
    chatSettingVC.targetId = self.targetId;
    [self.navigationController pushViewController:chatSettingVC animated:YES];

}

@end
