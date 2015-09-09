//
//  BMCGetMainResourceListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import "BMCGetMainResourceListDataParse.h"
#import "AFHttpTool.h"


@implementation BMCGetMainResourceListDataParse

- (void)getMainResourceListWithTreeNodeId:(NSString *)treeNodeId
                                pageIndex:(NSString *)pageIndex
                                    state:(NSString *)state
                               sortColumn:(NSString *)sortColumn
                                 sortType:(NSString *)sortType {
    [AFHttpTool getMainResourceListWithTreeNodeId:treeNodeId
                                        pageIndex:pageIndex
                                            state:state
                                       sortColumn:sortColumn
                                         sortType:sortType
                                           sucess:^(id response) {
                                               NSDictionary *responseDic = (NSDictionary *)response;
                                           } failure:^(NSError *err) {
                                               NSLog(@"%@",[err debugDescription]);
                                           }];
}

@end
