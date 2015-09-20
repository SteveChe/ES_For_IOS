//
//  BMCGetResourceDetailDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCGetResourceDetailDataParse.h"
#import "AFHttpTool.h"

@implementation BMCGetResourceDetailDataParse

- (void)getResourceDetailWithResType:(NSString *)resType {
    [AFHttpTool getResourceDetailWithResType:resType
                                      sucess:^(id response) {
                                          NSDictionary *responseDic = (NSDictionary *)response;
                                          
                                          if ([[responseDic allKeys] containsObject:@"error"]) {
                                              NSLog(@"请求有误!");
                                          } else {
//                                              NSArray *dataArray = (NSArray *)responseDic[@"resInstList"];
//                                              [self.delegate getResourceDetailSucceed:resultList];
                                          }
                                      } failure:^(NSError *err) {
                                          ;
                                      }];
}

@end
