//
//  SendTaskCommentDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import <Foundation/Foundation.h>
@class ESTaskComment;

@protocol SendTaskCommenDelegate <NSObject>

- (void)sendTaskCommentSuccess:(ESTaskComment *)taskComment;

@end

@interface SendTaskCommentDataParse : NSObject

@property (nonatomic, weak) id<SendTaskCommenDelegate> delegate;

- (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(NSString *)content;

@end
