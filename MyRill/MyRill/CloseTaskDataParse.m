//
//  CloseTaskDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/17.
//
//

#import "CloseTaskDataParse.h"
#import "AFHttpTool.h"

@implementation CloseTaskDataParse

- (void)closeTaskWithTaskID:(NSString *)taskID {
    [AFHttpTool closeTaskWithTaskID:taskID
                            success:^(id response) {
                                NSDictionary *responseDic = (NSDictionary *)response;
                                NSLog(@"****%@",responseDic);
                                [self.delegate closeTaskSuccess];
                            } failure:^(NSError *error) {
                                NSLog(@"%@",[error debugDescription]);
                            }];
}

@end
