//
//  AFHttpTool.h
//  MyRill
//
//  Created by Steve on 15/6/7.
//
//

#import <Foundation/Foundation.h>

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
+(void) requestWithMethod:(RequestMethodType)
methodType url : (NSString *)url
                   params:(NSDictionary *)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;

//sign-up
+(void) signUpWithPhoneNum:(NSString *) phoneNum
              password:(NSString *) password
                verificationCode:(NSString*) verificationCode
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure;

//login
+(void) loginWithUserName:(NSString *) userName
                  password:(NSString *) password
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure;
//change password
+(void) changePassword:(NSString *) oldPassword
                 newPassword:(NSString *) newPassword
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure;



@end
