//
//  ESUserInfo.h
//  MyRill
//
//  Created by Steve on 15/6/24.
//
//

#import <Foundation/Foundation.h>

@interface ESUserInfo : NSObject
/** 用户ID */
@property(nonatomic, strong) NSString* userId;
/** 用户名*/
@property(nonatomic, strong) NSString* userName;
/** 头像URL*/
@property(nonatomic, strong) NSString* portraitUri;
/** 电话号码 */
@property(nonatomic, strong) NSString* phoneNumber;
/** 公司 */
@property(nonatomic, strong) NSString* enterprise;

/** 公司 职位*/
@property(nonatomic, strong) NSString* position;


/** type */
@property(nonatomic, strong) NSString* type;

///** 全拼*/
//@property(nonatomic, strong) NSString* quanPin;
///** email*/
//@property(nonatomic, strong) NSString* email;
///**  0 请求添加, 1 好友
@property(nonatomic, assign) int status;

@end
