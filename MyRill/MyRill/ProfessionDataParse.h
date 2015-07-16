//
//  ProfessionDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/6.
//
//

#import <Foundation/Foundation.h>

@protocol ProfessionDataDelegate <NSObject>

- (void)professionOperationSuccess:(id)context;
- (void)professionOperationFailure:(NSString *)errorMsg;

@optional
- (void)orderProfessionListResult:(id)context;

@end

@interface ProfessionDataParse : NSObject

@property (nonatomic, weak) id<ProfessionDataDelegate> delegate;

//获取业务列表
- (void)getProfessionList;
//添加业务
- (void)addProfessionWithName:(NSString *)name url:(NSString *)url;
//删除业务
- (void)deleteProfessionWithId:(NSString *)professionId;
//更新业务
- (void)updateProfessionWithId:(NSString *)professionId name:(NSString *)name url:(NSString *)url;
//更新业务列表顺序
- (void)updateProfessionListOrderWith:(NSArray *)professioinArray;

@end
