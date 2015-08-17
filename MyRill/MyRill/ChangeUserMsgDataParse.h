//
//  ChangeUserMsgDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import <Foundation/Foundation.h>
@class ESUserDetailInfo;

@protocol ChangeUserMsgDelegate <NSObject>

- (void)changeUserMsgSuccess:(ESUserDetailInfo *)userInfo;
- (void)changeUserMsgFailed:(NSString *)error;

@end

@interface ChangeUserMsgDataParse : NSObject

@property (nonatomic, weak) id<ChangeUserMsgDelegate> delegate;

- (void)changeUserMsgWithUserInfo:(ESUserDetailInfo *)userInfo;

@end
