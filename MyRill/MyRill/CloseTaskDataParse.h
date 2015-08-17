//
//  CloseTaskDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/17.
//
//

#import <Foundation/Foundation.h>

@protocol CloseTaskDelegate <NSObject>

- (void)closeTaskSuccess;

@end

@interface CloseTaskDataParse : NSObject

@property (nonatomic, weak) id<CloseTaskDelegate> delegate;

- (void)closeTaskWithTaskID:(NSString *)taskID;

@end
