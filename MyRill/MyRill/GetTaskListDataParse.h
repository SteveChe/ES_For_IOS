//
//  GetTaskListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/28.
//
//

#import <Foundation/Foundation.h>
#import "AFHttpTool.h"
@class ESTask;

@protocol TaskListDelegate <NSObject>

- (void)getTaskListSuccess:(NSArray *)taskList;

@end

@interface GetTaskListDataParse : NSObject

@property (nonatomic, weak) id<TaskListDelegate> delegate;

- (void)getTaskListWithIdentify:(NSString *)identify
                           type:(ESTaskListType)taskListType;

@end
