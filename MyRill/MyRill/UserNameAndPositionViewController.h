//
//  UserNameAndPositionViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import <UIKit/UIKit.h>
#import "ChangeUserMsgDataParse.h"

@interface UserNameAndPositionViewController : UIViewController

@property (nonatomic, copy) NSString *nameAndPositionStr;

@property (nonatomic, assign) ESUserMsgType type;
@property (nonatomic, copy) NSString *userID;

@end
