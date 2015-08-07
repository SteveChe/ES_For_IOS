//
//  ChatSettingViewController.h
//  MyRill
//
//  Created by Steve on 15/7/21.
//
//

#import <RongIMKit/RongIMKit.h>
#import "GetContactDetailDataParse.h"

@interface ChatSettingViewController : RCSettingViewController<ContactDetailDataDelegate>
@property (nonatomic, strong) NSMutableArray *userIdList;
@property (nonatomic, copy) NSString *conversationTitle;

@end
