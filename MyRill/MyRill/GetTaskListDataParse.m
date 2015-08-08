//
//  GetTaskListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/28.
//
//

#import "GetTaskListDataParse.h"
#import "DataParseDefine.h"
#import "ESTask.h"

@implementation GetTaskListDataParse

- (void)getTaskListWithIdentify:(NSString *)identify
                           type:(ESTaskListType)taskListType {
    
    [AFHttpTool getTaskListWithIdentify:identify
                                   type:taskListType
                                success:^(id response) {
                                    NSDictionary *responseDic = (NSDictionary *)response;
                                    NSLog(@"%@",response);
                                    NSNumber* errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
                                    if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
                                    {
                                        return ;
                                    }
                                    
                                    NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
                                    NSArray *list = dataDic[@"list"];
                                    NSNumber *count = dataDic[@"count"];
                                    NSMutableArray *resultList = [[NSMutableArray alloc] initWithCapacity:[count integerValue]];
                                    for (NSDictionary *dic in list) {
                                        ESTask *task = [[ESTask alloc] initWithDic:dic];
                                        [resultList addObject:task];
                                    }
                                    
                                    [self.delegate getTaskListSuccess:resultList];
                                } failure:^(NSError *error) {
                                    NSLog(@"%@",[error description]);
                                }];
}

@end
