//
//  BMCGetMainResourceListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import <Foundation/Foundation.h>

@protocol BMCGetMainResourceListDelegate <NSObject>

- (void)getMainResourceListSucceed:(NSArray *)resultList;
- (void)getMainResourceListFailed:(NSString *)errorMessage;

@end

@interface BMCGetMainResourceListDataParse : NSObject

@property (nonatomic, weak) id<BMCGetMainResourceListDelegate> delegate;

- (void)getMainResourceListWithTreeNodeId:(NSString *)treeNodeId
                                pageIndex:(NSString *)pageIndex
                                    state:(NSString *)state
                               sortColumn:(NSString *)sortColumn
                                 sortType:(NSString *)sortType;

@end
