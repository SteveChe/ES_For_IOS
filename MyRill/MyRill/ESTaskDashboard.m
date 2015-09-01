//
//  ESTaskDashboard.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/27.
//
//

#import "ESTaskDashboard.h"
#import "ColorHandler.h"
#import "ESTaskOriginatorInfo.h"
#import "ESTaskMask.h"

@implementation ESTaskDashboard

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {

        if (dic[@"total"] == nil || [dic[@"total"] isKindOfClass:[NSNull class]]) {
            self.totalTask = nil;
        } else {
            self.totalTask = [[ESTaskMask alloc] initWithDic:dic[@"total"]];
        }
        if (dic[@"open"] == nil || [dic[@"open"] isKindOfClass:[NSNull class]]) {
            self.openTask = nil;
        } else {
            self.openTask = [[ESTaskMask alloc] initWithDic:dic[@"open"]];
        }
        if (dic[@"closed"] == nil || [dic[@"closed"] isKindOfClass:[NSNull class]]) {
            self.closedTask = nil;
        } else {
            self.closedTask = [[ESTaskMask alloc] initWithDic:dic[@"closed"]];
        }
        
        if (dic[@"in_charge"] == nil || [dic[@"in_charge"] isKindOfClass:[NSNull class]]) {
            self.totalTaskInSelf = nil;
        } else {
            self.totalTaskInSelf = [[ESTaskMask alloc] initWithDic:dic[@"in_charge"]];
        }
        
        if (dic[@"overdue"] == nil || [dic[@"overdue"] isKindOfClass:[NSNull class]]) {
            self.overdueTaskInSelf = nil;
        } else {
            self.overdueTaskInSelf = [[ESTaskMask alloc] initWithDic:dic[@"overdue"]];
        }
        
        NSArray *array = (NSArray *)dic[@"group_by_initiator"];
        if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
            
            for (NSDictionary *dic in array) {
                ESTaskOriginatorInfo *taskOriginatorInfo = [[ESTaskOriginatorInfo alloc] init];
                taskOriginatorInfo.assignmentNum = [ColorHandler isNullOrNilNumber:dic[@"assignment_num"]]?[NSNumber numberWithInt:-1]:dic[@"assignment_num"];
                taskOriginatorInfo.initiatorId = [ColorHandler isNullOrNilNumber:dic[@"initiator_id"]]?@"":dic[@"initiator_id"];
                taskOriginatorInfo.initiatorName = [ColorHandler isNullOrEmptyString:dic[@"initiator_name"]]?@"":dic[@"initiator_name"];
                taskOriginatorInfo.initiatorImgURL = [ColorHandler isNullOrEmptyString:dic[@"initiator_avatar"]]?nil:dic[@"initiator_avatar"];
                taskOriginatorInfo.isUpdate = [dic[@"has_update"] boolValue];
                [temp addObject:taskOriginatorInfo];
            }
            self.TaskInOriginatorList = [NSArray arrayWithArray:temp];
        }
    }
    
    return self;
}


@end


