//
//  AFHttpTool.m
//  MyRill
//
//  Created by Steve on 15/6/7.
//
//

#import "AFHttpTool.h"
#import "AFNetworking.h"
#import "ESProfession.h"
#import "ESTask.h"
#import "ESUserInfo.h"
#import "ESUserDetailInfo.h"
#import "ColorHandler.h"
#import "UserDefaultsDefine.h"
#import "ESTaskComment.h"

#define DEV_SERVER_ADDRESS @"http://120.25.249.144/"
#define ContentType @"text/json"

@implementation AFHttpTool

+ (void)requestWithMethod:(RequestMethodType)methodType protocolType:(RequestProtocolType) protocolType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSURL* baseURL = [NSURL URLWithString:DEV_SERVER_ADDRESS];
    //获得请求管理者
    AFHTTPRequestOperationManager* mgr = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    if (protocolType == RequestProtocolTypeJson)
    {
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    }
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
                     [AFHttpTool parseErrorType:error operation:operation];
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
                      [AFHttpTool parseErrorType:error operation:operation];
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
                  userName:(NSString*) userName
                  password:(NSString *) password
          verificationCode:(NSString*) verificationCode
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"phone_number":phoneNum,@"username":userName,@"password":password,@"verification_code":verificationCode};
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:@"api/accounts/sign-up/.json"
                           params:params
                          success:success
                          failure:failure];
}

//sign-out
+ (void)signOutSuccess:(void (^)(id))success
               failure:(void (^)(NSError *))failure {
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
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
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
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
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
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
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
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
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:@"/api/accounts/send-verification-code/.json"
                           params:params
                          success:success
                          failure:failure];
}

+ (void)getProfessionSuccess:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {

    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:@"api/professions/.json"
                           params:nil
                          success:success
                          failure:failure];
}

+ (void)getProfessionWithProfessionID:(NSString *)professionID
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError* err))failure {
    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                     protocolType:RequestProtocolTypeText
                              url:[NSString stringWithFormat:@"/api/professions/%@/.json",professionID]
                           params:nil
                          success:success
                          failure:failure];
}

+ (void)addProfessionWithName:(NSString *)name
                          url:(NSString *)url
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{@"name":name,@"url":url};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:@"api/professions/.json"
                           params:params
                          success:success
                          failure:failure];
}

+ (void)deleteProfessionWithId:(NSString *)professionId
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{@"_method":@"DELETE"};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:[NSString stringWithFormat:@"api/professions/%@/.json",professionId]
                           params:params
                          success:success
                          failure:failure];
}

+ (void)updateProfessioinWithId:(NSString *)professionId
                           name:(NSString *)name
                            url:(NSString *)url
                        success:(void (^)(id))success
                        failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{@"name":name,@"url":url};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:[NSString stringWithFormat:@"api/professions/%@/.json",professionId]
                           params:params
                          success:success
                          failure:failure];
}

+ (void)updateProfessioinListOrderWith:(NSArray *)professionArray
                               success:(void (^)(id))success
                               failure:(void (^)(NSError *))failure {
    NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:professionArray.count];
    
    
    for (int i = 0; i < professionArray.count; i ++) {
        ESProfession *profession = (ESProfession *)professionArray[i];
        NSDictionary *orderDic = @{@"id":[profession.sub_id stringValue],@"order":[NSString stringWithFormat:@"%d",(i + 1)]};
        [paramArray addObject:orderDic];
    }
    NSLog(@"%@",paramArray);
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString* strJson = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"_content":strJson,@"_content_type":@"application/json"};

    [AFHttpTool requestWithMethod:RequestMethodTypePost
                     protocolType:RequestProtocolTypeText
                              url:@"/api/professions/sort/.json"
                           params:params
                          success:success
                          failure:failure];
}

//get RongCloud Token
+(void)getRongTokenSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:@"/api/chat/get-rong-token/.json"
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

    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:@"api/accounts/users/.json"
                           params:params
                          success:success failure:failure];
}

//addContacts
+(void) addContacts:(NSString *)userId success:(void (^)(id response))success
            failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/users/%@/add/.json",userId];


    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
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
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:strURL
                           params:params
                          success:success failure:failure];
}

