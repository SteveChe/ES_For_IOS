//
//  AddTaskDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import "AddTaskDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation AddTaskDataParse

- (void)addTaskWithModel:(ESTask *)task {
    [AFHttpTool addTaskWithModel:task
                         success:^(id response) {
                             NSDictionary *responseDic = (NSDictionary *)response;
                             NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                             if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                 [self.delegate addTaskFailed:nil];
                                 NSLog(@"请求有误！");
                                 return;
                             }
                             
                             NSInteger errorCode = [errorCodeNum integerValue];
                             if (errorCode == 0) {
                                 [self.delegate addTaskSuccess];
                             } else {
                                 [self.delegate addTaskFailed:nil];
                             }
                         } failure:^(NSError *error) {
                             [self.delegate addTaskFailed:nil];
                             NSLog(@"%@",[error debugDescription]);
                         }];
}

@end
