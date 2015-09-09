//
//  BMCGetMainResourceListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import <Foundation/Foundation.h>

@interface BMCGetMainResourceListDataParse : NSObject

- (void)getMainResourceListWithTreeNodeId:(NSString *)treeNodeId
                                pageIndex:(NSString *)pageIndex
                                    state:(NSString *)state
                               sortColumn:(NSString *)sortColumn
                                 sortType:(NSString *)sortType;

@end
