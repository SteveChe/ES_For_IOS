//
//  SendTaskImageDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/30.
//
//

#import <Foundation/Foundation.h>
@class ESTaskComment;
@class ESImage;

@protocol SendTaskImageDelegate <NSObject>

- (void)sendTaskImageSuccess:(ESImage *)image;

@end

@interface SendTaskImageDataParse : NSObject

@property (nonatomic, weak) id<SendTaskImageDelegate> delegate;

- (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(ESTaskComment *)taskComment
                        imageData:(NSData *)imageData;

@end
