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
+(void) changePassword:(NSString *) oldPassword
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

//get verification code
+(void) getVerificationCode:(NSString *)phoneNum
{
    NSDictionary *params = @{@"phone_number":phoneNum};
    [AFHttpTool requestWithMethod:RequestMethodTypePost url:@"/api/accounts/send-verification-code/.json" params:params success:nil failure:nil];
}

+ (void)getProfessionSuccess:(void (^)(id))success
                     failure:(void (^)(NSError *))failre {

    NSURL *url = [NSURL URLWithString:DEV_SERVER_ADDRESS];
    AFHTTPRequestOperationManager *afManager = [[AFHTTPRequestOperationManager alloc] init];
    
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if ([cookie.name  isEqual: @"csrftoken"] )
            {
                [afManager.requestSerializer setValue:cookie.value forHTTPHeaderField:@"X-Csrftoken"];
                //                NSLog(@"csrftoken = %@",cookie.value);
            }
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    [afManager GET:@"http://120.25.249.144/api/professions/.json"
        parameters:@{@"format":@"api"}
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"`````%@",responseObject);
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"`````%@",error);
           }];
    afManager.requestSerializer.HTTPShouldHandleCookies = YES;
    //    [mgr se]
}

@end
