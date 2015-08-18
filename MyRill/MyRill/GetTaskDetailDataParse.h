//
//  GetTaskDetailDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/18.
//
//

#import <Foundation/Foundation.h>
#import "ESTask.h"

@protocol GetTaskDetailDelegate <NSObject>

- (void)getTaskDetailSuccess:(ESTask *)task;

@end

@interface GetTaskDetailDataParse : NSObject

@property (nonatomic, weak) id<GetTaskDetailDelegate> delegate;

- (void)getTaskDetailWithTaskID:(NSString *)taskID;

@end
