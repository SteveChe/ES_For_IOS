//
//  DeleteProfessionDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import <Foundation/Foundation.h>

@protocol DeleteProfessionDelegate <NSObject>

- (void)deleteProfessionSuccess;
- (void)deleteProfessionFailure:(NSString *)errorMsg;

@end

@interface DeleteProfessionDataParse : NSObject

@property (nonatomic, weak) id<DeleteProfessionDelegate> delegate;

//删除业务
- (void)deleteProfessionWithId:(NSString *)professionId;

@end
