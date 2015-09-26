//
//  BMCGetSubResourceListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/26.
//
//

#import <Foundation/Foundation.h>

@protocol BMCGetSubResourceListDelegate <NSObject>

- (void)getSubResourceListSucceed:(NSDictionary *)resultDic;
- (void)getSubResourceListFailed:(NSString *)errorMessage;

@end

@interface BMCGetSubResourceListDataParse : NSObject

@property (nonatomic, weak) id<BMCGetSubResourceListDelegate> delegate;

- (void)getSubResourceListWithResId:(NSString *)resId;

@end
