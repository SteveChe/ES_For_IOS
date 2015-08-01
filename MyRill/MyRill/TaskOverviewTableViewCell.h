//
//  TaskOverviewTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import <UIKit/UIKit.h>
@class ESTaskOriginatorInfo;

@interface TaskOverviewTableViewCell : UITableViewCell

- (void)updateTaskDashboardCell:(ESTaskOriginatorInfo *)taskOriginatorInfo;

@end
