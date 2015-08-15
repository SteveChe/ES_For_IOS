//
//  AddTaskDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import "AddTaskDataParse.h"
#import "AFHttpTool.h"

@implementation AddTaskDataParse

- (void)addTaskWithModel:(ESTask *)task {
    [AFHttpTool addTaskWithModel:task
                         success:^(id response) {
                             NSDictionary *responseDic = (NSDictionary *)response;
                         } failure:^(NSError *error) {
                             NSLog(@"%@",[error debugDescription]);
                         }];
}

@end
