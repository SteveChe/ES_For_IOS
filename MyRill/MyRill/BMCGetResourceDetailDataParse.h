//
//  BMCGetResourceDetailDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import <Foundation/Foundation.h>

@protocol BMCGetResourceDetailDelegate <NSObject>

- (void)getResourceDetailSucceed:(NSArray *)resultList;
- (void)getResourceDetailFailed:(NSString *)errorMessage;

@end

@interface BMCGetResourceDetailDataParse : NSObject

@property (nonatomic, weak) id<BMCGetResourceDetailDelegate> delegate;

- (void)getResourceDetailWithResType:(NSString *)resType;

@end