//deleteContacts
+(void) deleteContact:(NSString *)userId success:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/users/%@/delete/.json",userId];
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:strURL
                           params:nil
                          success:success failure:failure];
}

//获取已经请求添加自己的联系人列表
+(void) getContactRequestSuccess:(void (^)(id response))success
                         failure:(void (^)(NSError *error))failure
{
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
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
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:@"/api/accounts/contacts/.json"
                           params:nil
                          success:success failure:failure];
}

/******** 手机联系人列表******
 请求方式：POSt
 参数：无
 备注：该接口返回当前手机联系人信息在ES系统注册的信息
 **/
+(void) getPhoneContactList:(NSArray *)phoneContacts success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
//    NSDictionary *params = @{@"_content":phoneContacts,@"_content_type":@"application/json"};

//    NSString* phoneContactArrayStr = @"";
    
//    for (int i = 0 ; i<100; i++)
//    {
//        NSString* strTemp =  [phoneContacts objectAtIndex:i];
//
//        if (i == 0)
//        {
//            phoneContactArrayStr = [NSString stringWithFormat:@"[%@",strTemp ];
//        }
//        else
//        {
//            phoneContactArrayStr = [NSString stringWithFormat:@"%@,%@",phoneContactArrayStr,strTemp ];
//        }
//    }
//    phoneContactArrayStr = [NSString stringWithFormat:@"%@]",phoneContactArrayStr ];

//    NSString* phoneContactArrayStr = @"[18600562102,18612887327]";
    NSError* error;
    NSString *cartJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:phoneContacts
                                                                                        options:NSJSONWritingPrettyPrinted
                                                                                          error:&error]
                                               encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"_content":cartJSON,@"_content_type":@"application/json"};

    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:@"/api/accounts/phone-contacts/.json"
                           params:params
                          success:success
                          failure:failure];
}

/******** 获取联系人详情******
 请求方式：GET
 参数：无
 备注：该接口返回该联系人的详细信息
 **/
+(void) getContactDetail:(NSString*)userID
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/users/%@/.json",userID];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:strURL
                           params:nil
                          success:success failure:failure];
}

+ (void)getTaskDashboardSuccess:(void (^)(id))success
                        failure:(void (^)(NSError *))failure {
    NSString *strURL = @"/api/assignments/dashboard/.json";
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:strURL
                           params:nil
                          success:success
                          failure:failure];
}

+ (void)addTaskWithModel:(ESTask *)task
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    NSMutableArray *observerArray = [[NSMutableArray alloc] initWithCapacity:task.observers.count];
    for (ESUserInfo *user in task.observers) {
        [observerArray addObject:user.userId];
    }
    
    NSDictionary *param = nil;
    if ([task.endDate isEqualToString:@""]) {
        param = @{@"title":task.title,
                  @"description":task.taskDescription,
                  @"person_in_charge":task.personInCharge.userId,
                  @"observers":observerArray,
                  @"chat_id":task.chatID
                  };
    } else {
        param = @{@"title":task.title,
                  @"description":task.taskDescription,
                  @"due_date":task.endDate,
                  @"person_in_charge":task.personInCharge.userId,
                  @"observers":observerArray,
                  @"chat_id":task.chatID
                  };
    }
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeJson
                              url:@"/api/assignments/.json"
                           params:param
                          success:success
                          failure:failure];
}

+ (void)getTaskListWithIdentify:(NSString *)identify
                           type:(ESTaskListType)taskListType
                        success:(void (^)(id))success
                        failure:(void (^)(NSError *))failure {
    NSString *strURL = @"/api/assignments/.json";
    NSDictionary *param = nil;
    switch (taskListType) {
        //status:0-进行中,1-关闭
        case ESTaskListWithChatId:
            param = @{@"chat_id":identify,@"status":@"0"};
            break;
        case ESTaskListWithChatIdSubEnd:
            param = @{@"chat_id":identify,@"status":@"1"};
            break;
        case ESTaskListWithInitiatorId:
            param = @{@"initiator_id":identify,@"status":@"0"};
            break;
        case ESTaskListWithPersonInChargeId:
            param = @{@"person_in_charge_id":identify,@"status":@"0"};
            break;
        case ESTaskListStatus:
            param = @{@"status":identify};
            break;
        case ESTaskOverdue:
            param = @{@"overdue":@"1",@"person_in_charge_id":identify,@"status":@"0"};
            break;
        case ESTaskListQ:
            param = @{@"q":identify};
            break;
        default:
            break;
    }
    
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:strURL
                           params:param
                          success:success
                          failure:failure];
}

