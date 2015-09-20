//
//  BMCGetResourceMetricListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import <Foundation/Foundation.h>

@protocol BMCGetResourceMetricListDelegate <NSObject>

- (void)getResourceMetricListSucceed:(NSArray *)resultList;
- (void)getResourceMetricListFailed:(NSString *)errorMessage;

@end

@interface BMCGetResourceMetricListDataParse : NSObject

@property (nonatomic, weak) id<BMCGetResourceMetricListDelegate> delegate;

- (void)getResourceMetricListWithResId:(NSString *)resId;

@end
