//
//  RCDAddFriendViewController.h
//  RCloudMessage
//
//  Created by Liv on 15/4/16.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RCUserInfo.h>
#import "AddContactDataParse.h"
@interface RCDAddFriendViewController : UIViewController<AddContactDelegate>

@property (nonatomic,strong) RCUserInfo *targetUserInfo;

@end
