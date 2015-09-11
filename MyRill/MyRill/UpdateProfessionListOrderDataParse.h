//
//  UpdateProfessionListOrderDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import <Foundation/Foundation.h>

@protocol UpdateProfessionListOrderDelegate <NSObject>

- (void)orderProfessionListSuccess:(id)context;
- (void)orderProfessionListFailure:(NSString *)errorMsg;

@end

@interface UpdateProfessionListOrderDataParse : NSObject

@property (nonatomic, weak) id<UpdateProfessionListOrderDelegate> delegate;

//更新业务列表顺序
- (void)updateProfessionListOrderWith:(NSArray *)professioinArray;

@end
