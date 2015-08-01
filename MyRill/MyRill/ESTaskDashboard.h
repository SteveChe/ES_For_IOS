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

//"group_by_enterprise": [
//                        {
//                            "enterprise_id": null,
//                            "total": 4,
//                            "enterprise_name": null
//                        },
//                        {
//                            "enterprise_id": 2,
//                            "total": 1,
//                            "enterprise_name": "锐捷网络"
//                        }
//                        ],
//"closed": 0,
//"total": 0,
//"open": 0,
//"in_charge": 0,
//"overdue": 0