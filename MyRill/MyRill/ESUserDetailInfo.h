//
//  ESUserDetailInfo.h
//  MyRill
//
//  Created by Steve on 15/7/15.
//
//

#import <Foundation/Foundation.h>
#import "ESEnterpriseInfo.h"

@interface ESUserDetailInfo : NSObject
/** 用户ID */
@property(nonatomic, strong) NSString* userId;
/** 用户名*/
@property(nonatomic, strong) NSString* userName;
/** 头像URL*/
@property(nonatomic, strong) NSString* portraitUri;
/** 电话号码 */
@property(nonatomic, strong) NSString* phoneNumber;
/** 公司 */
@property(nonatomic, strong) ESEnterpriseInfo* enterprise;
/** 公司 职位*/
@property(nonatomic, strong) NSString* position;
/** 公司 部门*/
@property (nonatomic, strong) NSString *department;
/** 邮箱 地址*/
@property(nonatomic, strong) NSString* email;
/** 性别 */
@property(nonatomic, strong) NSString* gender;
/** 描述 */
@property(nonatomic, strong) NSString* contactDescription;
/** 个人二维码 */
@property(nonatomic, strong) NSString* qrcode;
/** 企业二维码 */
@property(nonatomic, strong) NSString* enterprise_qrcode;
/** 标签 */
@property(nonatomic, strong) NSMutableArray* tagDataArray;
/** 同事 */
@property(nonatomic, assign) BOOL bMember;
/** 联系人 */
@property(nonatomic, assign) BOOL bContact;

//designed initilize (dic not have tagDataArray&bMember&bContact)
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
