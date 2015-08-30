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
//                                      NSLog(@"````` %@",response);
                                      NSNumber *errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
                                      if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
                                      {
                                          return ;
                                      }
                                      
                                      NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
                                      ESTaskComment *taskComment = [[ESTaskComment alloc] initWithDic:dataDic];
                                      
                                      [self.delegate SendTaskCommentSuccess:taskComment];
                                      
                                  } failure:^(NSError *error) {
                                      NSLog(@"%@",[error debugDescription]);
                                  }];
}

@end
