//
//  RCDUpdateNameViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/2.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import "RCDUpdateNameViewController.h"
#import "CustomShowMessage.h"

#import <RongIMLib/RongIMLib.h>
//#import "UIColor+RCColor.h"
@interface RCDUpdateNameViewController()


@end


@implementation RCDUpdateNameViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"讨论组名称";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClicked:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    
    self.tfName.text = self.displayText;
    
}

-(void) backBarButtonItemClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rightBarButtonItemClicked:(id) sender
{
    [self.tfName resignFirstResponder];
    //保存讨论组名称
    if(self.tfName.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入讨论组名称!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //保存设置
    [[RCIMClient sharedRCIMClient] setDiscussionName:self.targetId name:self.tfName.text success:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[CustomShowMessage getInstance] showNotificationMessage:@"讨论组修改名称成功！"];
                [self performSelector:@selector(backToLastPage)
                           withObject:nil
                           afterDelay:1];
            });
        });
        
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[CustomShowMessage getInstance] showNotificationMessage:@"讨论组修改名称失败！"];
            });
        
    });

    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //收起键盘
    [self.tfName resignFirstResponder];
}

-(void)backToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
