//
//  BMCGetSubResourceListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/26.
//
//

#import "BMCGetSubResourceListDataParse.h"
#import "AFHttpTool.h"
#import "SubResPojo.h"

@implementation BMCGetSubResourceListDataParse

- (void)getSubResourceListWithResId:(NSString *)resId {
    [AFHttpTool getSubResourceListWithResId:resId
                                     sucess:^(id response) {
                                         NSDictionary *responseDic = (NSDictionary *)response;
                                         
                                         if ([[responseDic allKeys] containsObject:@"error"]) {
                                             [self.delegate getSubResourceListFailed:nil];
                                             NSLog(@"请求有误!");
                                         } else {
                                             NSDictionary *dataDic = responseDic[@"resInst"];
                                             NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:5];
                                             [resultDic setObject:dataDic[@"resId"] forKey:@"resId"];
                                             [resultDic setObject:dataDic[@"resName"] forKey:@"resName"];
                                             [resultDic setObject:dataDic[@"resIp"] forKey:@"resIp"];
                                             [resultDic setObject:dataDic[@"resType"] forKey:@"resType"];
                                             
                                             NSArray *dataArray = (NSArray *)dataDic[@"subResList"];
                                             
                                             NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                             [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                 SubResPojo *subResPojo = [[SubResPojo alloc] initWithDic:obj];
                                                 if (![subResPojo.subName isEqualToString:@""]) {
                                                     [resultList addObject:subResPojo];
                                                 }
                                             }];
                                             [resultDic setObject:resultList forKey:@"subResList"];
                                             
                                             [self.delegate getSubResourceListSucceed:resultDic];
                                         }
                                     } failure:^(NSError *err) {
                                         NSLog(@"%@",[err debugDescription]);
                                         [self.delegate getSubResourceListFailed:nil];
                                     }];
}

@end
