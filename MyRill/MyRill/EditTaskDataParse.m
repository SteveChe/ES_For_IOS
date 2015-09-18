//
//  EditTaskDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import "EditTaskDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation EditTaskDataParse

- (void)EditTaskWithTaskModel:(ESTask *)task {
    [AFHttpTool EditTaskWithTaskModel:task
                       success:^(id response) {
                           NSDictionary *responseDic = (NSDictionary *)response;
                           NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                           if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                               [self.delegate editTaskFailed:nil];
                               NSLog(@"请求有误！");
                               return;
                           }
                           
                           NSInteger errorCode = [errorCodeNum integerValue];
                           if (errorCode == 0) {
                               [self.delegate editTaskSuccess];
                           } else {
                               [self.delegate editTaskFailed:nil];
                           }
                       } failure:^(NSError *error) {
                           [self.delegate editTaskFailed:nil];
                           NSLog(@"%@",[error debugDescription]);
                       }];
}

@end
