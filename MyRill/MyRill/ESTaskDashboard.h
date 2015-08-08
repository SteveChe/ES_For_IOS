//
//  ESTaskDashboard.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/27.
//
//

#import <Foundation/Foundation.h>

@interface ESTaskDashboard : NSObject

@property (nonatomic, strong) NSNumber *totalTask;
@property (nonatomic, strong) NSNumber *closedTask;
@property (nonatomic, strong) NSNumber *totalTaskInSelf;
@property (nonatomic, strong) NSNumber *overdueTaskInSelf;
@property (nonatomic, strong) NSArray *TaskInOriginatorList;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
