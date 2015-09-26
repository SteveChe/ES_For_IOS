//
//  BMCGetMainResourceMetricListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCGetMainResourceMetricListDataParse.h"
#import "AFHttpTool.h"
#import "ResMetricPojo.h"

@implementation BMCGetMainResourceMetricListDataParse

- (void)getMainResourceMetricListWithResId:(NSString *)resId {
    [AFHttpTool getMainResourceMetricListWithResId:resId
                                            sucess:^(id response) {
                                                NSDictionary *responseDic = (NSDictionary *)response;
                                                
                                                if ([[responseDic allKeys] containsObject:@"error"]) {
                                                    [self.delegate getMainResourceMetricListFailed:nil];
                                                    NSLog(@"请求有误!");
                                                } else {
                                                    NSArray *dataArray = (NSArray *)responseDic[@"resMetricList"];
                                                    
                                                    NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                                    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                        ResMetricPojo *mainMetric = [[ResMetricPojo alloc] initWithDic:obj];
                                                        if (![mainMetric.metricName isEqualToString:@""]) {
                                                            [resultList addObject:mainMetric];
                                                        }
                                                    }];
                                                    
                                                    [self.delegate getMainResourceMetricListSucceed:resultList];
                                                }
                                            } failure:^(NSError *err) {
                                                NSLog(@"%@",[err debugDescription]);
                                                [self.delegate getMainResourceMetricListFailed:nil];
                                            }];
}

@end
