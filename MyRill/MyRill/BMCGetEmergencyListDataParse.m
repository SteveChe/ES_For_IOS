//
//  BMCGetEmergencyListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/14.
//
//

#import "BMCGetEmergencyListDataParse.h"
#import "AFHttpTool.h"
#import "EventVO.h"

@implementation BMCGetEmergencyListDataParse

- (void)getEmergencyListWithViewType:(NSString *)viewType {
    [AFHttpTool getEmergencyListWithViewType:viewType
                                      sucess:^(id response) {
                                          NSDictionary *responseDic = (NSDictionary *)response;
                                          
                                          if ([[responseDic allKeys] containsObject:@"error"]) {
                                              [self.delegate getEmergencyeListFailed:nil];
                                              NSLog(@"请求有误!");
                                          } else {
                                              NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                              
                                              if (responseDic[@"eventList"] != nil && ![responseDic[@"eventList"] isKindOfClass:[NSNull class]] && [responseDic[@"eventList"] isKindOfClass:[NSArray class]]) {
                                                  NSArray *dataArray = (NSArray *)responseDic[@"eventList"];
                                                  
                                                  [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      EventVO *evnetVO = [[EventVO alloc] initWithDic:(NSDictionary *)obj];
                                                      [resultList addObject:evnetVO];
                                                  }];
                                              }
                                              
                                              [self.delegate getEmergencyListSucceed:resultList];
                                          }
                                      } failure:^(NSError *err) {
                                          NSLog(@"%@",[err debugDescription]);
                                          [self.delegate getEmergencyeListFailed:nil];
                                      }];
}

@end
