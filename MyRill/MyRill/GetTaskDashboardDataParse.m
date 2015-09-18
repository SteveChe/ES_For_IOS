//
//  GetTaskDashboardDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/27.
//
//

#import "GetTaskDashboardDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESTaskDashboard.h"

@implementation GetTaskDashboardDataParse

- (void)getTaskDashboard {
    [AFHttpTool getTaskDashboardSuccess:^(id response) {
        NSDictionary *responseDic = (NSDictionary *)response;
        NSNumber* errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
        if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
            [self.delegate getTaskDashboardFailure:nil];
            return ;
        }
        
        NSInteger errorCode = [errorCodeNum integerValue];
        if (errorCode == 0) {
            NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
            ESTaskDashboard *taskDashboard = [[ESTaskDashboard alloc] initWithDic:dataDic];
            [self.delegate getTaskDashboardSuccess:taskDashboard];
        } else {
            [self.delegate getTaskDashboardFailure:nil];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",[error debugDescription]);
        [self.delegate getTaskDashboardFailure:nil];
    }];
}

@end
