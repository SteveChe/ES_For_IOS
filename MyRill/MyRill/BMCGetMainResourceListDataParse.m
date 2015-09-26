//
//  BMCGetMainResourceListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import "BMCGetMainResourceListDataParse.h"
#import "AFHttpTool.h"
#import "ResVO.h"

@implementation BMCGetMainResourceListDataParse

- (void)getMainResourceListWithTreeNodeId:(NSString *)treeNodeId
                                pageIndex:(NSString *)pageIndex
                                    state:(NSString *)state
                               sortColumn:(NSString *)sortColumn
                                 sortType:(NSString *)sortType {
//    [AFHttpTool getMainResourceListWithTreeNodeId:treeNodeId
//                                        pageIndex:pageIndex
//                                            state:state
//                                       sortColumn:sortColumn
//                                         sortType:sortType
//                                           sucess:^(id response) {
//                                               
//                                               NSDictionary *responseDic = (NSDictionary *)response;
//
//                                               if ([[responseDic allKeys] containsObject:@"error"]) {
//                                                   NSLog(@"请求有误!");
//                                               } else {
//                                                   NSArray *dataArray = (NSArray *)responseDic[@"resList"];
//                                                   
//                                                   NSMutableArray *resultList = [[NSMutableArray alloc] init];
//                                                   [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                                                       ResVO *resVO = [[ResVO alloc] initWithDic:(NSDictionary *)obj];
//                                                       [resultList addObject:resVO];
//                                                   }];
//                                                   
//                                                   [self.delegate getMainResourceListSucceed:resultList];
//                                               }
//                                           } failure:^(NSError *err) {
//                                               NSLog(@"%@",[err debugDescription]);
//                                               [self.delegate getMainResourceListFailed:@"获取失败"];
//                                           }];
}

@end
