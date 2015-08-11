//
//  MessageListViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import <UIKit/UIKit.h>

@interface MessageListViewController : UIViewController

@property (nonatomic, copy) NSString *taskID;

- (void)hideKeyboard;

@end
