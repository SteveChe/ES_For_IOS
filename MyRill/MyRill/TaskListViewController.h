//
//  TaskListViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"

@interface TaskListViewController : ESViewController

@property (nonatomic, copy) NSString *searchTerm;
@property (nonatomic, copy) NSString *title;
@end
