//
//  SendTaskCommentDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "SendTaskCommentDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESTaskComment.h"

@implementation SendTaskCommentDataParse

- (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(NSString *)content {
    [AFHttpTool sendTaskCommentWithTaskID:taskID
                                  comment:content
                                  success:^(id response) {
                                      NSDictionary *responseDic = (NSDictionary *)response;
                                      NSNumber *errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
                                      if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                          [self.delegate sendTaskCommentFailure:nil];
                                          return;
                                      }
                                      
                                      NSInteger errorCode = [errorCodeNum integerValue];
                                      if (errorCode == 0) {
                                          NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
                                          ESTaskComment *taskComment = [[ESTaskComment alloc] initWithDic:dataDic];
                                          [self.delegate sendTaskCommentSuccess:taskComment];
                                      } else {
                                          [self.delegate sendTaskCommentFailure:nil];
                                      }
                                  } failure:^(NSError *error) {
                                      [self.delegate sendTaskCommentFailure:nil];
                                      NSLog(@"%@",[error debugDescription]);
                                  }];
}

@end
