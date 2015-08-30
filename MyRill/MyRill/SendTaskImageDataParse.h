//
//  SendTaskImageDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/30.
//
//

#import <Foundation/Foundation.h>
@class ESTaskComment;

@protocol SendTaskImageDelegate <NSObject>

- (void)SendTaskCommentSuccess:(ESTaskComment *)taskComment;

@end

@interface SendTaskImageDataParse : NSObject

@property (nonatomic, weak) id<SendTaskImageDelegate> delegate;

- (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(ESTaskComment *)taskComment
                           images:(NSArray *)images;

@end
