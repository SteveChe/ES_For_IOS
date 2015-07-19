//
//  UserInfoDataSource.h
//  MyRill
//
//  Created by Steve on 15/7/18.
//
//

#import <Foundation/Foundation.h>
@class ESUserInfo;
@interface UserInfoDataSource : NSObject
+(UserInfoDataSource *) shareInstance;
//从表中获取用户信息
-(ESUserInfo*) getUserByUserId:(NSString*)userId;


@end
