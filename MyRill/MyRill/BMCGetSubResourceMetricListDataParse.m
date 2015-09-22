//
//  BMCGetSubResourceMetricListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCGetSubResourceMetricListDataParse.h"
#import "AFHttpTool.h"
#import "LogSummaryEventAlarmPojo.h"

@implementation BMCGetSubResourceMetricListDataParse

- (void)getSubResourceMetricListWithSubResId:(NSString *)subResId {
    [AFHttpTool getSubResourceMetricListWithSubResId:subResId
                                              sucess:^(id response) {
                                                  NSDictionary *responseDic = (NSDictionary *)response;
                                               
                                                  if ([[responseDic allKeys] containsObject:@"error"]) {
                                                      NSLog(@"请求有误!");
                                                  } else {
                                                      NSArray *dataArray = (NSArray *)responseDic[@"resMetricList"];
                                                      
                                                      NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                                      [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                          LogSummaryEventAlarmPojo *mainMetric = [[LogSummaryEventAlarmPojo alloc] initWithDic:obj];
                                                          if (![mainMetric.metricName isEqualToString:@""]) {
                                                              [resultList addObject:mainMetric];
                                                          }
                                                      }];
                                                   
                                                   [self.delegate getSubResourceMetricListSucceed:resultList];
                                                  }
                                              } failure:^(NSError *err) {
                                                  ;
                                              }];
}

@end
