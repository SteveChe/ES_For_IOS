//
//  SendTaskCommentDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "SendTaskCommentDataParse.h"
#import "AFHttpTool.h"

@implementation SendTaskCommentDataParse

- (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(NSString *)comment {
    [AFHttpTool sendTaskCommentWithTaskID:taskID
                                  comment:comment
                                  success:^(id response) {
                                      NSDictionary *responseDic = (NSDictionary *)response;
                                      NSLog(@"````` %@",response);
                                  } failure:^(NSError *error) {
                                      NSLog(@"%@",[error debugDescription]);
                                  }];
}

@end
