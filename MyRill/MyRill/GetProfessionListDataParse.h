//
//  GetProfessionListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import <Foundation/Foundation.h>

@protocol GetProfessionListDelegate <NSObject>

- (void)getProfessionListSuccess:(NSArray *)list;
- (void)getProfessionListFailure:(NSString *)errorMsg;

@end

@interface GetProfessionListDataParse : NSObject

@property (nonatomic, weak) id<GetProfessionListDelegate> delegate;

//获取业务列表
- (void)getProfessionList;

@end
