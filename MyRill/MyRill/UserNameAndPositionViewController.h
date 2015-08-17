//
//  UserNameAndPositionViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import <UIKit/UIKit.h>
#import "ChangeUserMsgDataParse.h"
typedef enum : NSUInteger {
    ESUserMsgName = 300,
    ESUserMsgPosition
} ESUserMsg;

@interface UserNameAndPositionViewController : UIViewController

@property (nonatomic, assign) ESUserMsg type;
@property (nonatomic, copy) NSString *nameAndPositionStr;

@end
