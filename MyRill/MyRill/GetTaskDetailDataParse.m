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
                                    if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
                                    {
                                        return ;
                                    }
                                    
                                    NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
                                    ESTask *task = [[ESTask alloc] initWithDic:dataDic];
                                    
                                    [self.delegate getTaskDetailSuccess:task];
                                } failure:^(NSError *error) {
                                    NSLog(@"%@",[error debugDescription]);
                                }];
}

@end
