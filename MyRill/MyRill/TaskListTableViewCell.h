//
//  TaskListTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class ESTask;

@interface TaskListTableViewCell : SWTableViewCell

- (void)updateTackCell:(ESTask *)task;

@end
