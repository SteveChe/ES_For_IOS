//
//  BMCGetResourceMetricListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCGetResourceMetricListDataParse.h"
#import "AFHttpTool.h"
#import "LogSummaryEventAlarmPojo.h"

@implementation BMCGetResourceMetricListDataParse

- (void)getResourceMetricListWithResId:(NSString *)resId {
    [AFHttpTool getResourceMetricListWithResId:resId
                                        sucess:^(id response) {
                                            NSDictionary *responseDic = (NSDictionary *)response;
                                            
                                            if ([[responseDic allKeys] containsObject:@"error"]) {
                                                [self.delegate getResourceMetricListFailed:nil];
                                                NSLog(@"请求有误!");
                                            } else {
                                                NSArray *dataArray = (NSArray *)responseDic[@"resMetricList"];

                                                NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                                [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                    LogSummaryEventAlarmPojo *mainMetric = [[LogSummaryEventAlarmPojo alloc] initWithDic:obj];
//                                                    NSLog(@"!!!%@",obj);
                                                    if (![mainMetric.metricName isEqualToString:@""]) {
                                                        [resultList addObject:mainMetric];
                                                    }
                                                }];
                                                
                                                [self.delegate getResourceMetricListSucceed:resultList];
                                            }

                                        } failure:^(NSError *err) {
                                            NSLog(@"%@",[err debugDescription]);
                                            [self.delegate getResourceMetricListFailed:nil];
                                        }];
}

@end
