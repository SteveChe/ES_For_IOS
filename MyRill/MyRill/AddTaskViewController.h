//
//  AddTaskViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/7.
//
//

#import <UIKit/UIKit.h>

@interface AddTaskViewController : UIViewController

//如果是从对话模块创建的任务需要设置此属性
@property (nonatomic, copy) NSString *chatID;

@end
