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
#import "CustomShowMessage.h"
@interface RCDAddFriendViewController ()
//@property (weak, nonatomic)  UILabel *lblName;
//@property (weak, nonatomic)  UIImageView *ivAva;
@property (strong,nonatomic) AddContactDataParse* addContactDataParse;
@end

@implementation RCDAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"联系人验证";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(backToLastPage)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    _addContactDataParse = [[AddContactDataParse alloc] init];
    _addContactDataParse.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //自定义rightBarButtonItem
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(rightBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* myName = [userDefaults stringForKey:@"UserName"];
    
    NSString* addFriendText = [NSString stringWithFormat:@"我是%@",myName];
    _addFriendTextField.text = addFriendText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- AddContactDelegate
-(void)addContactSucceed
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"已经发送"];
    [self performSelector:@selector(backToLastPage)
               withObject:nil
               afterDelay:1];
}

-(void)addContactFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}


#pragma mark - response events
/**
 *  重载右边导航按钮的事件
 *
 *  @param sender
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    if (_strUserId == nil || _strUserId == nil
        ||[_strUserId length] <= 0)
    {
        return;
    }
    [_addContactDataParse addContact:_strUserId];
}

-(void)backToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
