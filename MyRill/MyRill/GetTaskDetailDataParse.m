//
//  GetTaskDetailDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/18.
//
//

#import "GetTaskDetailDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation GetTaskDetailDataParse

- (void)getTaskDetailWithTaskID:(NSString *)taskID {
    [AFHttpTool getTaskDetailWithTaskID:taskID
                                success:^(id response) {
                                    NSDictionary *responseDic = (NSDictionary *)response;
                                    NSNumber* errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
                                    if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                        [self.delegate getTaskDetailFailure:nil];
                                        return;
                                    }
                                    
                                    NSInteger errorCode = [errorCodeNum integerValue];
                                    if (errorCode == 0) {
                                        NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
                                        ESTask *task = [[ESTask alloc] initWithDic:dataDic];
                                        [self.delegate getTaskDetailSuccess:task];
                                    } else {
                                        [self.delegate getTaskDetailFailure:nil];
                                    }
                                } failure:^(NSError *error) {
                                    [self.delegate getTaskDetailFailure:nil];
                                    NSLog(@"%@",[error debugDescription]);
                                }];
}

@end