+ (void)getTaskDetailWithTaskID:(NSString *)taskID
                        success:(void (^)(id))success
                        failure:(void (^)(NSError *))failure {
    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                     protocolType:RequestProtocolTypeText
                              url:[NSString stringWithFormat:@"/api/assignments/%@/.json",taskID]
                           params:nil
                          success:success
                          failure:failure];
}

+ (void)updateObserverAndChatidWith:(ESTask *)task
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *error))failure {
    NSMutableArray *observerArray = [[NSMutableArray alloc] initWithCapacity:task.observers.count];
    [task.observers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ESUserInfo *userInfo = (ESUserInfo *)obj;
        [observerArray addObject:userInfo.userId];
    }];
    
    NSDictionary *param = @{@"observers":observerArray,
                            @"chat_id":task.chatID};

    [AFHttpTool requestWithMethod:RequestMethodTypePost
                     protocolType:RequestProtocolTypeJson
                              url:[NSString stringWithFormat:@"/api/assignments/%@/update-observer/.json",task.taskID]
                           params:param
                          success:success
                          failure:failure];
}

+ (void)EditTaskWithTaskModel:(ESTask *)task
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure {
    NSMutableArray *observerArray = [[NSMutableArray alloc] initWithCapacity:task.observers.count];
    for (ESUserInfo *user in task.observers) {
        [observerArray addObject:user.userId];
    }

    NSDictionary *param = nil;
    if (task.endDate == nil) {
        param = @{@"title":task.title,
                  @"description":task.taskDescription,
                  @"status":task.status,
                  @"chat_id":task.chatID,
                  @"person_in_charge":task.personInCharge.userId,
                  @"observers":observerArray};
    } else {
        param = @{@"title":task.title,
                  @"description":task.taskDescription,
                  @"due_date":task.endDate,
                  @"status":task.status,
                  @"chat_id":task.chatID,
                  @"person_in_charge":task.personInCharge.userId,
                  @"observers":observerArray};
    }

    [AFHttpTool requestWithMethod:RequestMethodTypePost
                     protocolType:RequestProtocolTypeJson
                              url:[NSString stringWithFormat:@"/api/assignments/%@/.json",task.taskID]
                           params:param
                          success:success
                          failure:failure];
}

+ (void)getTaskCommentListWithTaskID:(NSString *)taskID
                            listSize:(NSString *)size
                             success:(void (^)(id))success
                             failure:(void (^)(NSError *))failure {
    NSDictionary *param = nil;
    if (size != nil) {
        param = @{@"limit":size};
    }
    
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:[NSString stringWithFormat:@"/api/assignments/%@/comments/.json",taskID]
                           params:param
                          success:success
                          failure:failure];
}

+ (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(NSString *)content
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *))failure {
    NSDictionary *param = @{@"content":content};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:[NSString stringWithFormat:@"/api/assignments/%@/comments/.json",taskID]
                           params:param
                          success:success
                          failure:failure];
}

+ (void)sendTaskImageWithTaskId:(NSString *)taskID
                        comment:(ESTaskComment *)comment
                      imageData:(NSData *)imageData
                        success:(void (^)(AFHTTPRequestOperation *, id))success
                        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSURL* baseURL = [NSURL URLWithString:DEV_SERVER_ADDRESS];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;

    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if ([cookie.name isEqual:@"csrftoken"])
            {
                [manager.requestSerializer setValue:cookie.value forHTTPHeaderField:@"X-Csrftoken"];
            }
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    [manager POST:[NSString stringWithFormat:@"/api/assignments/%@/comments/%@/images/.json",taskID,[comment.commentID stringValue]]
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyyMMddHHmmss"];
                             NSString *timeStamp = [format stringFromDate:[NSDate date]];
                             NSString *picName = [timeStamp stringByAppendingString:@".png"];
                             [formData appendPartWithFileData:imageData
                                                         name:@"image"
                                                     fileName:picName
                                                   mimeType:@"image/png"];
                }
                  success:success
                  failure:failure];
    

