//
//  ChangePwdViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/6/24.
//
//

typedef enum {
    ESPwdChangeMold = 200,
    ESPhoneNumChangeMold
}ESUserMsgChangeType;

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : UIViewController

//需要在类初始化后进行设置，否则按照默认类型进行展示
@property (nonatomic, assign) ESUserMsgChangeType userMsgChangeType;

@end
