//
//  LoginViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/6/7.
//
//

#import <UIKit/UIKit.h>
#import "LoginDataParse.h"

typedef enum
{
    e_login_status_normal = 0,
    e_login_status_logout = 1,
    e_login_status_invalid =2
}LOGIN_STATUS;

@interface LoginViewController : UIViewController<LoginDataDelegate>

//@property (nonatomic, assign) BOOL isStatus;
@property (nonatomic, assign) LOGIN_STATUS eStatus;
@end
