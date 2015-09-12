//
//  NameMailPositionViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import <UIKit/UIKit.h>
#import "ChangeUserMsgDataParse.h"
@class ESUserDetailInfo;

typedef enum : NSUInteger {
    ESUserMsgName = 300,
    ESUserMail,
    ESUserMsgPosition
} ESUserMsg;

@interface NameMailPositionViewController : UIViewController

@property (nonatomic, assign) ESUserMsg type;
@property (nonatomic, strong) ESUserDetailInfo *userDetailInfo;

@end
