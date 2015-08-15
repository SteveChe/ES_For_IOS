//
//  AddTaskDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import <Foundation/Foundation.h>
@class ESTask;

@protocol AddTaskDelegate <NSObject>

- (void)AddTaskSuccess;

@end

@interface AddTaskDataParse : NSObject

@property (nonatomic, weak) id<AddTaskDelegate> delegate;

- (void)addTaskWithModel:(ESTask *)task;

@end
