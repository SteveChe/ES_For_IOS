//
//  SignUpViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/6/8.
//
//

#import <UIKit/UIKit.h>
#import "SignUpDataParse.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,SignUpDataDelegate>
- (IBAction) signUpBtnOnClicked:(UIButton *)sender;
@end
