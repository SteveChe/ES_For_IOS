//
//  TaskListViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"
#import "GetTaskListDataParse.h"

@interface TaskListViewController : ESViewController

@property (nonatomic, assign) ESTaskListType type;
@property (nonatomic, copy) NSString *identity;
//@property (nonatomic, copy) NSString *title;
@end
