//
//  RootViewController.h
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum E_ENTERPRISE_CHAT_TYPE
{
    e_Enterprise_Chat_Enterprise = 0,
    e_Enterprise_Chat_Riil  = 1,
}E_ENTERPRISE_CHAT_TYPE;

@interface RootViewController : UIViewController
@property (nonatomic,strong) NSString* enterpriseId;
@property (nonatomic,assign) E_ENTERPRISE_CHAT_TYPE chatType;

@end