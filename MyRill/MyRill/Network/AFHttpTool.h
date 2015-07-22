//
//  AFHttpTool.h
//  MyRill
//
//  Created by Steve on 15/6/7.
//
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

@interface AFHttpTool : NSObject
/**
 *  发送一个请求
 *
 *  @param methodType   请求方法
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)requestWithMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure;
//sign-up
+(void) signUpWithPhoneNum:(NSString *) phoneNum
                  password:(NSString *) password
          verificationCode:(NSString*) verificationCode
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure;

+ (void)signOutSuccess:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

//login
+(void) loginWithUserName:(NSString *) userName
                 password:(NSString *) password
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure;

//业务
+ (void)getProfessionSuccess:(void (^)(id response))success
                     failure:(void (^)(NSError *error))failure;

+ (void)addProfessionWithName:(NSString *)name
                          url:(NSString *)url
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure;

+ (void)deleteProfessionWithId:(NSString *)professionId
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure;

+ (void)updateProfessioinWithId:(NSString *)professionId
                           name:(NSString *)name
                            url:(NSString *)url
                         success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;

+ (void)updateProfessioinListOrderWith:(NSArray *)professionArray
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;

//get RongCloud Token
+(void)getRongTokenSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure;

/******** 搜索联系人******
参数：?q=keyWord
请求方式：GET
备注：如果keyWord为空，则返回所有联系人
**/
+(void)searchContacts:(NSString*) keyWord success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure;

//addContacts
+(void) addContacts:(NSString *)userId success:(void (^)(id response))success
            failure:(void (^)(NSError* err))failure;

//acceptContacts
+(void) acceptContacts:(NSString *)userId success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure;

//获取已经请求添加自己的联系人列表
+(void) getContactRequestSuccess:(void (^)(id response))success
                         failure:(void (^)(NSError *error))failure;
/******** 联系人列表******
 请求方式：GET
 参数：无
 备注：该接口返回当前用户所有的联系人信息
 **/
+(void) getContactListSuccess:(void (^)(id response))success
                      failure:(void (^)(NSError *error))failure;


/******** 手机联系人列表******
 请求方式：POST
 参数：无
 备注：该接口返回当前手机联系人信息在ES系统注册的信息
 **/
+(void) getPhoneContactList:(NSArray *)phoneContacts success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;


/******** 获取联系人详情******
 请求方式：POST
 参数：无
 备注：该接口返回该联系人的详细信息
 **/
+(void) getContactDetail:(NSString*)userID success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//change password
+(void) changePassword:(NSString *) oldPassword
           newPassword:(NSString *) newPassword
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure;

+ (void)changePhoneNum:(NSString *)newPhoneNum
      verificationCode:(NSString *)code
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

//get verification code
+ (void)getVerificationCode:(NSString *)phoneNum
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;

+ (void)changeUserImageWithId:(NSString *)userId
                         data:(NSData *)data
                      success:(void (^)(AFHTTPRequestOperation *,id))success
                      failure:(void (^)(AFHTTPRequestOperation *,NSError *))failure;

@end