//    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
//    
//    // 2. Create an `NSMutableURLRequest`.
//    NSMutableURLRequest *request =
//    [serializer multipartFormRequestWithMethod:@"POST"
//                                     URLString:[NSString stringWithFormat:@"http://120.25.249.144/api/assignments/%@/comments/%@/images/.json",taskID,[comment.commentID stringValue]]
//                                    parameters:nil
//                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                         NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                         [format setDateFormat:@"yyyyMMddHHmmss"];
//                         NSString *timeStamp = [format stringFromDate:[NSDate date]];
//                         NSString *picName = [timeStamp stringByAppendingString:@".png"];
//                         [formData appendPartWithFileData:[images firstObject]
//                                                     name:@"image"
//                                                 fileName:picName
//                                                 mimeType:@"image/png"];
//                     }
//                                         error:nil];
//    
//    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    manager.requestSerializer.HTTPShouldHandleCookies = YES;
//
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            if ([cookie.name isEqual:@"csrftoken"])
//            {
//                [manager.requestSerializer setValue:cookie.value forHTTPHeaderField:@"X-Csrftoken"];
//            }
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        }
//    }
//    AFHTTPRequestOperation *operation =
//    [manager HTTPRequestOperationWithRequest:request
//                                     success:success
//                                     failure:failure];
//
//    // 4. Set the progress block of the operation.
//    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
//                                        long long totalBytesWritten,
//                                        long long totalBytesExpectedToWrite) {
//        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
//    }];
//    
//    // 5. Begin!
//    [operation start];
}

+ (void)changeUserMsgWithUserInfo:(ESUserDetailInfo *)userInfo
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *))failure {
    NSDictionary *param = @{@"name":[ColorHandler isNullOrEmptyString:userInfo.userName]?@"":userInfo.userName,
                            @"email":[ColorHandler isNullOrEmptyString:userInfo.email]?@"":userInfo.email,
                            @"department":[ColorHandler isNullOrEmptyString:userInfo.department]?@"":userInfo.department,
                            @"description":[ColorHandler isNullOrEmptyString:userInfo.contactDescription]?@"":userInfo.contactDescription};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:[NSString stringWithFormat:@"/api/accounts/users/%@/.json",userInfo.userId]
                           params:param
                          success:success
                          failure:failure];
}

+ (void)changeUserImageWithId:(NSString *)userId
                         data:(NSData *)data
                      success:(void (^)(AFHTTPRequestOperation *,id))success
                      failure:(void (^)(AFHTTPRequestOperation *,NSError *))failure {
    NSURL* baseURL = [NSURL URLWithString:DEV_SERVER_ADDRESS];

    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"name": [userDefaults stringForKey:DEFAULTS_USERNAME]};
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if ([cookie.name isEqual:@"csrftoken"])
            {
                [manager.requestSerializer setValue:cookie.value forHTTPHeaderField:@"X-Csrftoken"];
            }
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    NSData *imageData = data;
    
    [manager POST:[NSString stringWithFormat:@"/api/accounts/users/%@/.json",userId]
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMddHHmmss"];
        NSString *timeStamp = [format stringFromDate:[NSDate date]];
        NSString *picName = [timeStamp stringByAppendingString:@".png"];
        [formData appendPartWithFileData:imageData
                                    name:@"avatar"
                                fileName:picName
                                mimeType:@"image/png"];
    }
          success:success
          failure:failure];
}

+ (void)parseErrorType:(NSError*) error operation:(AFHTTPRequestOperation*)operation
{
    if (error == nil || [error isEqual:[NSNull null]])
    {
        return;
    }
    NSDictionary* errUserInfo = error.userInfo ;
    
    NSString* localiedDescription = [errUserInfo objectForKey:@"NSLocalizedDescription"];
    if (localiedDescription == nil || [localiedDescription isEqual:[NSNull null]])
    {
        return;
    }
    NSRange range = [localiedDescription rangeOfString:@"403"];
//    int location = range.location;
    NSUInteger length = range.length;
    if (length > 0)
    {
        if (operation.responseObject!=nil)
        {
            NSDictionary* dic = operation.responseObject;
            NSString* errorDetail = [dic objectForKey:@"detail"];
            if ([errorDetail isEqualToString:@"Authentication credentials were not provided."])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_ERROR_MESSAGE" object:@"403"];
            }
        }
    }
}

