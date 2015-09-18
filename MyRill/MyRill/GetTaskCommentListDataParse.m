//
//  GetTaskCommentListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "GetTaskCommentListDataParse.h"
#import "AFHttpTool.h"
#import "ESTaskComment.h"
#import "DataParseDefine.h"

@implementation GetTaskCommentListDataParse

- (void)getTaskCommentListWithTaskID:(NSString *)taskID
                            listSize:(NSString *)size {
    [AFHttpTool getTaskCommentListWithTaskID:taskID
                                    listSize:size
                                     success:^(id response) {
                                         NSDictionary *responseDic = (NSDictionary *)response;
                                         NSNumber* errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
                                         if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                             return ;
                                         }
                                         
                                         NSInteger errorCode = [errorCodeNum integerValue];
                                         if (errorCode == 0) {
                                             NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
                                             NSArray *list = dataDic[@"list"];
                                             NSNumber *count = dataDic[@"count"];
                                             NSMutableArray *resultList = [[NSMutableArray alloc] initWithCapacity:[count integerValue]];
                                             for (NSDictionary *dic in list) {
                                                 ESTaskComment *task = [[ESTaskComment alloc] initWithDic:dic];
                                                 [resultList addObject:task];
                                             }
                                             
                                             [self.delegate getTaskCommentListSuccess:resultList];
                                         } else {
                                             [self.delegate getTaskCommentListFailure:nil];
                                         }
                                     } failure:^(NSError *error) {
                                         [self.delegate getTaskCommentListFailure:nil];
                                         NSLog(@"%@",[error debugDescription]);
                                     }];
}

@end
