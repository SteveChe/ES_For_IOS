//
//  ESTaskDashboard.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/27.
//
//

#import <Foundation/Foundation.h>
@class ESTaskMask;

@interface ESTaskDashboard : NSObject

@property (nonatomic, strong) ESTaskMask *totalTask;
@property (nonatomic, strong) ESTaskMask *closedTask;
@property (nonatomic, strong) ESTaskMask *totalTaskInSelf;
@property (nonatomic, strong) ESTaskMask *overdueTaskInSelf;
@property (nonatomic, strong) NSArray *TaskInOriginatorList;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
