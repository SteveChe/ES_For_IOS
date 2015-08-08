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

@implementation ESTaskDashboard

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {

        if ([ColorHandler isNullOrNilNumber:dic[@"total"]]) {
            self.totalTask = [NSNumber numberWithInt:-1];
        } else {
            self.totalTask = dic[@"total"];
        }
        if ([ColorHandler isNullOrNilNumber:dic[@"closed"]]) {
            self.closedTask = [NSNumber numberWithInt:-1];
        } else {
            self.closedTask = dic[@"closed"];
        }
        
        if ([ColorHandler isNullOrNilNumber:dic[@"in_charge"]]) {
            self.totalTaskInSelf = [NSNumber numberWithInt:-1];
        } else {
            self.totalTaskInSelf = dic[@"in_charge"];
        }
        
        if ([ColorHandler isNullOrNilNumber:dic[@"overdue"]]) {
            self.overdueTaskInSelf = [NSNumber numberWithInt:-1];
        } else {
            self.overdueTaskInSelf = dic[@"overdue"];
        }
        
        NSArray *array = (NSArray *)dic[@"group_by_initiator"];
        if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
            
            for (NSDictionary *dic in array) {
                ESTaskOriginatorInfo *taskOriginatorInfo = [[ESTaskOriginatorInfo alloc] init];
                taskOriginatorInfo.assignmentNum = [ColorHandler isNullOrNilNumber:dic[@"assignment_num"]]?[NSNumber numberWithInt:-1]:dic[@"assignment_num"];
                taskOriginatorInfo.initiatorId = [ColorHandler isNullOrNilNumber:dic[@"initiator_id"]]?@"":dic[@"initiator_id"];
                taskOriginatorInfo.initiatorName = [ColorHandler isNullOrEmptyString:dic[@"initiator_name"]]?@"":dic[@"initiator_name"];
                [temp addObject:taskOriginatorInfo];
            }
            self.TaskInOriginatorList = [NSArray arrayWithArray:temp];
        }
    }
    
    return self;
}


@end


