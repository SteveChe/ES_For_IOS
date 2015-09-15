//
//  GetProfessionDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/15.
//
//

#import <Foundation/Foundation.h>
@class ESProfession;

@protocol GetProfessionDelegate <NSObject>

- (void)getProfessionSuccess:(ESProfession *)profession;
- (void)getProfessionFailure:(NSString *)errorMsg;

@end

@interface GetProfessionDataParse : NSObject

@property (nonatomic,weak) id<GetProfessionDelegate> delegate;

- (void)getProfessionWithProfessionID:(NSString *)professionID;

@end
