//
//  ESMenuViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "ESMenuViewController.h"
#import "BusinessContainerViewController.h"
#import "ChatContainerViewController.h"
#import "ContactsContainerViewController.h"
#import "TaskContainerViewController.h"
#import "UserContainerViewController.h"

@interface ESMenuViewController () <UITabBarControllerDelegate>

@end

@implementation ESMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(100,100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    BusinessContainerViewController *businessVC = [[BusinessContainerViewController alloc] initWithCollectionViewLayout:flowLayout];
    businessVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"业务"
                                                          image:nil
                                                  selectedImage:nil];
    
    ChatContainerViewController *chatVC = [[ChatContainerViewController alloc] init];
    chatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                      image:nil
                                              selectedImage:nil];
    
    ContactsContainerViewController *contactsVC = [[ContactsContainerViewController alloc] init];
    contactsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人"
                                                          image:nil
                                                  selectedImage:nil];
    
    TaskContainerViewController *taskVC = [[TaskContainerViewController alloc] init];
    taskVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"任务"
                                                      image:nil
                                              selectedImage:nil];
    
    UserContainerViewController *userVC = [[UserContainerViewController alloc] init];
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我"
                                                      image:nil
                                              selectedImage:nil];
    
    self.viewControllers = [NSArray arrayWithObjects:
                                [[UINavigationController alloc] initWithRootViewController:businessVC],
                                [[UINavigationController alloc] initWithRootViewController:chatVC],
                                [[UINavigationController alloc] initWithRootViewController:contactsVC],
                                [[UINavigationController alloc] initWithRootViewController:taskVC],
                                [[UINavigationController alloc] initWithRootViewController:userVC],nil];
    [self setSelectedIndex:0];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
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
