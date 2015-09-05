//
//  UpdateObserverAndChatidDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/5.
//
//

#import <Foundation/Foundation.h>
@class ESTask;

@protocol UpdateObserverAndChatidDelegate <NSObject>

- (void)updateObserverAndChatidSucces;

@end

@interface UpdateObserverAndChatidDataParse : NSObject

@property (nonatomic, weak) id<UpdateObserverAndChatidDelegate> delegate;

- (void)updateObserverAndChatidWith:(ESTask *)task;

@end
