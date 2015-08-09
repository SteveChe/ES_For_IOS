//
//  EditTaskDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import "EditTaskDataParse.h"
#import "AFHttpTool.h"

@implementation EditTaskDataParse

- (void)EditTaskWithTaskModel:(ESTask *)task {
    [AFHttpTool EditTaskWithTaskModel:task
                       success:^(id response) {
                           NSDictionary *responseDic = (NSDictionary *)response;
                       } failure:^(NSError *error) {
                           NSLog(@"%@",[error debugDescription]);
                       }];
}

@end