//获取人的标签
+ (void)getTagByUserid:(NSString*)userId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/users/%@/tags/.json",userId];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:strURL
                           params:nil
                          success:success failure:failure];
}
//设置人的标签
+ (void)setUserTagByUserId:(NSString*)userId TagId:(NSString*)tagId TagItemId:(NSString*)tagitemid success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    //attr_1
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/users/%@/tags/.json",userId];
    NSString* strKey = [NSString stringWithFormat:@"attr_%@",tagId];
    NSDictionary *params = @{strKey:tagitemid};
    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:strURL
                           params:params
                          success:success failure:failure];
}

//获取企业的标签
+ (void)getTagByEnterpriseId:(NSString*)enterpriseId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprises/%@/tags/.json",enterpriseId];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:strURL
                           params:nil
                          success:success failure:failure];
}
//设置企业的标签
+ (void)setEnterpriseTagByEnterpriseId:(NSString*)enterpriseId TagId:(NSString*)tagId TagItemId:(NSString*)tagitemid success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprises/%@/tags/.json",enterpriseId];
    NSString* strKey = [NSString stringWithFormat:@"attr_%@",tagId];
    NSDictionary *params = @{strKey:tagitemid};

    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:strURL
                           params:params
                          success:success failure:failure];
}


//获取任务的标签
+ (void)getTagByTaskId:(NSString*)tagId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/assignments/%@/tags/.json",tagId];
    
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText
                              url:strURL
                           params:nil
                          success:success failure:failure];
}

//设置任务的标签
+ (void)setTaskTagByTaskId:(NSString*)taskId TagId:(NSString*)tagId TagItemId:(NSString*)tagitemid success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/assignments/%@/tags/.json",tagId];
    NSString* strKey = [NSString stringWithFormat:@"attr_%@",tagId];
    NSDictionary *params = @{strKey:tagitemid};

    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:strURL
                           params:params
                          success:success failure:failure];
}

//请求加入企业
+ (void)requestJoinEnterPriseWithUserId:(NSString*)userId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprise-requests/.json"];
    NSDictionary *params = @{@"receiver":userId};

    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText
                              url:strURL
                           params:params
                          success:success failure:failure];
}

//获取请求加入企业的人员列表
+ (void)getEnterPriseRequestList:(void (^)(id response))success
                         failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprise-requests/.json"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet       protocolType:RequestProtocolTypeText                        url:strURL  params:nil success:success failure:failure];
}

//同意加入企业
+ (void)approvedEnterPriseRequestId:(NSString*)requestId  approved:(BOOL)bApproved success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprise-requests/%@/.json",requestId];
    NSDictionary *params = @{@"approved":[NSNumber numberWithBool:bApproved]};

    [AFHttpTool requestWithMethod:RequestMethodTypePost   protocolType:RequestProtocolTypeText                           url:strURL  params:params success:success failure:failure];
}

//关注/取消关注企业
+ (void)followEnterPriseId:(NSString*)enterpriseId  action:(NSString*)action success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprises/%@/follow/.json",enterpriseId];
    NSDictionary *params = @{@"action":action};
    [AFHttpTool requestWithMethod:RequestMethodTypePost    protocolType:RequestProtocolTypeText                          url:strURL  params:params success:success failure:failure];
}

/******** 获取企业详情******
 请求方式：POST
 参数：无
 备注：该接口返回该企业的详细信息
 **/
+(void) getEnterpriseDetail:(NSString*)enterpriseId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprises/%@/.json",enterpriseId];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet   protocolType:RequestProtocolTypeText                           url:strURL  params:nil success:success failure:failure];
}

