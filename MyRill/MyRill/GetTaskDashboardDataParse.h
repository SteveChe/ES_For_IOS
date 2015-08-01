//
//  GetTaskDashboardDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/27.
//
//

#import <Foundation/Foundation.h>
@class ESTaskDashboard;

@protocol TaskDashboardDelegate <NSObject>

- (void)getTaskDashboardSuccess:(ESTaskDashboard *)taskDashboard;

@end

@interface GetTaskDashboardDataParse : NSObject

@property (nonatomic, weak) id<TaskDashboardDelegate> delegate;

- (void)getTaskDashboard;

@end
