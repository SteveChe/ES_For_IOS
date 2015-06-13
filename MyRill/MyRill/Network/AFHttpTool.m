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
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            [mgr GET:url parameters:params
             success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                 if (success) {
                     success(responseObj);                     
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
                      success(responseObj);
//                      NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                      NSString* strCookieUrl = [NSString stringWithFormat:@"%@%@",DEV_SERVER_ADDRESS,url];
                      NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:strCookieUrl]];
                      NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                      NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                      NSLog(@"%@",[operation.response allHeaderFields]  );
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
    NSDictionary *params = @{@"Phone number":phoneNum,@"Password":password,@"Verification code":verificationCode};
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

@end
