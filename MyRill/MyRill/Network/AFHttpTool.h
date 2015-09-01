//
//  AFHttpTool.h
//  MyRill
//
//  Created by Steve on 15/6/7.
//
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@class ESTask;
@class ESUserDetailInfo;
@class ESTaskComment;

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

typedef NS_ENUM(NSInteger, RequestProtocolType){
    RequestProtocolTypeText = 0,
    RequestProtocolTypeJson = 1
};


typedef enum : NSUInteger {
    ESTaskListWithChatId = 200,
    ESTaskListWithInitiatorId,
    ESTaskListWithPersonInChargeId,
    ESTaskListStatus,
    ESTaskOverdue,
    ESTaskListQ
} ESTaskListType;

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
+ (void)requestWithMethod:(RequestMethodType)methodType protocolType:(RequestProtocolType) protocolType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure;
//sign-up
+(void) signUpWithPhoneNum:(NSString *) phoneNum
                  userName:(NSString*) userName
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

//deleteContacts
+(void) deleteContact:(NSString *)userId success:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//获取已经请求添加自己的联系人列表
+(void) getContactRequestSuccess:(void (^)(id response))success
                         failure:(void (^)(NSError *error))failure;
/******** 联系人列表******
 请求方式：GET
 参数：无
 备注：该接口返回当前用户所有的联系人信息
 **/
+ (void)getContactListSuccess:(void (^)(id response))success
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

#pragma mark - 任务模块
/****** 获取任务面板信息 ****/
+ (void)getTaskDashboardSuccess:(void (^)(id response))success
                        failure:(void (^)(NSError *error))failure;

/****** 获取任务列表 ****/
+ (void)getTaskListWithIdentify:(NSString *)identify
                           type:(ESTaskListType)taskListType
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *error))failure;

/****** 获取任务详情 ****/
+ (void)getTaskDetailWithTaskID:(NSString *)taskID
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *error))failure;

/****** 添加任务 ****/
+ (void)addTaskWithModel:(ESTask *)task
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure;

/****** 获取任务评论列表 ****/
+ (void)getTaskCommentListWithTaskID:(NSString *)taskID
                            listSize:(NSString *)size
                             success:(void (^)(id response))success
                             failure:(void (^)(NSError *error))failure;

/****** 编辑任务 ****/
+ (void)EditTaskWithTaskModel:(ESTask *)task
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *error))failure;

/****** 关闭任务 ****/
+ (void)closeTaskWithTaskID:(NSString *)taskID
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *error))failure;

/****** 提交任务评论 ****/
+ (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(NSString *)content
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *error))failure;

/****** 提交任务图片 ****/
+ (void)sendTaskImageWithTaskId:(NSString *)taskID
                        comment:(ESTaskComment *)comment
                      imageData:(NSData *)imageData
                        success:(void (^)(AFHTTPRequestOperation *,id))success
                        failure:(void (^)(AFHTTPRequestOperation *,NSError *))failure;

#pragma mark - 个人设置模块
/****** 修改密码 ****/
+ (void)changePassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure;

/****** 修改手机号 ****/
+ (void)changePhoneNum:(NSString *)newPhoneNum
      verificationCode:(NSString *)code
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

/****** 修改个人静态信息 ****/
+ (void)changeUserMsgWithUserInfo:(ESUserDetailInfo *)userInfo
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

+ (void)parseErrorType:(NSError*) error operation:(AFHTTPRequestOperation*)operation;

//获取人的标签
+ (void)getTagByUserid:(NSString*)userId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
//设置人的标签
+ (void)setUserTagByUserId:(NSString*)userId TagId:(NSString*)tagId TagItemId:(NSString*)tagitemid success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//获取企业的标签
+ (void)getTagByEnterpriseId:(NSString*)enterpriseId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
//设置企业的标签
+ (void)setEnterpriseTagByEnterpriseId:(NSString*)enterpriseId TagId:(NSString*)tagId TagItemId:(NSString*)tagitemid success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//获取任务的标签
+ (void)getTagByTaskId:(NSString*)tagId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
//设置任务的标签
+ (void)setTaskTagByTaskId:(NSString*)taskId TagId:(NSString*)tagId TagItemId:(NSString*)tagitemid success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//请求加入企业
+ (void)requestJoinEnterPriseWithUserId:(NSString*)userId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//获取请求加入企业的人员列表
+ (void)getEnterPriseRequestList:(void (^)(id response))success
failure:(void (^)(NSError *error))failure;

//同意加入企业
+ (void)approvedEnterPriseRequestId:(NSString*)requestId  approved:(BOOL)bApproved success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//关注/取消关注企业
+ (void)followEnterPriseId:(NSString*)enterpriseId  action:(NSString*)action success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/******** 获取企业详情******
 请求方式：POST
 参数：无
 备注：该接口返回该企业的详细信息
 **/
+(void)getEnterpriseDetail:(NSString*)enterpriseId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//获取关注的企业列表
+(void)getFollowedEnterpriseListSuccess:(void (^)(id response))success
                                failure:(void (^)(NSError *error))failure;

/******** 搜索企业******
 参数：?q=keyWord
 请求方式：GET
 备注：如果keyWord为空，则返回所有联系人
 **/
+(void)searchEnterprises:(NSString*) keyWord success:(void (^)(id response))success failure:(void (^)(NSError* err))failure;
//获取最新消息
+(void)getLastestMessageSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//获取Rill最新的一条系统消息
+(void)getLastestRillMessageSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//获取Rill所有系统消息
+(void)getRillMessageListSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//向Rill发送消息
+(void)replyToRillMessage:(NSString*)content sucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//获取最近的一条企业消息
+(void)getLastestEnterpriseMessageSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//获取所有企业的最后一条消息列表
+(void)getAllEnterpriseLastestMessageListSucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//获取一个企业的所有消息
+(void)getOneEnterpriseMessage:(NSString*)enterpriseId sucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

//向企业发送消息
+(void)replyToOneEnterpriseMessage:(NSString*)enterpriseId content:(NSString*)content sucess:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

@end
