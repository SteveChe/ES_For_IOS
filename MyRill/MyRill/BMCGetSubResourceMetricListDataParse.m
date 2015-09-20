//
//  BMCGetSubResourceMetricListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCGetSubResourceMetricListDataParse.h"
#import "AFHttpTool.h"

@implementation BMCGetSubResourceMetricListDataParse

- (void)getSubResourceMetricListWithSubResId:(NSString *)subResId {
    [AFHttpTool getSubResourceMetricListWithSubResId:subResId
                                              sucess:^(id response) {
                                                  NSDictionary *responseDic = (NSDictionary *)response;
                                               
                                                  if ([[responseDic allKeys] containsObject:@"error"]) {
                                                      NSLog(@"请求有误!");
                                                  } else {
                                                      NSArray *dataArray = (NSArray *)responseDic[@"resMetricList"];
                                                   
                                                      NSLog(@"sub:%@",dataArray);
                                                   //                                              NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                                   //                                              [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                   //                                                  ResVO *resVO = [[ResVO alloc] initWithDic:(NSDictionary *)obj];
                                                   //                                                  [resultList addObject:resVO];
                                                   //                                              }];
                                                   
                                                   //[self.delegate getResourceDetailSucceed:resultList];
                                                  }
                                              } failure:^(NSError *err) {
                                                  ;
                                              }];
}

@end
