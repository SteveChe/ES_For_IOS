//
//  ESMenuViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "ESMenuViewController.h"
#import "ESNavigationController.h"
#import "BusinessContainerViewController.h"
#import "ChatContainerViewController.h"
#import "ContactsContainerViewController.h"
#import "TaskContainerViewController.h"
#import "UserContainerViewController.h"
#import "ColorHandler.h"

@interface ESMenuViewController () <UITabBarControllerDelegate>

@end

@implementation ESMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [ColorHandler colorFromHexRGB:@"E9EEF2"];

    BusinessContainerViewController *businessVC = [[BusinessContainerViewController alloc] init];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"业务"
                                                             image:[UIImage imageNamed:@"icon"]
                                                     selectedImage:nil];
    businessVC.tabBarItem = tabBarItem;
    
    ChatContainerViewController *chatVC = [[ChatContainerViewController alloc] init];
    chatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                      image:[UIImage imageNamed:@"icon"]
                                              selectedImage:nil];

    ContactsContainerViewController *contactsVC = [[ContactsContainerViewController alloc] init];
    contactsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人"
                                                          image:[UIImage imageNamed:@"icon"]
                                                  selectedImage:nil];
    
    TaskContainerViewController *taskVC = [[TaskContainerViewController alloc] init];
    taskVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"任务"
                                                      image:[UIImage imageNamed:@"icon"]
                                              selectedImage:nil];
    
    UserContainerViewController *userVC = [[UserContainerViewController alloc] init];
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我"
                                                      image:[UIImage imageNamed:@"icon"]
                                              selectedImage:nil];
    
    self.viewControllers = [NSArray arrayWithObjects:
                                [[ESNavigationController alloc] initWithRootViewController:businessVC],
                                [[ESNavigationController alloc] initWithRootViewController:chatVC],
                                [[ESNavigationController alloc] initWithRootViewController:contactsVC],
                                [[ESNavigationController alloc] initWithRootViewController:taskVC],
                                [[ESNavigationController alloc] initWithRootViewController:userVC],nil];
    [self setSelectedIndex:0];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

@end
