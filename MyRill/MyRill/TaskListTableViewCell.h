//
//  TaskListTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import <UIKit/UIKit.h>
@class ESTask;

@interface TaskListTableViewCell : UITableViewCell

- (void)updateTackCell:(ESTask *)task;

@end
