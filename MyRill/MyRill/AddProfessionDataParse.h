//
//  AddProfessionDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import <Foundation/Foundation.h>
@class ESProfession;

@protocol AddProfessionDataDelegate <NSObject>

- (void)addProfessionOperationSuccess:(ESProfession *)profession;
- (void)addProfessionOperationFailure:(NSString *)errorMsg;

@end

@interface AddProfessionDataParse : NSObject

@property (nonatomic, weak) id<AddProfessionDataDelegate> delegate;

//添加业务
- (void)addProfessionWithName:(NSString *)name url:(NSString *)url;

@end