//获取关注的企业列表
+(void)getFollowedEnterpriseListSuccess:(void (^)(id response))success
                                failure:(void (^)(NSError *error))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprises/?follow"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet   protocolType:RequestProtocolTypeText                           url:strURL  params:nil success:success failure:failure];

}

/******** 搜索企业******
 参数：?q=keyWord
 请求方式：GET
 备注：如果keyWord为空，则返回所有联系人
 **/
+(void)searchEnterprises:(NSString*) keyWord success:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"q":keyWord};
    NSString* strURL = [NSString stringWithFormat:@"/api/accounts/enterprises/.json"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet  protocolType:RequestProtocolTypeText                            url:strURL  params:params success:success failure:failure];
}

//获取最新消息
+(void)getLastestMessageSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    ///api/subscriptions/latest-message/
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/latest-message/.json"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText                             url:strURL  params:nil success:success failure:failure];
    
}

//获取Rill最新的一条系统消息
+(void)getLastestRillMessageSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/latest-riil-message/.json"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText                             url:strURL  params:nil success:success failure:failure];
}

//获取Rill所有系统消息
+(void)getRillMessageListSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/.json"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet   protocolType:RequestProtocolTypeText                           url:strURL  params:nil success:success failure:failure];
}

//向Rill发送消息
+(void)replyToRillMessage:(NSString*)content sucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/.json"];
    NSDictionary *params = @{@"suggestion":content};
    [AFHttpTool requestWithMethod:RequestMethodTypePost   protocolType:RequestProtocolTypeText                           url:strURL  params:params success:success failure:failure];
}

//获取最近的一条企业消息
+(void)getLastestEnterpriseMessageSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/latest-message/.json"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet  protocolType:RequestProtocolTypeText                            url:strURL  params:nil success:success failure:failure];
}

//获取所有企业的最后一条消息列表
+(void)getAllEnterpriseLastestMessageListSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/list-latest-messages/.json"];
    [AFHttpTool requestWithMethod:RequestMethodTypeGet   protocolType:RequestProtocolTypeText                           url:strURL  params:nil success:success failure:failure];

}

//获取一个企业的所有消息
+(void)getOneEnterpriseMessage:(NSString*)enterpriseId sucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/%@/.json",enterpriseId];
    
    [AFHttpTool requestWithMethod:RequestMethodTypeGet protocolType:RequestProtocolTypeText                             url:strURL  params:nil success:success failure:failure];
}

//向企业发送消息
+(void)replyToOneEnterpriseMessage:(NSString*)enterpriseId content:(NSString*)content sucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure
{
    NSString* strURL = [NSString stringWithFormat:@"/api/subscriptions/%@/.json",enterpriseId];
    
    NSDictionary *params = @{@"suggestion":content};

    [AFHttpTool requestWithMethod:RequestMethodTypePost protocolType:RequestProtocolTypeText                             url:strURL  params:params success:success failure:failure];
}

