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
//根据id从表中获取用户信息
-(ESUserInfo*) getUserByUserId:(NSString*)userId;

//从表中获取所有联系人的信息
-(NSArray*) getAddressBookContactList;

//从表中获取所有手机联系人的信息
-(NSArray*) getPhoneAddressBookContactList;

-(void) insertContactList:(NSArray*)contactList;

//删除用户表
-(void) clearAllUserInfo;

@end
