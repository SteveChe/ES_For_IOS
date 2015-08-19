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
@property(nonatomic, strong) NSString *userId;
/** 用户名*/
@property(nonatomic, strong) NSString *userName;
/** 头像URL*/
@property(nonatomic, strong) NSString *portraitUri;
/** 电话号码 */
@property(nonatomic, strong) NSString *phoneNumber;
/** 公司 */
@property(nonatomic, strong) NSString *enterprise;
/** 公司 职位*/
@property(nonatomic, strong) NSString *position;
/** type */
@property(nonatomic, strong) NSString *type;
//**  0 非手机通讯录联系人 , 1 手机通讯录联系人 , 2 联系人请求
@property(nonatomic, assign) NSNumber *status;

@end
