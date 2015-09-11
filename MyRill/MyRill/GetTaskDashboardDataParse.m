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
        if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
        {
            return ;
        }
        
        NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
        ESTaskDashboard *taskDashboard = [[ESTaskDashboard alloc] initWithDic:dataDic];
        [self.delegate getTaskDashboardSuccess:taskDashboard];
    } failure:^(NSError *error) {
        NSLog(@"%@",[error debugDescription]);

    }];
}

@end
