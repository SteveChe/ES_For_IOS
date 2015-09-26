//
//  BMCGetMainResourceMetricListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import <Foundation/Foundation.h>

@protocol BMCGetMainResourceMetricListDelegate <NSObject>

- (void)getMainResourceMetricListSucceed:(NSArray *)resultList;
- (void)getMainResourceMetricListFailed:(NSString *)errorMessage;

@end

@interface BMCGetMainResourceMetricListDataParse : NSObject

@property (nonatomic, weak) id<BMCGetMainResourceMetricListDelegate> delegate;

- (void)getMainResourceMetricListWithResId:(NSString *)resId;

@end
