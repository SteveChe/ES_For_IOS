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
        
        NSArray *array = (NSArray *)dic[@"group_by_enterprise"];
        if (array != nil) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
            
            for (NSDictionary *dic in array) {
                ESTaskOriginatorInfo *taskOriginatorInfo = [[ESTaskOriginatorInfo alloc] init];
                taskOriginatorInfo.enterpriseId = [ColorHandler isNullOrNilNumber:dic[@"enterprise_id"]]?[NSNumber numberWithInt:-1]:dic[@"enterprise_id"];
                taskOriginatorInfo.enterpriseName = [ColorHandler isNullOrEmptyString:dic[@"enterprise_name"]]?@"":dic[@"enterprise_name"];
                taskOriginatorInfo.totalTask = dic[@"total"];
                [temp addObject:taskOriginatorInfo];
            }
            self.TaskInOriginatorList = [NSArray arrayWithArray:temp];
        }
    }
    
    return self;
}


@end


