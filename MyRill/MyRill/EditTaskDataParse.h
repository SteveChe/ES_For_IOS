//
//  EditTaskDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import <Foundation/Foundation.h>
@class ESTask;

@protocol EditTaskDelegate <NSObject>

- (void)EditTaskSuccess;

@end

@interface EditTaskDataParse : NSObject

@property (nonatomic, weak) id<EditTaskDelegate> delegate;

- (void)EditTaskWithTaskModel:(ESTask *)task;

@end
