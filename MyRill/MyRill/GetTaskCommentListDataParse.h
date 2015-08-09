//
//  GetTaskCommentListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import <Foundation/Foundation.h>

@protocol GetTaskCommentListDelegate <NSObject>

- (void)getTaskCommentListSuccess:(NSArray *)taskCommentList;

@end

@interface GetTaskCommentListDataParse : NSObject

@property (nonatomic, weak) id<GetTaskCommentListDelegate> delegate;

- (void)getTaskCommentListWithTaskID:(NSString *)taskID
                            listSize:(NSString *)size;

@end
