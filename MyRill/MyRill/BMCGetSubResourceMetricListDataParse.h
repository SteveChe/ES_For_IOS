//
//  BMCGetSubResourceMetricListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import <Foundation/Foundation.h>

@protocol BMCGetSubResourceMetricListDelegate <NSObject>

- (void)getSubResourceMetricListSucceed:(NSArray *)resultList;
- (void)getSubResourceMetricListFailed:(NSString *)errorMessage;

@end

@interface BMCGetSubResourceMetricListDataParse : NSObject

@property (nonatomic, weak) id<BMCGetSubResourceMetricListDelegate> delegate;

- (void)getSubResourceMetricListWithSubResId:(NSString *)subResId;

@end