+ (void)requestWithMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSURL* baseURL = [NSURL URLWithString:@"http://111.204.215.174:8090/adapter/"];
    //获得请求管理者
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        NSString *JSESSIONID = nil;
        NSString *SSOToken = nil;

        for (cookie in cookies) {
            if ([cookie.name  isEqual: @"JSESSIONID"] )
            {
//                [mgr.requestSerializer setValue:cookie.value forHTTPHeaderField:@"JSESSIONID"];
                JSESSIONID = cookie.value;
                //                NSLog(@"csrftoken = %@",cookie.value);
            }
            if ([cookie.name  isEqual: @"SSOToken"] )
            {
//                [mgr.requestSerializer setValue:cookie.value forHTTPHeaderField:@"SSOToken"];
                //                NSLog(@"csrftoken = %@",cookie.value);
                SSOToken = cookie.value;
            }
            
        }
        
        if (JSESSIONID != nil && SSOToken != nil)
        {
            [mgr.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@,SSOToken=%@",JSESSIONID,SSOToken] forHTTPHeaderField:@"Cookie"];
        }
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
//    NSString *JSESSIONID = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSESSIONID"];
//    NSString *SSOToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"SSOToken"];
    
//    if(![ColorHandler isNullOrEmptyString:JSESSIONID] && ![ColorHandler isNullOrEmptyString:SSOToken]) {
//        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%@;%@",JSESSIONID,SSOToken] forHTTPHeaderField:@"Cookie"];
////        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
//        [mgr.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    }
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            [mgr GET:url
          parameters:params
             success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                 if (success) {
                     success(responseObj);
                     NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject: cookiesData forKey: @"sessionCookies"];
                     [defaults synchronize];
                 }
             }
             failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                 if (failure) {
                     failure(error);
                     [AFHttpTool parseErrorType:error operation:operation];
                 }
             }];
        }
            break;
        case RequestMethodTypePost:
        {
            //POST请求
            [mgr POST:url
           parameters:params
              success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                  if (success) {
                      
//                      NSDictionary *headers = [operation.response allHeaderFields];
//                      NSString *cookieString = headers[@"Set-Cookie"];
//                      NSLog(@"!!!!!! %@",headers[@"Set-Cookie"]);
//                      NSArray *arr = [cookieString componentsSeparatedByString:@","];
                      
//                      NSString *JSESSIONID = [[[[arr[1] componentsSeparatedByString:@";"] firstObject] stringByTrimmingCharactersInSet:
//                                               [NSCharacterSet whitespaceAndNewlineCharacterSet]] substringFromIndex:11];
//                      NSString *SSOToken = [[[[arr[2] componentsSeparatedByString:@";"] firstObject] stringByTrimmingCharactersInSet:
//                                            [NSCharacterSet whitespaceAndNewlineCharacterSet]] substringFromIndex:10];
//                      NSString *JSESSIONID = [[[arr[1] componentsSeparatedByString:@";"] firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//                      NSString *SSOToken = [[[arr[2] componentsSeparatedByString:@";"] firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                      
//                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                      [defaults setObject:JSESSIONID forKey:@"JSESSIONID"];
//                      [defaults setObject:SSOToken forKey:@"SSOToken"];
//                      [defaults synchronize];
//                      
                      success(responseObj);
                      NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      [defaults setObject: cookiesData forKey: @"sessionCookies"];
                      [defaults synchronize];
                      
//                      NSString* cookieString = [[NSString alloc] initWithData:cookiesData encoding:NSUTF8StringEncoding];
//                      NSLog(@"%@",cookieString);

                      //                      NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                      //                      for (NSHTTPCookie *cookie in cookies) {
                      //                          // Here I see the correct rails session cookie
                      //                          NSLog(@"cookie: %@", cookie);
                      //                      }
                      
                  }
              } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                  if (failure) {
                      failure(error);
                      [AFHttpTool parseErrorType:error operation:operation];
                  }
              }];
        }
            break;
        default:
            break;
    }
}

+ (void)loginBMCWithUserName:(NSString *)userName
                    password:(NSString *)password
                      sucess:(void (^)(id response))success
                     failure:(void (^)(NSError* err))failure {
    NSDictionary *param = @{@"username":userName,
                            @"password":password,
                            @"_openCLIENT":@"RIIL"};
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"login"
                           params:param
                          success:success
                          failure:failure];
}

+ (void)getEmergencyListWithViewType:(NSString *)viewType
                              sucess:(void (^)(id))success
                             failure:(void (^)(NSError *))failure {
    NSDictionary *param = @{@"viewType":viewType};

    [AFHttpTool requestWithMethod:RequestMethodTypeGet
                              url:@"event/client/getEventList.json"
                           params:param
                          success:success
                          failure:failure];
}

+ (void)getMainResourceListWithTreeNodeId:(NSString *)treeNodeId
                                pageIndex:(NSString *)pageIndex
                                    state:(NSString *)state
                               sortColumn:(NSString *)sortColumn
                                 sortType:(NSString *)sortType
                                   sucess:(void (^)(id response))success
                                  failure:(void (^)(NSError* err))failure {
    NSDictionary *param = @{@"treeNodeId":treeNodeId,
                            @"pageIndex":pageIndex,
                            @"state":state,
                            @"sortColumn":sortColumn,
                            @"sortType":sortType};
    
    [AFHttpTool requestWithMethod:RequestMethodTypePost
                              url:@"res/list.json"
                           params:param
                          success:success
                          failure:failure];
}

@end
