//
//  UpdateProfessionDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import <Foundation/Foundation.h>
@class ESProfession;

@protocol UpdateProfessionDelegate <NSObject>

- (void)updateProfessionSuccess:(ESProfession *)profession;
- (void)updateProfessionFailure:(NSString *)errorMsg;

@end

@interface UpdateProfessionDataParse : NSObject

@property (nonatomic, weak) id<UpdateProfessionDelegate> delegate;

//更新业务
- (void)updateProfessionWithId:(NSString *)professionId name:(NSString *)name url:(NSString *)url;

@end
