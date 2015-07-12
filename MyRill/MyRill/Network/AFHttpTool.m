//
//  AFHttpTool.m
//  MyRill
//
//  Created by Steve on 15/6/7.
//
//

#import "AFHttpTool.h"

#import "AFNetworking.h"

#define DEV_SERVER_ADDRESS @"http://120.25.249.144/"

#define ContentType @"text/json"

@implementation AFHttpTool

+ (void)requestWithMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSURL* baseURL = [NSURL URLWithString:DEV_SERVER_ADDRESS];
    //获得请求管理者
    AFHTTPRequestOperationManager* mgr = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
#ifdef ContentType
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
#endif
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
//    [mgr se]

    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if ([cookie.name  isEqual: @"csrftoken"] )
            {
                [mgr.requestSerializer setValue:cookie.value forHTTPHeaderField:@"X-Csrftoken"];
//                NSLog(@"csrftoken = %@",cookie.value);
            }
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            [mgr GET:url parameters:params
             success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                 if (success) {
                     success(responseObj);
                     NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject: cookiesData forKey: @"sessionCookies"];
                     [defaults synchronize];
                 }
             } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                 if (failure) {
                     failure(error);
                 }
             }];
            
        }
            break;
        case RequestMethodTypePost:
        {
            //POST请求
            [mgr POST:url parameters:params
              success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                  if (success) {
                      
                      NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      [defaults setObject: cookiesData forKey: @"sessionCookies"];
                      [defaults synchronize];

                      success(responseObj);
                      
//                      NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//                      for (NSHTTPCookie *cookie in cookies) {
//                          // Here I see the correct rails session cookie
//                          NSLog(@"cookie: %@", cookie);
//                      }
                      
                  }
              } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                  if (failure) {
                      failure(error);
                  }
              }];
        }
            break;
        default:
            break;
    }
}

//sign-up
+(void) signUpWithPhoneNum:(NSString *) phoneNum
                  password:(NSString *) password
          verificationCode:(NSString*) verificationCode
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"phone_number":phoneNum,@"password":password,@"verification_code":verificationCode};
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"api/accounts/sign-up/.json"
                           params:params
                          success:success
                          failure:failure];
}

//sign-out
+ (void)signOutSuccess:(void (^)(id))success
               failure:(void (^)(NSError *))failure {
    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                              url:@"/api/accounts/sign-out/.json"
                           params:nil
                          success:success
                          failure:failure];
}

//login
+(void) loginWithUserName:(NSString *) userName
                 password:(NSString *) password
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"username":userName,@"password":password};
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"api/accounts/sign-in/.json"
                           params:params
                          success:success
                          failure:failure];
}

//change password
+ (void)changePassword:(NSString *) oldPassword
           newPassword:(NSString *) newPassword
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"old_password":oldPassword,@"new_password":newPassword};
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"api/accounts/change-password/.json"
                           params:params
                          success:success
                          failure:failure];
}

+ (void)changePhoneNum:(NSString *)newPhoneNum
      verificationCode:(NSString *)code
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{@"new_phone_number":newPhoneNum,@"verification_code":code};
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"/api/accounts/change-phone-number/.json"
                           params:params
                          success:success
                          failure:failure];
}

//get verification code
+(void) getVerificationCode:(NSString *)phoneNum
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;
{
    NSDictionary *params = @{@"phone_number":phoneNum};
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"/api/accounts/send-verification-code/.json"
                           params:params
                          success:success
                          failure:failure];
}

+ (void)getProfessionSuccess:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {

    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                              url:@"api/professions/.json"
                           params:nil
                          success:success
                          failure:failure];
}

+ (void)addProfessionWithName:(NSString *)name
                          url:(NSString *)url
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{@"name":name,@"url":url};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"api/professions/.json"
                           params:params
                          success:success
                          failure:failure];
}

+ (void)deleteProfessionWithName:(NSString *)name
                             url:(NSString *)url
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{@"_method":@"DELETE"};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"api/professions/25/.json"
                           params:params
                          success:success
                          failure:failure];
}

//get RongCloud Token
+(void)getRongTokenSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                              url:@"/api/accounts/get-rong-token/.json"
                           params:nil
                          success:success failure:failure];
}

/******** 搜索联系人******
 参数：?q=keyWord
 请求方式：GET
 备注：如果keyWord为空，则返回所有联系人
 **/
+(void)searchContacts:(NSString*) keyWord success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"q":keyWord};

    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                              url:@"api/accounts/users/.json"
                           params:params
                          success:success failure:failure];
}

//addContacts
+(void) addContacts:(NSString *)userId success:(void (^)(id response))success
            failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/users/%@/add/.json",userId];


    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:strURL
                           params:nil
                          success:success failure:failure];
}
//acceptContacts
+(void) acceptContacts:(NSString *)userId success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"approved":[NSNumber numberWithInt:1]};
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/users/%@/accept/.json",userId];
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:strURL
                           params:params
                          success:success failure:failure];
}

//获取已经请求添加自己的联系人列表
+(void) getContactRequestSuccess:(void (^)(id response))success
                         failure:(void (^)(NSError *error))failure
{
    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                              url:@"/api/accounts/contact-requests/.json"
                           params:nil
                          success:success failure:failure];
}

/******** 联系人列表******
 请求方式：GET
 参数：无
 备注：该接口返回当前用户所有的联系人信息
 **/
+(void) getContactListSuccess:(void (^)(id response))success
                      failure:(void (^)(NSError *error))failure
{
    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                              url:@"/api/accounts/contacts/.json"
                           params:nil
                          success:success failure:failure];
}


@end
